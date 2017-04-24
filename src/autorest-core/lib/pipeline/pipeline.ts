/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy } from "../lazy";
import { Stringify, YAMLNode } from '../ref/yaml';
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { AutoRestPlugin } from "./plugin-endpoint";
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { IdentitySourceMapping } from "../source-map/merging";
import { Channel, Message, SourceLocation, Range } from "../message";
import { MultiPromise } from "../multi-promise";
import { GetFilename, ResolveUri } from "../ref/uri";
import { ConfigurationView } from "../configuration";
import { DataHandleRead, DataStoreView, DataStoreViewReadonly, QuickScope } from "../data-store/data-store";
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { From } from "../ref/linq";
import { IFileSystem } from "../file-system";
import { Exception } from "../exception";

export type DataPromise = MultiPromise<DataHandleRead>;

async function emitArtifact(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandleRead): Promise<void> {
  if (config.IsOutputArtifactRequested(artifactType)) {
    config.GeneratedFile.Dispatch({ type: artifactType, uri: uri, content: handle.ReadData() });
  }
  if (config.IsOutputArtifactRequested(artifactType + ".map")) {
    config.GeneratedFile.Dispatch({ type: artifactType + ".map", uri: uri + ".map", content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2) });
  }
}
let emitCtr = 0;
async function emitObjectArtifact(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandleRead): Promise<void> {
  await emitArtifact(config, artifactType, uri, handle);

  const scope = config.DataStore.CreateScope("emitObjectArtifact");
  const object = new Lazy<any>(() => handle.ReadObject<any>());
  const ast = new Lazy<YAMLNode>(() => handle.ReadYamlAst());

  if (config.IsOutputArtifactRequested(artifactType + ".yaml")
    || config.IsOutputArtifactRequested(artifactType + ".yaml.map")) {

    const hw = await scope.Write(`${++emitCtr}.yaml`);
    const h = await hw.WriteData(Stringify(object.Value), IdentitySourceMapping(handle.key, ast.Value), [handle]);
    await emitArtifact(config, artifactType + ".yaml", uri + ".yaml", h);
  }
  if (config.IsOutputArtifactRequested(artifactType + ".json")
    || config.IsOutputArtifactRequested(artifactType + ".json.map")) {

    const hw = await scope.Write(`${++emitCtr}.json`);
    const h = await hw.WriteData(JSON.stringify(object.Value, null, 2), IdentitySourceMapping(handle.key, ast.Value), [handle]);
    await emitArtifact(config, artifactType + ".json", uri + ".json", h);
  }
}

type PipelinePlugin = (config: ConfigurationView, input: DataStoreViewReadonly, working: DataStoreView, output: DataStoreView) => Promise<void>;
type PipelineNode = { id: string, outputArtifact: string, plugin: PipelinePlugin, inputs: PipelineNode[] };

function CreatePluginLoader(): PipelinePlugin {
  return async (config, input, working, output) => {
    let inputs = From(config.InputFileUris).ToArray();
    if (inputs.length === 0) {
      throw new Exception("No input files provided.\n\nUse --help to get help information.", 0);
    }
    const swaggers = await LoadLiterateSwaggers(
      config,
      input,
      inputs, working);
    for (let i = 0; i < inputs.length; ++i) {
      await (await output.Write(`./${i}/_` + encodeURIComponent(inputs[i]))).Forward(swaggers[i]);
    }
  };
}
function CreateTransformer(documentIdResolver: (key: string) => string): PipelinePlugin {
  return async (config, input, working, output) => {
    const manipulator = new Manipulator(config);
    const files = await input.Enum();
    for (const file of files) {
      const fileIn = await input.ReadStrict(file);
      const fileOut = await manipulator.Process(fileIn, working, documentIdResolver(file));
      await (await output.Write("./" + file)).Forward(fileOut);
    }
  };
}
function CreateComposer(): PipelinePlugin {
  return async (config, input, working, output) => {

  };
}

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const cancellationToken = config.CancellationToken;
  const processMessage = config.Message.bind(config);
  const barrier = new OutstandingTaskAwaiter();

  const plugins: { [name: string]: PipelinePlugin } = {
    "loader": CreatePluginLoader(),
    "transform1": CreateTransformer(key => decodeURIComponent(key.split("/_").reverse()[0]))
  };

  const manipulator = new Manipulator(config);

  const swaggersScope = config.DataStore.CreateScope("loader");
  const swaggersScopeOutput = swaggersScope.CreateScope("output");
  await plugins["loader"](config,
    config.DataStore.GetReadThroughScopeFileSystem(fileSystem),
    swaggersScope.CreateScope("working"),
    swaggersScopeOutput);

  config.Message({ Channel: Channel.Debug, Text: `Done loading Literate Swaggers` });

  // TRANSFORM
  const transform1Scope = config.DataStore.CreateScope("transform1");
  const transform1ScopeOutput = transform1Scope.CreateScope("output");
  await plugins["transform1"](config,
    swaggersScopeOutput,
    transform1Scope.CreateScope("working"),
    transform1ScopeOutput);

  const swaggers = await Promise.all((await transform1ScopeOutput.Enum()).map(x => transform1ScopeOutput.ReadStrict(x)));

  // compose Swaggers
  let swagger = config.GetEntry("override-info") || swaggers.length !== 1
    ? await ComposeSwaggers(config, config.GetEntry("override-info") || {}, swaggers, config.DataStore.CreateScope("compose"), true)
    : swaggers[0];
  const rawSwagger = swagger.ReadObject<any>();

  config.Message({ Channel: Channel.Debug, Text: `Done Composing Swaggers.` });

  // TRANSFORM
  swagger = await manipulator.Process(swagger, config.DataStore.CreateScope("composite-transform"), "/swagger-document.yaml");

  // emit resolved swagger
  {
    const relPath =
      config.GetEntry("output-file") ||
      (config.GetEntry("namespace") ? config.GetEntry("namespace") + ".json" : GetFilename([...config.InputFileUris][0]));
    config.Message({ Channel: Channel.Debug, Text: `relPath: ${relPath}` });
    const outputFileUri = ResolveUri(config.OutputFolderUri, relPath);
    const hw = await config.DataStore.Write("normalized-swagger.json");
    const h = await hw.WriteData(JSON.stringify(rawSwagger, null, 2), IdentitySourceMapping(swagger.key, swagger.ReadYamlAst()), [swagger]);
    await emitObjectArtifact(config, "swagger-document", outputFileUri, h);
  }
  config.Message({ Channel: Channel.Debug, Text: `Done Emitting composed documents.` });

  // AMAR WORLD
  if (!config.DisableValidation && (config.GetEntry("model-validator") || config.GetEntry("semantic-validator"))) {
    const validationPlugin = await AutoRestPlugin.FromModule(`${__dirname}/plugins/openapi-validation-tools`);
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);
    if (pluginNames.length != 2) {
      throw new Error("Amar's plugin betrayed us!");
    }

    for (let pluginName of pluginNames.filter(name => config.GetEntry(name as any))) {
      barrier.Await((async () => {
        const scopeWork = config.DataStore.CreateScope(`amar_${pluginName}`);
        const result = await validationPlugin.Process(
          pluginName, _ => null,
          new QuickScope([swagger]),
          scopeWork.CreateScope("output"),
          processMessage,
          cancellationToken);
        if (!result) {
          throw new Error("Amar's plugin failed us!");
        }
      })());
    }
  }

  const allCodeGenerators = ["csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema"];
  const usedCodeGenerators = allCodeGenerators.filter(cg => config.GetEntry(cg as any) !== undefined);

  config.Message({ Channel: Channel.Debug, Text: `Just before autorest.dll realm.` });

  // validator
  if (config.GetEntry("azure-validator") && !config.DisableValidation) {
    barrier.Await(AutoRestDotNetPlugin.Get().Validate(swagger, config.DataStore.CreateScope("validate"), processMessage));
  }

  // code generators
  if (usedCodeGenerators.length > 0) {
    // modeler
    let codeModel = await AutoRestDotNetPlugin.Get().Model(swagger, config.DataStore.CreateScope("model"),
      {
        namespace: config.GetEntry("namespace") || ""
      },
      processMessage);

    // GFMer
    const codeModelGFM = await ProcessCodeModel(codeModel, config.DataStore.CreateScope("modelgfm"));

    let pluginCtr = 0;
    for (const usedCodeGenerator of usedCodeGenerators) {
      for (const genConfig of config.GetPluginViews(usedCodeGenerator)) {
        const manipulator = new Manipulator(genConfig);
        const processMessage = genConfig.Message.bind(genConfig);
        const scope = genConfig.DataStore.CreateScope("plugin_" + ++pluginCtr);

        barrier.Await((async () => {
          // TRANSFORM
          const codeModelTransformed = await manipulator.Process(codeModelGFM, scope.CreateScope("transform"), "/code-model-v1.yaml");

          await emitArtifact(genConfig, "code-model-v1", ResolveUri(config.OutputFolderUri, "code-model.yaml"), codeModelTransformed);

          let generatedFileScope = await AutoRestDotNetPlugin.Get().GenerateCode(genConfig, usedCodeGenerator, swagger, codeModelTransformed, scope.CreateScope("generate"), processMessage);

          // C# simplifier
          if (usedCodeGenerator === "csharp") {
            generatedFileScope = await AutoRestDotNetPlugin.Get().SimplifyCSharpCode(generatedFileScope, scope.CreateScope("simplify"), processMessage);
          }

          for (const fileName of await generatedFileScope.Enum()) {
            const handle = await generatedFileScope.ReadStrict(fileName);
            const relPath = decodeURIComponent(handle.key.split("/output/")[1]);
            const outputFileUri = ResolveUri(genConfig.OutputFolderUri, relPath);
            await emitArtifact(genConfig, `source-file-${usedCodeGenerator}`, outputFileUri, handle);
          }
        })());
      }
    }
  }

  await barrier.Wait();
}
