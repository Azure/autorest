import { safeEval } from '../ref/safe-eval';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { LazyPromise } from "../lazy";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { AutoRestPlugin } from "./plugin-endpoint";
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { Channel } from "../message";
import { MultiPromise } from "../multi-promise";
import { GetFilename, ResolveUri } from "../ref/uri";
import { ConfigurationView } from "../configuration";
import { DataHandleRead, DataStoreView, DataStoreViewReadonly, QuickScope } from "../data-store/data-store";
import { GetAutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { IFileSystem } from "../file-system";
import { EmitArtifacts } from "./artifact-emitter";

export type DataPromise = MultiPromise<DataHandleRead>;

type PipelinePlugin = (config: ConfigurationView, input: DataStoreViewReadonly, working: DataStoreView, output: DataStoreView) => Promise<void>;
interface PipelineNode {
  // id: string;
  outputArtifact?: string;
  pluginName: string;
  config: ConfigurationView;
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
function CreatePluginTransformer(): PipelinePlugin {
  return async (config, input, working, output) => {
    const documentIdResolver: (key: string) => string = key => {
      const parts = key.split("/_");
      return parts.length === 1 ? parts[0] : decodeURIComponent(parts[parts.length - 1]);
    };
    const manipulator = new Manipulator(config);
    const files = await input.Enum();
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await manipulator.Process(fileIn, working, documentIdResolver(file));
      await (await output.Write("./" + file)).Forward(fileOut);
    }
  };
}
function CreatePluginComposer(): PipelinePlugin {
  return async (config, input, working, output) => {
    const swaggers = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
    const swagger = config.GetEntry("override-info") || swaggers.length !== 1
      ? await ComposeSwaggers(config, config.GetEntry("override-info") || {}, swaggers, config.DataStore.CreateScope("compose"), true)
      : swaggers[0];
    await (await output.Write("swagger-document")).Forward(swagger);
  };
}
function CreatePluginExternal(host: PromiseLike<AutoRestPlugin>, pluginName: string, fullKeys: boolean = true): PipelinePlugin {
  return async (config, input, working, output) => {
    const plugin = await host;
    const pluginNames = await plugin.GetPluginNames(config.CancellationToken);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`Plugin ${pluginName} not found.`);
    }

    // forward input scope (relative/absolute key mess...)
    if (fullKeys) {
      input = new QuickScope(await Promise.all((await input.Enum()).map(x => input.ReadStrict(x))));
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
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await ProcessCodeModel(fileIn, working);
      await (await output.Write("./" + file + "/_code-model-v1")).Forward(fileOut);
    }
  };
}
function CreateArtifactEmitter(): PipelinePlugin {
  return async (config, input, working, output) => {
    return EmitArtifacts(
      config,
      config.GetEntry("input-artifact" as any),
      key => ResolveUri(
        config.OutputFolderUri,
        safeEval<string>(config.GetEntry("output-uri-expr" as any), { $key: key, $config: config.Raw })),
      input,
      config.GetEntry("is-object" as any));
  };
}

function* WithIndex<T>(collection: Iterable<T>): Iterable<[T, number]> {
  let idx = 0;
  for (const x of collection) {
    yield [x, idx++];
  }
}

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  // externals:
  const oavPluginHost = new LazyPromise(async () => await AutoRestPlugin.FromModule(`${__dirname}/plugins/openapi-validation-tools`));
  const autoRestDotNet = new LazyPromise(async () => await GetAutoRestDotNetPlugin());

  // TODO: enhance with custom declared plugins
  const plugins: { [name: string]: PipelinePlugin } = {
    "loader": CreatePluginLoader(),
    "transform": CreatePluginTransformer(),
    "compose": CreatePluginComposer(),
    "model-validator": CreatePluginExternal(oavPluginHost, "model-validator"),
    "semantic-validator": CreatePluginExternal(oavPluginHost, "semantic-validator"),
    "azure-validator": CreatePluginExternal(autoRestDotNet, "azure-validator"),
    "modeler": CreatePluginExternal(autoRestDotNet, "modeler"),

    "csharp": CreatePluginExternal(autoRestDotNet, "csharp"),
    "ruby": CreatePluginExternal(autoRestDotNet, "ruby"),
    "nodejs": CreatePluginExternal(autoRestDotNet, "nodejs"),
    "python": CreatePluginExternal(autoRestDotNet, "python"),
    "go": CreatePluginExternal(autoRestDotNet, "go"),
    "java": CreatePluginExternal(autoRestDotNet, "java"),
    "azureresourceschema": CreatePluginExternal(autoRestDotNet, "azureresourceschema"),
    "csharp-simplifier": CreatePluginExternal(autoRestDotNet, "csharp-simplifier", false),

    "commonmarker": CreateCommonmarkProcessor(),
    "emitter": CreateArtifactEmitter()
  };

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

  // to be replaced with scheduler
  let scopeCtr = 0;
  const RunPlugin: (config: ConfigurationView, pluginName: string, inputScope: DataStoreViewReadonly) => Promise<DataStoreViewReadonly> =
    async (config, pluginName, inputScope) => {
      if (!config) {
        throw new Error(`Invalid configuration.`);
      }
      const plugin = plugins[pluginName];
      if (!plugin) {
        throw new Error(`Plugin '${pluginName}' not found.`);
      }
      try {
        config.Message({ Channel: Channel.Debug, Text: `${pluginName} - START` });

        const scope = config.DataStore.CreateScope(`${++scopeCtr}_${pluginName}`);
        const scopeWorking = scope.CreateScope("working");
        const scopeOutput = scope.CreateScope("output");
        await plugin(config,
          inputScope,
          scopeWorking,
          scopeOutput);

        config.Message({ Channel: Channel.Debug, Text: `${pluginName} - END` });
        return scopeOutput;
      } catch (e) {
        config.Message({ Channel: Channel.Fatal, Text: `${pluginName} - FAILED` });
        throw e;
      }
    };

  const artSD = "swagger-document";
  const artCM = "code-model-v1";

  //Build pipeline
  const pipeline: { [name: string]: PipelineNode } = {};
  pipeline["loader"] = {
    pluginName: "loader",
    outputArtifact: artSD,
    config: config,
    inputs: []
  };
  pipeline["transform-swagger-document-individual"] = {
    pluginName: "transform",
    outputArtifact: artSD,
    config: config,
    inputs: ["loader"]
  };
  pipeline["compose"] = {
    pluginName: "compose",
    outputArtifact: artSD,
    config: config,
    inputs: ["transform-swagger-document-individual"]
  };
  pipeline["transform-swagger-document-composed"] = {
    pluginName: "transform",
    outputArtifact: artSD,
    config: config,
    inputs: ["compose"]
  };

  for (const [cfg, idx] of WithIndex(config.GetPluginViews("emit-swagger-document"))) {
    pipeline[`emit-swagger-document-${idx}`] = {
      pluginName: "emitter",
      config: cfg,
      inputs: ["transform-swagger-document-composed"]
    };
  }
  for (const [cfg, idx] of WithIndex(config.GetPluginViews("model-validator"))) {
    pipeline[`model-validator-${idx}`] = {
      pluginName: "model-validator",
      config: cfg,
      inputs: ["transform-swagger-document-composed"]
    };
  }
  for (const [cfg, idx] of WithIndex(config.GetPluginViews("semantic-validator"))) {
    pipeline[`semantic-validator-${idx}`] = {
      pluginName: "semantic-validator",
      config: cfg,
      inputs: ["transform-swagger-document-composed"]
    };
  }
  for (const [cfg, idx] of WithIndex(config.GetPluginViews("azure-validator"))) {
    pipeline[`azure-validator-${idx}`] = {
      pluginName: "azure-validator",
      config: cfg,
      inputs: ["transform-swagger-document-composed"]
    };
  }

  const allCodeGenerators = ["csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema"];

  for (const codeGenerator of allCodeGenerators) {
    for (const [genConfig, idx] of WithIndex(config.GetPluginViews(codeGenerator))) {

      pipeline[`modeler-${codeGenerator}-${idx}`] = {
        pluginName: "modeler",
        outputArtifact: artCM,
        config: genConfig,
        inputs: ["transform-swagger-document-composed"]
      };
      pipeline[`commonmarker-${codeGenerator}-${idx}`] = {
        pluginName: "commonmarker",
        outputArtifact: artCM,
        config: genConfig,
        inputs: [`modeler-${codeGenerator}-${idx}`]
      };
      pipeline[`transform-${codeGenerator}-${idx}`] = {
        pluginName: "transform",
        outputArtifact: artCM,
        config: genConfig,
        inputs: [`commonmarker-${codeGenerator}-${idx}`]
      };
      for (const [cfg, idxx] of WithIndex(genConfig.GetPluginViews("emit-code-model-v1"))) {
        pipeline[`emit-code-model-v1-${codeGenerator}-${idx}-${idxx}`] = {
          pluginName: "emitter",
          config: cfg,
          inputs: [`transform-${codeGenerator}-${idx}`]
        };
      }
      pipeline[`${codeGenerator}-${idx}`] = {
        pluginName: codeGenerator,
        outputArtifact: `source-file-${codeGenerator}`,
        config: genConfig,
        inputs: ["transform-swagger-document-composed", `transform-${codeGenerator}-${idx}`]
      };

      if (codeGenerator === "csharp") {
        pipeline[`simplify-${codeGenerator}-${idx}`] = {
          pluginName: "csharp-simplifier",
          outputArtifact: `source-file-${codeGenerator}`,
          config: genConfig,
          inputs: [`${codeGenerator}-${idx}`]
        };
      }

      pipeline[`transform-sources-${codeGenerator}-${idx}`] = {
        pluginName: "transform",
        outputArtifact: `source-file-${codeGenerator}`,
        config: genConfig,
        inputs: [codeGenerator === "csharp" ? `simplify-${codeGenerator}-${idx}` : `${codeGenerator}-${idx}`]
      };

      for (const [cfg, idxx] of WithIndex(genConfig.GetPluginViews(`emit-source-file-${codeGenerator}`))) {
        pipeline[`emit-source-file-${codeGenerator}-${idx}-${idxx}`] = {
          pluginName: "emitter",
          config: cfg,
          inputs: [`transform-sources-${codeGenerator}-${idx}`]
        };
      }
    }
  }

  // schedule pipeline
  const tasks: { [name: string]: Promise<DataStoreViewReadonly> } = {};
  const getTask = (name: string) => {
    if (name in tasks) {
      return tasks[name];
    }
    const node = pipeline[name];

    // get input
    let inputScopes: Promise<DataStoreViewReadonly>[] = node.inputs.map(x => getTask(x));
    if (inputScopes.length === 0) {
      inputScopes = [Promise.resolve(config.DataStore.GetReadThroughScopeFileSystem(fileSystem))];
    }
    if (inputScopes.length > 1) {
      const inputScopesPrev = inputScopes;
      inputScopes = [(async () => {
        const handles: DataHandleRead[] = [];
        for (const pscope of inputScopesPrev) {
          const scope = await pscope;
          for (const handle of await scope.Enum()) {
            handles.push(await scope.ReadStrict(handle));
          }
        }
        return new QuickScope(handles);
      })()];
    }

    return tasks[name] = (async () => RunPlugin(node.config, node.pluginName, await inputScopes[0]))();
  };


  // execute pipeline
  const barrier = new OutstandingTaskAwaiter();
  for (const name of Object.keys(pipeline)) {
    barrier.Await(getTask(name));
  }
  await barrier.Wait();
}
