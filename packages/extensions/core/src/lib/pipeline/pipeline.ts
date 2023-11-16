/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/* eslint-disable @typescript-eslint/no-use-before-define */

import { createHash } from "crypto";
import { promisify } from "util";
import {
  DataHandle,
  DataSource,
  IFileSystem,
  QuickDataSource,
  createSandbox,
  PipeState,
  mergePipeStates,
} from "@azure-tools/datastore";
import { serializeJsonPointer } from "@azure-tools/json";
import { last, mapValues, omitBy } from "lodash";
import { AutorestContext } from "../context";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { CORE_PLUGIN_MAP } from "../plugins";
import { createArtifactEmitterPlugin } from "../plugins/emitter";
import { buildPipeline, PipelineNode } from "./pipeline-builder";
import { isCached, readCache, writeCache } from "./pipeline-cache";
import { loadPlugins } from "./plugin-loader";

const safeEval = createSandbox();
const setImmediatePromise = promisify(setImmediate);

const md5 = (content: any) => (content ? createHash("md5").update(JSON.stringify(content)).digest("hex") : undefined);

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
              handles.push(await scope.readStrict(handle));
            }
          }
          inputScope = new QuickDataSource(handles, pipeState);
        }
        break;
    }

    const context = pipeline.configs[serializeJsonPointer(node.configScope)];
    const pluginName = node.pluginName;

    // you can have --pass-thru:FOO on the command line
    // or add pass-thru: true in a pipline configuration step.
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const configEntry = context.GetEntry(last(node.configScope)!.toString());
    const passthru =
      configEntry?.["pass-thru"] === true || configView.config["pass-thru"]?.find((x) => x === pluginName);
    const usenull =
      configEntry?.["null"] === true || configView.GetEntry("null")?.find((x: string) => x === pluginName);

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
      context.debug(`${nodeName} - SKIPPING`);
      return inputScope;
    }
    let cacheKey: string | undefined;

    if (context.config.cachingEnabled) {
      // generate the key used to store/access cached content
      const names = await inputScope.Enum();
      const data = (
        await Promise.all(names.map((name) => inputScope.readStrict(name).then((uri) => md5(uri.readData()))))
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
      context.log({
        level: times ? "information" : "debug",
        message: `${nodeName} - CACHED inputs = ${(await inputScope.enum()).length} [0.0 s]`,
      });

      return await readCache(cacheKey, context.DataStore.getDataSink(node.outputArtifact));
    }

    const t1 = process.uptime() * 100;
    context.log({
      level: times ? "information" : "debug",
      message: `${nodeName} - START inputs = ${(await inputScope.enum()).length}`,
    });

    // creates the actual plugin.
    const scopeResult = await plugin(context, inputScope, context.DataStore.getDataSink(node.outputArtifact));
    const t2 = process.uptime() * 100;

    const memSuffix = context.config.debug ? `[${Math.round(process.memoryUsage().heapUsed / 1024 / 1024)} MB]` : "";
    context.log({
      level: times ? "information" : "debug",
      message: `${nodeName} - END [${Math.floor(t2 - t1) / 100} s]${memSuffix}`,
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

    // Yield the event loop.
    await setImmediatePromise();

    return scopeResult;
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
