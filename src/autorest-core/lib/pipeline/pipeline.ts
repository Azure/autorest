/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { JsonPath, stringify } from "../ref/jsonpath";
import { safeEval } from "../ref/safe-eval";
import { LazyPromise } from "../lazy";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { AutoRestPlugin } from "./plugin-endpoint";
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { Channel } from "../message";
import { MultiPromise } from "../multi-promise";
import { ResolveUri } from "../ref/uri";
import { ConfigurationView } from "../configuration";
import { DataHandleRead, DataStoreView, DataStoreViewReadonly, QuickScope } from "../data-store/data-store";
import { GetAutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers, LoadLiterateSwaggerOverrides } from "./swagger-loader";
import { IFileSystem } from "../file-system";
import { EmitArtifacts } from "./artifact-emitter";

export type DataPromise = MultiPromise<DataHandleRead>;

export type PipelinePlugin = (config: ConfigurationView, input: DataStoreViewReadonly, working: DataStoreView, output: DataStoreView) => Promise<void>;
interface PipelineNode {
  outputArtifact?: string;
  pluginName: string;
  configScope: JsonPath;
  inputs: string[];
};

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
    const manipulator = new Manipulator(config.GetPluginViewImmediate(...scopes.map(s => s.ReadObject<any>())));
    const file = files[files.length - 1];
    const fileIn = await input.ReadStrict(file);
    const fileOut = await manipulator.Process(fileIn, working, documentIdResolver(file));
    await (await output.Write("swagger-document")).Forward(fileOut);
  };
}
function CreatePluginComposer(): PipelinePlugin {
  return async (config, input, working, output) => {
    const swaggers = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
    const swagger = config.GetEntry("override-info") || swaggers.length !== 1
      ? await ComposeSwaggers(config, config.GetEntry("override-info") || {}, swaggers, config.DataStore.CreateScope("compose"), true)
      : swaggers[0];
    await (await output.Write("composed")).Forward(swagger);
  };
}
function CreatePluginExternal(host: PromiseLike<AutoRestPlugin>, pluginName: string): PipelinePlugin {
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
    return EmitArtifacts(
      config,
      config.GetEntry("input-artifact" as any),
      key => ResolveUri(
        config.OutputFolderUri,
        safeEval<string>(config.GetEntry("output-uri-expr" as any), { $key: key, $config: config.Raw })),
      inputOverride ? await inputOverride() : input,
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

  const pipeline = BuildPipeline(configView);
  const fsInput = configView.DataStore.GetReadThroughScopeFileSystem(fileSystem);

  // externals:
  const oavPluginHost = new LazyPromise(async () => await AutoRestPlugin.FromModule(`${__dirname}/plugins/openapi-validation-tools`));
  const aoavPluginHost = new LazyPromise(async () => await AutoRestPlugin.FromModule(`${__dirname}/../../node_modules/azure-openapi-validator`));
  const autoRestDotNet = new LazyPromise(async () => await GetAutoRestDotNetPlugin());

  // TODO: enhance with custom declared plugins
  const plugins: { [name: string]: PipelinePlugin } = {
    "loader": CreatePluginLoader(),
    "md-override-loader": CreatePluginMdOverrideLoader(),
    "transform": CreatePluginTransformer(),
    "transform-immediate": CreatePluginTransformerImmediate(),
    "compose": CreatePluginComposer(),
    "model-validator": CreatePluginExternal(oavPluginHost, "model-validator"),
    "semantic-validator": CreatePluginExternal(oavPluginHost, "semantic-validator"),
    "azure-validator": CreatePluginExternal(autoRestDotNet, "azure-validator"),
    "azure-openapi-validator": CreatePluginExternal(aoavPluginHost, "azure-openapi-validator"),
    "modeler": CreatePluginExternal(autoRestDotNet, "modeler"),

    "csharp": CreatePluginExternal(autoRestDotNet, "csharp"),
    "ruby": CreatePluginExternal(autoRestDotNet, "ruby"),
    "nodejs": CreatePluginExternal(autoRestDotNet, "nodejs"),
    "python": CreatePluginExternal(autoRestDotNet, "python"),
    "go": CreatePluginExternal(autoRestDotNet, "go"),
    "java": CreatePluginExternal(autoRestDotNet, "java"),
    "azureresourceschema": CreatePluginExternal(autoRestDotNet, "azureresourceschema"),
    "jsonrpcclient": CreatePluginExternal(autoRestDotNet, "jsonrpcclient"),
    "csharp-simplifier": CreatePluginExternal(autoRestDotNet, "csharp-simplifier"),

    "commonmarker": CreateCommonmarkProcessor(),
    "emitter": CreateArtifactEmitter(),
    "pipeline-emitter": CreateArtifactEmitter(async () => new QuickScope([await (await configView.DataStore.Write("pipeline")).WriteObject(pipeline.pipeline)]))
  };

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

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
        // note the fact that QuickScope returns absolute keys...
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
        await plugin(config,
          inputScope,
          scopeWorking,
          scopeOutput);

        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - END` });
        return scopeOutput;
      } catch (e) {
        config.Message({ Channel: Channel.Fatal, Text: `${nodeName} - FAILED` });
        throw e;
      }
    };

  // schedule pipeline
  const tasks: { [name: string]: Promise<DataStoreViewReadonly> } = {};
  const getTask = (name: string) => name in tasks ?
    tasks[name] :
    tasks[name] = (async () => ScheduleNode(name))();

  // execute pipeline
  const barrier = new OutstandingTaskAwaiter();
  for (const name of Object.keys(pipeline.pipeline)) {
    barrier.Await(getTask(name));
  }
  await barrier.Wait();
}