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
type PipelineNode = { id: string, outputArtifact: string, plugin: PipelinePlugin, inputs: PipelineNode[] };

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

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const barrier = new OutstandingTaskAwaiter();

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

    "commonmarker": CreateCommonmarkProcessor()
  };

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

  // to be replaced with scheduler
  let scopeCtr = 0;
  const RunPlugin: (config: ConfigurationView, pluginName: string, inputScope: DataStoreViewReadonly) => Promise<DataStoreViewReadonly> =
    async (config, pluginName, inputScope) => {
      const plugin = plugins[pluginName];
      if (!plugin) {
        throw `Plugin '${pluginName}' not found.`;
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

  const scopeLoadedSwaggers = await RunPlugin(config, "loader", config.DataStore.GetReadThroughScopeFileSystem(fileSystem));
  const scopeLoadedSwaggersTransformed = await RunPlugin(config, "transform", scopeLoadedSwaggers);
  const scopeComposedSwagger = await RunPlugin(config, "compose", scopeLoadedSwaggersTransformed);
  const scopeComposedSwaggerTransformed = await RunPlugin(config, "transform", scopeComposedSwagger);

  {
    const relPath =
      config.GetEntry("output-file") || // TODO: overthink
      (config.GetEntry("namespace") ? config.GetEntry("namespace") : GetFilename(config.InputFileUris[0]).replace(/\.json$/, ""));
    barrier.Await(EmitArtifacts(config, "swagger-document", _ => ResolveUri(config.OutputFolderUri, relPath), new LazyPromise(async () => scopeComposedSwaggerTransformed), true));
  }

  if (config.GetEntry("model-validator")) {
    barrier.Await(RunPlugin(config, "model-validator", scopeComposedSwaggerTransformed));
  }
  if (config.GetEntry("semantic-validator")) {
    barrier.Await(RunPlugin(config, "semantic-validator", scopeComposedSwaggerTransformed));
  }
  if (config.GetEntry("azure-validator")) {
    barrier.Await(RunPlugin(config, "azure-validator", scopeComposedSwaggerTransformed));
  }

  const allCodeGenerators = ["csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema"];

  // code generators
  for (const codeGenerator of allCodeGenerators) {
    for (const genConfig of config.GetPluginViews(codeGenerator)) {
      barrier.Await((async () => {
        const scopeCodeModel = await RunPlugin(genConfig, "modeler", scopeComposedSwaggerTransformed);
        const scopeCodeModelCommonmark = await RunPlugin(genConfig, "commonmarker", scopeCodeModel);
        const scopeCodeModelTransformed = await RunPlugin(genConfig, "transform", scopeCodeModelCommonmark);

        await EmitArtifacts(genConfig, "code-model-v1", _ => ResolveUri(genConfig.OutputFolderUri, "code-model.yaml"), new LazyPromise(async () => scopeCodeModelTransformed), false);

        const inputScope = new QuickScope([
          await scopeComposedSwaggerTransformed.ReadStrict((await scopeComposedSwaggerTransformed.Enum())[0]),
          await scopeCodeModelTransformed.ReadStrict((await scopeCodeModelTransformed.Enum())[0])
        ]);
        let generatedFileScope = await RunPlugin(genConfig, codeGenerator, inputScope);

        // C# simplifier
        if (codeGenerator === "csharp") {
          generatedFileScope = await RunPlugin(genConfig, "csharp-simplifier", generatedFileScope);
        }

        // generatedFileScope = await RunPlugin(genConfig, "transform", generatedFileScope);
        await EmitArtifacts(genConfig, `source-file-${codeGenerator}`, key => ResolveUri(genConfig.OutputFolderUri, decodeURIComponent(key.split("/output/")[1])), new LazyPromise(async () => generatedFileScope), false);
      })());
    }
  }

  await barrier.Wait();
}
