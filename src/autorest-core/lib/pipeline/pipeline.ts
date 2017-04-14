import { AutoRestPlugin } from './plugin-endpoint';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { stringify } from '../ref/jsonpath';
import { Manipulator } from "./manipulation";
import { ProcessCodeModel } from "./commonmark-documentation";
import { IdentitySourceMapping } from "../source-map/merging";
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { Supressor } from "./supression";
import { IEvent } from "../events";
import { Channel, Message, SourceLocation, Range } from "../message";
import { MultiPromiseUtility, MultiPromise } from "../multi-promise";
import { GetFilename, ResolveUri } from "../ref/uri";
import { ConfigurationView, MessageEmitter } from "../configuration";
import { DataHandleRead, QuickScope } from '../data-store/data-store';
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { From } from "../ref/linq";
import { IFileSystem } from "../file-system";
import { TryDecodeEnhancedPositionFromName } from "../source-map/source-map";
import { Exception } from '../exception';

export type DataPromise = MultiPromise<DataHandleRead>;

function CreateMessageProcessor(config: ConfigurationView, outstandingTaskAwaiter: OutstandingTaskAwaiter): (m: Message) => Promise<void> {
  const supressor = new Supressor(config);

  // setup message pipeline (source map resolution, filter, forward)
  return async (m: Message) => {

    config.Message.Dispatch({ Channel: Channel.Debug, Text: `Incoming validation message (${m.Text}) - starting processing` });

    try {
      // update source locations to point to loaded Swagger
      if (m.Source) {
        const blameSources = await Promise.all(m.Source.map(async s => {
          try {
            const blameTree = await config.DataStore.Blame(s.document, s.Position);
            const result = [...blameTree.BlameInputs()];
            if (result.length > 0) {
              return result.map(r => <SourceLocation>{ document: r.source, Position: Object.assign(TryDecodeEnhancedPositionFromName(r.name) || {}, { line: r.line, column: r.column }) });
            }
          } catch (e) {
            // TODO: activate as soon as .NET swagger loader stuff (inline responses, inline path level parameters, ...)
            //console.log(`Failed blaming '${JSON.stringify(s.Position)}' in '${s.document}'`);
            //console.log(e);
          }
          return [s];
        }));

        //console.log("---");
        //console.log(JSON.stringify(m.Source, null, 2));
        m.Source = From(blameSources).SelectMany(x => x).ToArray();
        //console.log(JSON.stringify(m.Source, null, 2));
        //console.log("---");
      }

      // set range (dummy)
      if (m.Source) {
        m.Range = m.Source.map(s => {
          let positionStart = s.Position;
          let positionEnd = <sourceMap.Position>{ line: s.Position.line, column: s.Position.column + (s.Position.length || 3) };

          return <Range>{
            document: s.document,
            start: positionStart,
            end: positionEnd
          };
        });
      }

      // filter
      const mx = supressor.Filter(m);

      // forward
      if (mx !== null) {
        // format message
        switch (config.GetEntry("message-format")) {
          case "json":
            mx.Text = JSON.stringify(mx.Details, null, 2);
            break;
          default:
            let text = `${(mx.Channel || Channel.Information).toString().toUpperCase()}${mx.Key ? ` (${[...mx.Key].join('/')})` : ""}: ${mx.Text}`;
            for (const source of mx.Source || []) {
              if (source.Position && source.Position.path) {
                text += `\n        Path: ${source.document}#${stringify(source.Position.path)}`;
              }
            }
            mx.Text = text;
            break;
        }

        config.Message.Dispatch(mx);
      }
    } catch (e) {
      console.error(e);
    }

    config.Message.Dispatch({ Channel: Channel.Debug, Text: `Incoming validation message (${m.Text}) - finished processing` });
  };
}

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const cancellationToken = config.CancellationToken;

  const outstandingTaskAwaiter = new OutstandingTaskAwaiter();
  const processMessage = CreateMessageProcessor(config, outstandingTaskAwaiter);


  // artifact emitter
  const emitArtifact: (artifactType: string, uri: string, handle: DataHandleRead) => Promise<void> = async (artifactType, uri, handle) => {
    if (From(config.OutputArtifact).Contains(artifactType)) {
      config.GeneratedFile.Dispatch({ type: artifactType, uri: uri, content: handle.ReadData() });
    }
    if (From(config.OutputArtifact).Contains(artifactType + ".map")) {
      config.GeneratedFile.Dispatch({ type: artifactType + ".map", uri: uri + ".map", content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2) });
    }
  };

  const manipulator = new Manipulator(config);

  // load Swaggers
  let inputs = From(config.InputFileUris).ToArray();
  if (inputs.length === 0) {
    throw new Exception("No input files provided.\n\nUse --help to get help information.", 0)
  }

  config.Message.Dispatch({ Channel: Channel.Debug, Text: `Starting Pipeline - Loading literate swaggers ${inputs}` });

  const swaggers = await LoadLiterateSwaggers(
    config,
    config.DataStore.GetReadThroughScopeFileSystem(fileSystem),
    inputs, config.DataStore.CreateScope("loader"));
  // const rawSwaggers = await Promise.all(swaggers.map(async x => { return <Artifact>{ uri: x.key, content: await x.ReadData() }; }));

  config.Message.Dispatch({ Channel: Channel.Debug, Text: `Done loading Literate Swaggers` });

  // TRANSFORM
  for (let i = 0; i < swaggers.length; ++i) {
    swaggers[i] = await manipulator.Process(swaggers[i], config.DataStore.CreateScope("loaded-transform"), inputs[i]);
  }

  // compose Swaggers
  let swagger = config.GetEntry("override-info") || swaggers.length !== 1
    ? await ComposeSwaggers(config, config.GetEntry("override-info") || {}, swaggers, config.DataStore.CreateScope("compose"), true)
    : swaggers[0];
  const rawSwagger = swagger.ReadObject<any>();

  config.Message.Dispatch({ Channel: Channel.Debug, Text: `Done Composing Swaggers.` });

  // TRANSFORM
  swagger = await manipulator.Process(swagger, config.DataStore.CreateScope("composite-transform"), "/composite.yaml");

  // emit resolved swagger
  {
    const relPath =
      config.GetEntry("output-file") ||
      (config.GetEntry("namespace") ? config.GetEntry("namespace") + ".json" : GetFilename([...config.InputFileUris][0]));
    config.Message.Dispatch({ Channel: Channel.Debug, Text: `relPath: ${relPath}` });
    const outputFileUri = ResolveUri(config.OutputFolderUri, relPath);
    const hw = await config.DataStore.Write("normalized-swagger.json");
    const h = await hw.WriteData(JSON.stringify(rawSwagger, null, 2), IdentitySourceMapping(swagger.key, swagger.ReadYamlAst()), [swagger]);
    await emitArtifact("swagger-document", outputFileUri, h);
  }
  config.Message.Dispatch({ Channel: Channel.Debug, Text: `Done Emitting composed documents.` });

  // AMAR WORLD
  if (!config.DisableValidation && config.GetEntry("amar" as any)) {
    const validationPlugin = await AutoRestPlugin.FromModule(`${__dirname}/plugins/openapi-validation-tools`);
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);
    if (pluginNames.length != 2) {
      throw new Error("Amar's plugin betrayed us!");
    }

    for (let pluginIndex = 0; pluginIndex < pluginNames.length; ++pluginIndex) {
      const scopeWork = config.DataStore.CreateScope(`amar_${pluginIndex}`);
      const result = await validationPlugin.Process(
        pluginNames[pluginIndex], _ => null,
        new QuickScope([swagger]),
        scopeWork.CreateScope("output"),
        processMessage,
        cancellationToken);
      if (!result) {
        throw new Error("Amar's plugin failed us!");
      }
    }
  }

  const azureValidator = config.AzureArm && !config.DisableValidation;

  const allCodeGenerators = ["csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema"];
  const usedCodeGenerators = allCodeGenerators.filter(cg => config.GetEntry(cg as any) !== undefined);

  config.Message.Dispatch({ Channel: Channel.Debug, Text: `Just before autorest.dll realm.` });
  //
  // AutoRest.dll realm
  //
  if (azureValidator || usedCodeGenerators.length > 0) {
    const autoRestDotNetPlugin = AutoRestDotNetPlugin.Get();

    // code generators
    if (usedCodeGenerators.length > 0) {
      // modeler
      let codeModel = await autoRestDotNetPlugin.Model(swagger, config.DataStore.CreateScope("model"),
        {
          namespace: config.GetEntry("namespace") || ""
        },
        processMessage);

      // GFMer
      const codeModelGFM = await ProcessCodeModel(codeModel, config.DataStore.CreateScope("modelgfm"));

      for (const usedCodeGenerator of usedCodeGenerators) {
        for (const genConfig of config.GetPluginViews(usedCodeGenerator)) {
          const scope = genConfig.DataStore.CreateScope("plugin_" + (await genConfig.DataStore.Enum()).length);

          // TRANSFORM
          const codeModelTransformed = await manipulator.Process(codeModelGFM, scope.CreateScope("transform"), "/model.yaml");

          await emitArtifact("code-model-v1", "mem://code-model.yaml", codeModelTransformed);

          const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
          let generatedFileScope = await autoRestDotNetPlugin.GenerateCode(usedCodeGenerator, codeModelTransformed, scope.CreateScope("generate"),
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
            generatedFileScope = await autoRestDotNetPlugin.SimplifyCSharpCode(generatedFileScope, scope.CreateScope("simplify"), processMessage);
          }

          for (const fileName of await generatedFileScope.Enum()) {
            const handle = await generatedFileScope.ReadStrict(fileName);
            const relPath = decodeURIComponent(handle.key.split("/output/")[1]);
            const outputFileUri = ResolveUri(genConfig.OutputFolderUri, relPath);
            await emitArtifact(`source-files-${usedCodeGenerator}`,
              outputFileUri, handle);
          }
        }
      }
    }

    // validator
    if (azureValidator) {
      await autoRestDotNetPlugin.Validate(swagger, config.DataStore.CreateScope("validate"), processMessage);
    }
  }

  outstandingTaskAwaiter.Exit();
  await outstandingTaskAwaiter.Wait();
}
