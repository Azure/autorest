import { OutstandingTaskAwaiter } from '../outstanding-task-awaiter';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestPlugin } from "./plugin-endpoint";
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { IdentitySourceMapping } from "../source-map/merging";
import { Channel, Message, SourceLocation, Range } from "../message";
import { MultiPromise } from "../multi-promise";
import { GetFilename, ResolveUri } from "../ref/uri";
import { ConfigurationView } from "../configuration";
import { DataHandleRead, DataStoreView, DataStoreViewReadonly, QuickScope } from '../data-store/data-store';
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { From } from "../ref/linq";
import { IFileSystem } from "../file-system";
import { Exception } from "../exception";

export type DataPromise = MultiPromise<DataHandleRead>;

function emitArtifact(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandleRead): void {
  if (From(config.OutputArtifact).Contains(artifactType)) {
    config.GeneratedFile.Dispatch({ type: artifactType, uri: uri, content: handle.ReadData() });
  }
  if (From(config.OutputArtifact).Contains(artifactType + ".map")) {
    config.GeneratedFile.Dispatch({ type: artifactType + ".map", uri: uri + ".map", content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2) });
  }
}

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const cancellationToken = config.CancellationToken;
  const processMessage = config.Message.bind(config);
  const barrier = new OutstandingTaskAwaiter();

  type PipelinePlugin = (input: DataStoreViewReadonly, output: DataStoreView) => Promise<void>;
  type PipelineNode = { outputArtifact: string, plugin: PipelinePlugin, inputs: PipelineNode[] };
  // type PipelineSchedule = 
  // const plugins

  const manipulator = new Manipulator(config);

  // load Swaggers
  let inputs = From(config.InputFileUris).ToArray();
  if (inputs.length === 0) {
    throw new Exception("No input files provided.\n\nUse --help to get help information.", 0);
  }

  config.Message({ Channel: Channel.Debug, Text: `Starting Pipeline - Loading literate swaggers ${inputs}` });

  const swaggers = await LoadLiterateSwaggers(
    config,
    config.DataStore.GetReadThroughScopeFileSystem(fileSystem),
    inputs, config.DataStore.CreateScope("loader"));
  // const rawSwaggers = await Promise.all(swaggers.map(async x => { return <Artifact>{ uri: x.key, content: await x.ReadData() }; }));

  config.Message({ Channel: Channel.Debug, Text: `Done loading Literate Swaggers` });

  // TRANSFORM
  for (let i = 0; i < swaggers.length; ++i) {
    swaggers[i] = await manipulator.Process(swaggers[i], config.DataStore.CreateScope("loaded-transform"), inputs[i]);
  }

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
    emitArtifact(config, "swagger-document", outputFileUri, h);
    emitArtifact(config, "swagger-document.yaml", outputFileUri.replace(".json", ".yaml"), swagger);
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

          emitArtifact(genConfig, "code-model-v1", ResolveUri(config.OutputFolderUri, "code-model.yaml"), codeModelTransformed);

          const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
          let generatedFileScope = await AutoRestDotNetPlugin.Get().GenerateCode(usedCodeGenerator, codeModelTransformed, scope.CreateScope("generate"),
            Object.assign(
              { // stuff that comes in via `x-ms-code-generation-settings`
                "override-client-name": getXmsCodeGenSetting("name"),
                "use-internal-constructors": getXmsCodeGenSetting("internalConstructors"),
                "use-datetimeoffset": getXmsCodeGenSetting("useDateTimeOffset"),
                "payload-flattening-threshold": getXmsCodeGenSetting("ft"),
                "sync-methods": getXmsCodeGenSetting("syncMethods")
              },
              genConfig.Raw),
            processMessage);

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
