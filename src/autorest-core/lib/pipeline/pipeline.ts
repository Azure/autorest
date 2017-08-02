/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { FastStringify } from "../ref/yaml";
import { JsonPath, stringify } from "../ref/jsonpath";
import { safeEval } from "../ref/safe-eval";
import { LazyPromise } from "../lazy";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { AutoRestExtension } from "./plugin-endpoint";
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { Channel } from "../message";
import { ResolveUri } from "../ref/uri";
import { ConfigurationView, GetExtension } from '../configuration';
import { DataHandleRead, DataStoreView, DataStoreViewReadonly, QuickScope } from "../data-store/data-store";
import { IFileSystem } from "../file-system";
import { EmitArtifacts } from "./artifact-emitter";
import { ComposeSwaggers, LoadLiterateSwaggerOverrides, LoadLiterateSwaggers } from './swagger-loader';

export type PipelinePlugin = (config: ConfigurationView, input: DataStoreViewReadonly, working: DataStoreView, output: DataStoreView) => Promise<DataStoreViewReadonly | void>;
interface PipelineNode {
  outputArtifact?: string;
  pluginName: string;
  configScope: JsonPath;
  inputs: string[];
};

function CreatePluginIdentity(): PipelinePlugin {
  return async (config, input) => input;
}
function CreatePluginLoader(): PipelinePlugin {
  return async (config, input, working, output) => {
    let inputs = config.InputFileUris;
    const swaggers = await LoadLiterateSwaggers(
      config,
      input,
      inputs, working);
    for (let i = 0; i < inputs.length; ++i) {
      await (await output.Write(`./${i}/_` + encodeURIComponent(inputs[i]))).Forward(swaggers[i]);
    }
  };
}
function CreatePluginMdOverrideLoader(): PipelinePlugin {
  return async (config, input, working, output) => {
    let inputs = config.InputFileUris;
    const swaggers = await LoadLiterateSwaggerOverrides(
      config,
      input,
      inputs, working);
    for (let i = 0; i < inputs.length; ++i) {
      await (await output.Write(`./${i}/_` + encodeURIComponent(inputs[i]))).Forward(swaggers[i]);
    }
  };
}

function CreatePluginTransformer(): PipelinePlugin {
  return async (config, input, working, output) => {
    const documentIdResolver: (key: string) => string = key => {
      const parts = key.split("/_");
      return parts.length === 1 ? parts[0] : decodeURIComponent(parts[parts.length - 1]);
    };
    const manipulator = new Manipulator(config);
    const files = await input.Enum();
    for (let file of files) {
      const fileIn = await input.ReadStrict(file);
      file = file.substr(file.indexOf("/output/") + "/output/".length);
      const fileOut = await manipulator.Process(fileIn, working, documentIdResolver(file));
      await (await output.Write("./" + file)).Forward(fileOut);
    }
  };
}
function CreatePluginTransformerImmediate(): PipelinePlugin {
  return async (config, input, working, output) => {
    const documentIdResolver: (key: string) => string = key => {
      const parts = key.split("/_");
      return parts.length === 1 ? parts[0] : decodeURIComponent(parts[parts.length - 1]);
    };
    const files = await input.Enum(); // first all the immediate-configs, then a single swagger-document
    const scopes = await Promise.all(files.slice(0, files.length - 1).map(f => input.ReadStrict(f)));
    const manipulator = new Manipulator(config.GetNestedConfigurationImmediate(...scopes.map(s => s.ReadObject<any>())));
    const file = files[files.length - 1];
    const fileIn = await input.ReadStrict(file);
    const fileOut = await manipulator.Process(fileIn, working, documentIdResolver(file));
    await (await output.Write("swagger-document")).Forward(fileOut);
  };
}
function CreatePluginComposer(): PipelinePlugin {
  return async (config, input, working, output) => {
    const swaggers = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
    const overrideInfo = config.GetEntry("override-info");
    const overrideTitle = (overrideInfo && overrideInfo.title) || config.GetEntry("title");
    const overrideDescription = (overrideInfo && overrideInfo.description) || config.GetEntry("description");
    const swagger = await ComposeSwaggers(config, overrideTitle, overrideDescription, swaggers, config.DataStore.CreateScope("compose"));
    await (await output.Write("composed")).Forward(swagger);
  };
}
function CreatePluginExternal(host: AutoRestExtension, pluginName: string): PipelinePlugin {
  return async (config, input, working, output) => {
    const plugin = await host;
    const pluginNames = await plugin.GetPluginNames(config.CancellationToken);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`Plugin ${pluginName} not found.`);
    }

    const result = await plugin.Process(
      pluginName,
      key => config.GetEntry(key as any),
      input,
      output,
      config.Message.bind(config),
      config.CancellationToken);
    if (!result) {
      throw new Error(`Plugin ${pluginName} reported failure.`);
    }
  };
}
function CreateCommonmarkProcessor(): PipelinePlugin {
  return async (config, input, working, output) => {
    const files = await input.Enum();
    for (let file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await ProcessCodeModel(fileIn, working);
      file = file.substr(file.indexOf("/output/") + "/output/".length);
      await (await output.Write("./" + file + "/_code-model-v1")).Forward(fileOut);
    }
  };
}
function CreateArtifactEmitter(inputOverride?: () => Promise<DataStoreViewReadonly>): PipelinePlugin {
  return async (config, input, working, output) => {
    if (inputOverride) {
      input = await inputOverride();
    }

    // clear output-folder if requested
    if (config.GetEntry("clear-output-folder" as any)) {
      config.ClearFolder.Dispatch(config.OutputFolderUri);
    }

    await EmitArtifacts(
      config,
      config.GetEntry("input-artifact" as any),
      key => ResolveUri(
        config.OutputFolderUri,
        safeEval<string>(config.GetEntry("output-uri-expr" as any), { $key: key, $config: config.Raw })),
      input,
      config.GetEntry("is-object" as any));
  };
}

function BuildPipeline(config: ConfigurationView): { pipeline: { [name: string]: PipelineNode }, configs: { [jsonPath: string]: ConfigurationView } } {
  const cfgPipeline = config.GetEntry("pipeline" as any);
  const pipeline: { [name: string]: PipelineNode } = {};
  const configCache: { [jsonPath: string]: ConfigurationView } = {};

  // Resolves a pipeline stage name using the current stage's name and the relative name.
  // It considers the actually existing pipeline stages.
  // Example:
  // (csharp/cm/transform, commonmarker)
  //    --> csharp/cm/commonmarker       if such a stage exists
  //    --> csharp/commonmarker          if such a stage exists
  //    --> commonmarker                 if such a stage exists
  //    --> THROWS                       otherwise
  const resolvePipelineStageName = (currentStageName: string, relativeName: string) => {
    while (currentStageName !== "") {
      currentStageName = currentStageName.substring(0, currentStageName.length - 1);
      currentStageName = currentStageName.substring(0, currentStageName.lastIndexOf("/") + 1);

      if (cfgPipeline[currentStageName + relativeName]) {
        return currentStageName + relativeName;
      }
    }
    throw new Error(`Cannot resolve pipeline stage '${relativeName}'.`);
  };

  // One pipeline stage can generate multiple nodes in the pipeline graph
  // if the stage is associated with a configuration scope that has multiple entries.
  // Example: multiple generator calls
  const createNodesAndSuffixes: (stageName: string) => { name: string, suffixes: string[] } = stageName => {
    const cfg = cfgPipeline[stageName];
    if (!cfg) {
      throw new Error(`Cannot find pipeline stage '${stageName}'.`);
    }
    if (cfg.suffixes) {
      return { name: stageName, suffixes: cfg.suffixes };
    }

    // derive information about given pipeline stage
    const plugin = cfg.plugin || stageName.split("/").reverse()[0];
    const outputArtifact = cfg.outputArtifact;
    const scope = cfg.scope;
    const inputs: string[] = (!cfg.input ? [] : (Array.isArray(cfg.input) ? cfg.input : [cfg.input])).map((x: string) => resolvePipelineStageName(stageName, x));

    const suffixes: string[] = [];
    // adds nodes using at least suffix `suffix`, the input nodes called `inputs` using the context `config`
    // AFTER considering all the input nodes `inputNodes`
    // Example:
    // ("", [], cfg, [{ name: "a", suffixes: ["/0", "/1"] }])
    // --> ("/0", ["a/0"], cfg of "a/0", [])
    //     --> adds node `${stageName}/0`
    // --> ("/1", ["a/1"], cfg of "a/1", [])
    //     --> adds node `${stageName}/1`
    // Note: inherits the config of the LAST input node (affects for example `.../generate`)
    const addNodesAndSuffixes = (suffix: string, inputs: string[], configScope: JsonPath, inputNodes: { name: string, suffixes: string[] }[]) => {
      if (inputNodes.length === 0) {
        const config = configCache[stringify(configScope)];
        const configs = scope ? [...config.GetNestedConfiguration(scope)] : [config];
        for (let i = 0; i < configs.length; ++i) {
          const newSuffix = configs.length === 1 ? "" : "/" + i;
          suffixes.push(suffix + newSuffix);
          const path: JsonPath = configScope.slice();
          if (scope) path.push(scope);
          if (configs.length !== 1) path.push(i);
          configCache[stringify(path)] = configs[i];
          pipeline[stageName + suffix + newSuffix] = {
            pluginName: plugin,
            outputArtifact: outputArtifact,
            configScope: path,
            inputs: inputs
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
            inputSuffixesTail);
        }
      }
    };

    configCache[stringify([])] = config;
    addNodesAndSuffixes("", [], [], inputs.map(createNodesAndSuffixes));

    return { name: stageName, suffixes: cfg.suffixes = suffixes };
  };

  for (const pipelineStepName of Object.keys(cfgPipeline)) {
    createNodesAndSuffixes(pipelineStepName);
  }

  return {
    pipeline: pipeline,
    configs: configCache
  };
}

export async function RunPipeline(configView: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  // externals (TODO: make these dynamically loaded)
  const oavPluginHost = await AutoRestExtension.FromModule(`${__dirname}/plugins/openapi-validation-tools`);

  // __status scope
  const startTime = Date.now();
  (configView.Raw as any).__status = new Proxy<any>({}, {
    async get(_, key) {
      const expr = new Buffer(key.toString(), "base64").toString("ascii");
      try {
        return FastStringify(safeEval(expr, {
          pipeline: pipeline.pipeline,
          tasks: tasks,
          startTime: startTime,
          blame: (uri: string, position: any /*TODO: cleanup, nail type*/) => configView.DataStore.Blame(uri, position)
        }));
      } catch (e) {
        return "" + e;
      }
    }
  });

  // built-in plugins
  const plugins: { [name: string]: PipelinePlugin } = {
    "identity": CreatePluginIdentity(),
    "loader": CreatePluginLoader(),
    "md-override-loader": CreatePluginMdOverrideLoader(),
    "transform": CreatePluginTransformer(),
    "transform-immediate": CreatePluginTransformerImmediate(),
    "compose": CreatePluginComposer(),
    "model-validator": CreatePluginExternal(oavPluginHost, "model-validator"),
    "semantic-validator": CreatePluginExternal(oavPluginHost, "semantic-validator"),

    "commonmarker": CreateCommonmarkProcessor(),
    "emitter": CreateArtifactEmitter(),
    "pipeline-emitter": CreateArtifactEmitter(async () => new QuickScope([await (await configView.DataStore.Write("pipeline")).WriteObject(pipeline.pipeline)])),
    "configuration-emitter": CreateArtifactEmitter(async () => new QuickScope([await (await configView.DataStore.Write("configuration")).WriteObject(configView.Raw)]))
  };

  // dynamically loaded, auto-discovered plugins
  for (const useExtension of configView.UseExtensions) {
    const extension = await GetExtension(useExtension.fullyQualified);
    for (const plugin of await extension.GetPluginNames(configView.CancellationToken)) {
      plugins[plugin] = CreatePluginExternal(extension, plugin);
    }
  }

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

  const fsInput = configView.DataStore.GetReadThroughScope(fileSystem);
  const pipeline = BuildPipeline(configView);

  const ScheduleNode: (nodeName: string) => Promise<DataStoreViewReadonly> =
    async (nodeName) => {
      const node = pipeline.pipeline[nodeName];

      if (!node) {
        throw new Error(`Cannot find pipeline node ${nodeName}.`);
      }

      // get input
      let inputScopes: DataStoreViewReadonly[] = await Promise.all(node.inputs.map(getTask));
      if (inputScopes.length === 0) {
        inputScopes = [fsInput];
      } else {
        const handles: DataHandleRead[] = [];
        for (const pscope of inputScopes) {
          const scope = await pscope;
          for (const handle of await scope.Enum()) {
            handles.push(await scope.ReadStrict(handle));
          }
        }
        inputScopes = [new QuickScope(handles)];
      }
      const inputScope = inputScopes[0];

      const config = pipeline.configs[stringify(node.configScope)];
      const pluginName = node.pluginName;
      const plugin = plugins[pluginName];
      if (!plugin) {
        throw new Error(`Plugin '${pluginName}' not found.`);
      }
      try {
        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - START` });

        const scope = config.DataStore.CreateScope(nodeName);
        const scopeWorking = scope.CreateScope("working");
        const scopeOutput = scope.CreateScope("output");
        const scopeResult = await plugin(config,
          inputScope,
          scopeWorking,
          scopeOutput) || scopeOutput;

        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - END` });
        return scopeResult;
      } catch (e) {
        config.Message({ Channel: Channel.Fatal, Text: `${nodeName} - FAILED` });
        config.Message({ Channel: Channel.Fatal, Text: `${e}` });
        throw e;
      }
    };

  // schedule pipeline
  const tasks: { [name: string]: Promise<DataStoreViewReadonly> } = {};
  const getTask = (name: string) => name in tasks ?
    tasks[name] :
    tasks[name] = ScheduleNode(name);

  // execute pipeline
  const barrier = new OutstandingTaskAwaiter();
  const barrierRobust = new OutstandingTaskAwaiter();
  for (const name of Object.keys(pipeline.pipeline)) {
    const task = getTask(name);
    const taskx: { _state: "running" | "failed" | "complete", _result: () => DataHandleRead[], _finishedAt: number } = task as any;
    taskx._state = "running";
    task.then(async x => {
      const res = await Promise.all((await x.Enum()).map(key => x.ReadStrict(key)));
      taskx._result = () => res;
      taskx._state = "complete";
      taskx._finishedAt = Date.now();
    }).catch(() => taskx._state = "failed");
    barrier.Await(task);
    barrierRobust.Await(task.catch(() => null));
  }

  try {
    await barrier.Wait();
  } catch (e) {
    // wait for outstanding nodes
    await barrierRobust.Wait();
    throw e;
  }
}