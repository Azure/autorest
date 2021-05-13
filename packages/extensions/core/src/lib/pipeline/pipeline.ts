/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/* eslint-disable @typescript-eslint/no-use-before-define */

import {
  DataHandle,
  DataSource,
  IFileSystem,
  JsonPath,
  QuickDataSource,
  createSandbox,
  stringify,
  PipeState,
  mergePipeStates,
} from "@azure-tools/datastore";
import { AutorestContext } from "../context";
import { Channel } from "../message";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";

import { createArtifactEmitterPlugin } from "../plugins/emitter";
import { createHash } from "crypto";
import { isCached, readCache, writeCache } from "./pipeline-cache";
import { values } from "@azure-tools/linq";
import { CORE_PLUGIN_MAP } from "../plugins";
import { loadPlugins, PipelinePluginDefinition } from "./plugin-loader";
import { mapValues, omitBy } from "lodash";

const safeEval = createSandbox();

const md5 = (content: any) => (content ? createHash("md5").update(JSON.stringify(content)).digest("hex") : undefined);

interface PipelineNode {
  outputArtifact?: string;
  pluginName: string;
  configScope: JsonPath;
  inputs: Array<string>;
  skip: boolean;
  requireDrain?: boolean;
  dependencies: Array<PipelineNode>;
}

function buildPipeline(
  context: AutorestContext,
  plugins: { [key: string]: PipelinePluginDefinition },
): { pipeline: { [name: string]: PipelineNode }; configs: { [jsonPath: string]: AutorestContext } } {
  const cfgPipeline = context.GetEntry("pipeline");
  const pipeline: { [name: string]: PipelineNode } = {};
  const configCache: { [jsonPath: string]: AutorestContext } = {};

  // Resolves a pipeline stage name using the current stage's name and the relative name.
  // It considers the actually existing pipeline stages.
  // Example:
  // (csharp/cm/transform, commonmarker)
  //    --> csharp/cm/commonmarker       if such a stage exists
  //    --> csharp/commonmarker          if such a stage exists
  //    --> commonmarker                 if such a stage exists
  //    --> THROWS                       otherwise
  const resolvePipelineStageName = (currentStageName: string, relativeName: string) => {
    let stageName = currentStageName;
    const stageTried: string[] = [];
    while (stageName !== "") {
      stageName = stageName.substring(0, stageName.length - 1);
      stageName = stageName.substring(0, stageName.lastIndexOf("/") + 1);

      const resolvedStageName = stageName + relativeName;
      stageTried.push(resolvedStageName);
      if (cfgPipeline[resolvedStageName]) {
        return resolvedStageName;
      }
    }
    const search = stageTried.map((x) => ` - ${x}`).join("\n");
    throw new Error(
      `Cannot resolve pipeline stage '${relativeName}' for stage '${currentStageName}'. Looked for pipeline stages:\n${search}\n`,
    );
  };

  // One pipeline stage can generate multiple nodes in the pipeline graph
  // if the stage is associated with a configuration scope that has multiple entries.
  // Example: multiple generator calls
  const createNodesAndSuffixes: (stageName: string) => { name: string; suffixes: Array<string> } = (stageName) => {
    const cfg = cfgPipeline[stageName];
    if (!cfg) {
      throw new Error(`Cannot find pipeline stage '${stageName}'.`);
    }
    if (cfg.suffixes) {
      return { name: stageName, suffixes: cfg.suffixes };
    }

    // derive information about given pipeline stage
    const pluginName = cfg.plugin || stageName.split("/").reverse()[0];
    const plugin = plugins[pluginName];
    const outputArtifact = cfg["output-artifact"];
    let scope = cfg.scope;
    if (!cfg.scope) {
      scope = `pipeline.${stageName}`;
    }
    const inputs: Array<string> = (!cfg.input
      ? []
      : Array.isArray(cfg.input)
      ? cfg.input
      : [cfg.input]
    ).map((x: string) => resolvePipelineStageName(stageName, x));

    const suffixes: Array<string> = [];
    // adds nodes using at least suffix `suffix`, the input nodes called `inputs` using the context `config`
    // AFTER considering all the input nodes `inputNodes`
    // Example:
    // ("", [], cfg, [{ name: "a", suffixes: ["/0", "/1"] }])
    // --> ("/0", ["a/0"], cfg of "a/0", [])
    //     --> adds node `${stageName}/0`
    // --> ("/1", ["a/1"], cfg of "a/1", [])
    //     --> adds node `${stageName}/1`
    // Note: inherits the config of the LAST input node (affects for example `.../generate`)
    const addNodesAndSuffixes = (
      suffix: string,
      inputs: Array<string>,
      configScope: JsonPath,
      inputNodes: Array<{ name: string; suffixes: Array<string> }>,
    ) => {
      if (inputNodes.length === 0) {
        const config = configCache[stringify(configScope)];
        const configs = scope ? [...config.getNestedConfiguration(scope, plugin)] : [config];
        for (let i = 0; i < configs.length; ++i) {
          const newSuffix = configs.length === 1 ? "" : "/" + i;
          suffixes.push(suffix + newSuffix);
          const path: JsonPath = configScope.slice();
          if (scope) {
            path.push(scope);
          }
          if (configs.length !== 1) {
            path.push(i);
          }
          configCache[stringify(path)] = configs[i];
          pipeline[stageName + suffix + newSuffix] = {
            pluginName: pluginName,
            outputArtifact,
            configScope: path,
            inputs,
            dependencies: [],
            skip: false,
          };
        }
      } else {
        const inputSuffixesHead = inputNodes[0];
        const inputSuffixesTail = inputNodes.slice(1);
        for (const inputSuffix of inputSuffixesHead.suffixes) {
          const additionalInput = inputSuffixesHead.name + inputSuffix;
          addNodesAndSuffixes(
            suffix + inputSuffix,
            inputs.concat([additionalInput]),
            pipeline[additionalInput].configScope,
            inputSuffixesTail,
          );
        }
      }
    };

    configCache[stringify([])] = context;
    addNodesAndSuffixes("", [], [], inputs.map(createNodesAndSuffixes));

    return { name: stageName, suffixes: (cfg.suffixes = suffixes) };
  };

  for (const pipelineStepName of Object.keys(cfgPipeline)) {
    createNodesAndSuffixes(pipelineStepName);
  }

  return {
    pipeline,
    configs: configCache,
  };
}

function isDrainRequired(p: PipelineNode) {
  if (p.requireDrain && p.dependencies) {
    for (const each of p.dependencies) {
      if (!isDrainRequired(each)) {
        return false;
      }
    }
    return true;
  }
  return false;
}

export async function runPipeline(configView: AutorestContext, fileSystem: IFileSystem): Promise<void> {
  const plugins = await loadPlugins(configView);
  const __extensionExtension = mapValues(
    omitBy(plugins, (x) => x.builtIn),
    (x) => x.extension,
  );

  // __status scope
  const startTime = Date.now();
  configView.config.raw.__status = new Proxy<any>(
    {},
    {
      get(_, key) {
        if (key === "__info") {
          return false;
        }
        const expr = Buffer.from(key.toString(), "base64").toString("ascii");
        try {
          return JSON.stringify(
            safeEval(expr, {
              pipeline: pipeline.pipeline,
              external: __extensionExtension,
              tasks,
              startTime,
              blame: (uri: string, position: any /*TODO: cleanup, nail type*/) => {
                return configView.DataStore.blame(uri, position);
              },
            }),
            (k, v) => (k === "dependencies" ? undefined : v),
            2,
          );
        } catch (e) {
          return `${e}`;
        }
      },
    },
  );

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

  const fsInput = configView.DataStore.getReadThroughScope(fileSystem);
  const pipeline = buildPipeline(configView, plugins);
  const times = !!configView.config["timestamp"];
  const tasks: { [name: string]: Promise<DataSource> } = {};

  const pipelineEmitterPlugin = createArtifactEmitterPlugin(
    async (context) =>
      new QuickDataSource([
        await context.DataStore.getDataSink().writeObject("pipeline", pipeline.pipeline, ["fix-me-3"], "pipeline"),
      ]),
  );

  const ScheduleNode: (nodeName: string) => Promise<DataSource> = async (nodeName) => {
    const node = pipeline.pipeline[nodeName];
    if (!node) {
      throw new Error(`Cannot find pipeline node ${nodeName}.`);
    }

    // get input
    // eslint-disable-next-line @typescript-eslint/no-use-before-define
    const inputScopes: Array<DataSource> = await Promise.all(node.inputs.map(getTask));

    let inputScope: DataSource;
    switch (inputScopes.length) {
      case 0:
        inputScope = fsInput;
        break;
      case 1:
        inputScope = await inputScopes[0];
        break;
      default:
        {
          let pipeState: PipeState = {};

          const handles: Array<DataHandle> = [];
          for (const pscope of inputScopes) {
            const scope = await pscope;
            pipeState = mergePipeStates(pipeState, scope.pipeState);
            for (const handle of await scope.Enum()) {
              handles.push(await scope.ReadStrict(handle));
            }
          }
          inputScope = new QuickDataSource(handles, pipeState);
        }
        break;
    }

    const context = pipeline.configs[stringify(node.configScope)];
    const pluginName = node.pluginName;

    // you can have --pass-thru:FOO on the command line
    // or add pass-thru: true in a pipline configuration step.
    const configEntry = context.GetEntry(node.configScope.last.toString());
    const passthru =
      configEntry?.["pass-thru"] === true ||
      values(configView.GetEntry("pass-thru")).any((each) => each === pluginName);
    const usenull =
      configEntry?.["null"] === true || values(configView.GetEntry("null")).any((each) => each === pluginName);

    const plugin = usenull
      ? CORE_PLUGIN_MAP.null
      : passthru
      ? CORE_PLUGIN_MAP.identity
      : pluginName === "pipeline-emitter"
      ? pipelineEmitterPlugin
      : plugins[pluginName]?.plugin;

    if (!plugin) {
      throw new Error(`Plugin '${pluginName}' not found.`);
    }

    if (inputScope.skip) {
      context.Message({ Channel: Channel.Debug, Text: `${nodeName} - SKIPPING` });
      return inputScope;
    }
    try {
      let cacheKey: string | undefined;

      if (context.config.cachingEnabled) {
        // generate the key used to store/access cached content
        const names = await inputScope.Enum();
        const data = (
          await Promise.all(names.map((name) => inputScope.ReadStrict(name).then((uri) => md5(uri.ReadData()))))
        ).sort();

        cacheKey = md5([context.configFileFolderUri, nodeName, ...data].join("«"));
      }

      // if caching is enabled, see if we can find a scopeResult in the cache first.
      // key = inputScope names + md5(inputScope content)
      if (
        context.config.cachingEnabled &&
        inputScope.cachable &&
        context.config.cacheExclude.indexOf(nodeName) === -1 &&
        (await isCached(cacheKey))
      ) {
        // shortcut -- get the outputs directly from the cache.
        context.Message({
          Channel: times ? Channel.Information : Channel.Debug,
          Text: `${nodeName} - CACHED inputs = ${(await inputScope.Enum()).length} [0.0 s]`,
        });

        return await readCache(cacheKey, context.DataStore.getDataSink(node.outputArtifact));
      }

      const t1 = process.uptime() * 100;
      context.Message({
        Channel: times ? Channel.Information : Channel.Debug,
        Text: `${nodeName} - START inputs = ${(await inputScope.Enum()).length}`,
      });

      // creates the actual plugin.
      const scopeResult = await plugin(context, inputScope, context.DataStore.getDataSink(node.outputArtifact));
      const t2 = process.uptime() * 100;

      context.Message({
        Channel: times ? Channel.Information : Channel.Debug,
        Text: `${nodeName} - END [${Math.floor(t2 - t1) / 100} s]`,
      });

      // if caching is enabled, let's cache this scopeResult.
      if (context.config.cachingEnabled && cacheKey) {
        await writeCache(cacheKey, scopeResult);
      }
      // if this node wasn't able to load from the cache, then subsequent nodes shall not either
      if (!inputScope.cachable || context.config.cacheExclude.indexOf(nodeName) !== -1) {
        try {
          scopeResult.cachable = false;
        } catch {
          // not settable on fs inputs anyway.
        }
      }

      return scopeResult;
    } catch (e) {
      if (configView.config.debug) {
        // eslint-disable-next-line no-console
        console.error(`${__filename} - FAILURE ${JSON.stringify(e)}`);
      }
      throw e;
    }
  };

  // schedule pipeline

  const getTask = (name: string) => (name in tasks ? tasks[name] : (tasks[name] = ScheduleNode(name)));

  // execute pipeline
  const barrier = new OutstandingTaskAwaiter();
  const barrierRobust = new OutstandingTaskAwaiter();

  for (const name of Object.keys(pipeline.pipeline)) {
    const node = pipeline.pipeline[name];
    node.dependencies = new Array<PipelineNode>();

    // find nodes that list this as a antecedent
    for (const k of Object.keys(pipeline.pipeline)) {
      // does anyone take this as an input?
      const candidate = pipeline.pipeline[k];
      if (candidate.inputs.indexOf(name)) {
        node.dependencies.push(candidate);
      }
    }
  }
  for (const name of Object.keys(pipeline.pipeline)) {
    // walk thru the list of nodes, and if a given node is skipable beacuse nobody is consuming it
    // we'll mark it skip: true
    const node = pipeline.pipeline[name];
    if (isDrainRequired(node)) {
      node.skip = true;
    }
  }
  /*
  we should be able to look at all the tasks,
  recursively find out who the children are of a given task
  and then find out if they all have requireDrain === false
  and f
  for (const name of Object.keys(pipeline.pipeline)) {
    const node = pipeline.pipeline[name];
    if (node.requireDrain === true) {
      for (const k of Object.keys(pipeline.pipeline) ) {
        // does anyone take this as an input?
        const candidate= pipeline.pipeline[k];
        if( candidate.inputs.indexOf(name)  )
      }
    }
  }
*/
  for (const name of Object.keys(pipeline.pipeline)) {
    const task = getTask(name);

    const taskx: { _state: "running" | "failed" | "complete"; _result(): Array<DataHandle>; _finishedAt: number } = <
      any
    >task;
    taskx._state = "running";
    task
      .then(async (x) => {
        const res = await Promise.all((await x.Enum()).map((key) => x.ReadStrict(key)));
        taskx._result = () => res;
        taskx._state = "complete";
        taskx._finishedAt = Date.now();
      })
      .catch(() => (taskx._state = "failed"));
    barrier.await(task);
    barrierRobust.await(task.catch(() => {}));
  }

  try {
    await barrier.wait();
    await emitStats(configView);
  } catch (e) {
    // wait for outstanding nodes
    try {
      await barrierRobust.wait();
    } catch {
      // wait for others to fail or whatever...
    }
    throw e;
  }
}

async function emitStats(context: AutorestContext) {
  const plugin = createArtifactEmitterPlugin(
    async () =>
      new QuickDataSource([
        await context.DataStore.getDataSink().writeObject(
          "stats.json",
          context.stats.getAll(),
          ["stats"],
          "stats.json",
        ),
      ]),
  );
  await plugin(context, new QuickDataSource([]), context.DataStore.getDataSink());
}
