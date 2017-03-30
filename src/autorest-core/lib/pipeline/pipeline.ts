/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ProcessCodeModel } from './commonmark-documentation';
import { IdentitySourceMapping } from '../source-map/merging';
import { OutstandingTaskAwaiter } from "../outstanding-task-awaiter";
import { BlameTree } from '../source-map/blaming';
import { Artifact } from '../artifact';
import { Supressor } from './supression';
import { IEvent } from '../events';
import { Channel, Message, SourceLocation, Range } from '../message';
import { MultiPromiseUtility, MultiPromise } from "../multi-promise";
import { GetFilename, ResolveUri } from '../ref/uri';
import { ConfigurationView } from '../configuration';
import {
  DataHandleRead,
  DataStore,
  DataStoreViewReadonly,
  KnownScopes
} from '../data-store/data-store';
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { From } from "../ref/linq";
import { IFileSystem } from "../file-system";
import { TryDecodeEnhancedPositionFromName } from "../source-map/source-map";

export type DataPromise = MultiPromise<DataHandleRead>;

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const cancellationToken = config.CancellationToken;

  const outstandingTaskAwaiter = new OutstandingTaskAwaiter();
  outstandingTaskAwaiter.Enter();

  // artifact emitter
  const emitArtifact: (artifactType: string, uri: string, handle: DataHandleRead) => Promise<void> = async (artifactType, uri, handle) => {
    if (From(config.OutputArtifact).Contains(artifactType)) {
      config.GeneratedFile.Dispatch({ uri: uri, content: await handle.ReadData() });
    }
    if (From(config.OutputArtifact).Contains(artifactType + ".map")) {
      config.GeneratedFile.Dispatch({ uri: uri + ".map", content: JSON.stringify(await (await handle.ReadMetadata()).inputSourceMap, null, 2) });
    }
  };

  // load Swaggers
  let inputs = From(config.InputFileUris).ToArray();
  if (inputs.length === 0) {
    throw new Error("No input files provided.");
  }

  config.Debug.Dispatch({ Text: `Starting Pipeline - Loading literate swaggers ${inputs}` });

  const swaggers = await LoadLiterateSwaggers(
    config,
    config.DataStore.CreateScope(KnownScopes.Input).AsFileScopeReadThroughFileSystem(fileSystem),
    inputs, config.DataStore.CreateScope("loader"));
  // const rawSwaggers = await Promise.all(swaggers.map(async x => { return <Artifact>{ uri: x.key, content: await x.ReadData() }; }));

  config.Debug.Dispatch({ Text: `Done loading Literate Swaggers` });

  // compose Swaggers
  const swagger = config.__specials.infoSectionOverride || swaggers.length !== 1
    ? await ComposeSwaggers(config.__specials.infoSectionOverride || {}, swaggers, config.DataStore.CreateScope("compose"), true)
    : swaggers[0];
  const rawSwagger = await swagger.ReadObject<any>();

  config.Debug.Dispatch({ Text: `Done Composing Swaggers.` });

  // emit resolved swagger
  {
    const relPath =
      config.__specials.outputFile ||
      (config.__specials.namespace ? config.__specials.namespace + ".json" : GetFilename([...config.InputFileUris][0]));
    config.Debug.Dispatch({ Text: `relPath: ${relPath}` });
    const outputFileUri = ResolveUri(config.OutputFolderUri, relPath);
    const hw = await config.DataStore.Write("normalized-swagger.json");
    const h = await hw.WriteData(JSON.stringify(rawSwagger, null, 2), IdentitySourceMapping(swagger.key, await swagger.ReadYamlAst()), [swagger]);
    await emitArtifact("swagger-document", outputFileUri, h);
  }
  config.Debug.Dispatch({ Text: `Done Emitting composed documents.` });

  const azureValidator = config.AzureArm && !config.DisableValidation;

  const allCodeGenerators = ["csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema"];
  const usedCodeGenerators = allCodeGenerators.filter(cg => config.PluginSection(cg) !== undefined);

  config.Debug.Dispatch({ Text: `Just before autorest.dll realm.` });
  //
  // AutoRest.dll realm
  //
  if (azureValidator || usedCodeGenerators.length > 0) {
    const autoRestDotNetPlugin = AutoRestDotNetPlugin.Get();
    const supressor = new Supressor(config);

    // setup message pipeline (source map resolution, filter, forward)
    const processMessage = async (sink: IEvent<ConfigurationView, Message>, m: Message) => {
      outstandingTaskAwaiter.Enter();
      config.Debug.Dispatch({ Text: `Incoming validation message (${m.Text}) - starting processing` });

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
          sink.Dispatch(mx);
        }
      } catch (e) {
        console.error(e);
      }

      config.Debug.Dispatch({ Text: `Incoming validation message (${m.Text}) - finished processing` });
      outstandingTaskAwaiter.Exit();
    };

    const messageSink = (m: Message) => {
      switch (m.Channel) {
        case Channel.Debug: processMessage(config.Debug, m); break;
        case Channel.Error: processMessage(config.Error, m); break;
        case Channel.Fatal: processMessage(config.Fatal, m); break;
        case Channel.Information: processMessage(config.Information, m); break;
        case Channel.Verbose: processMessage(config.Verbose, m); break;
        case Channel.Warning: processMessage(config.Warning, m); break;
      }
    };



    // code generators
    if (usedCodeGenerators.length > 0) {
      // modeler
      const codeModel = await autoRestDotNetPlugin.Model(swagger, config.DataStore.CreateScope("model"),
        {
          namespace: config.__specials.namespace || ""
        },
        messageSink);

      // GFMer
      const codeModelGFM = await ProcessCodeModel(codeModel, config.DataStore.CreateScope("modelgfm"));

      for (const usedCodeGenerator of usedCodeGenerators) {
        // get internal name
        const languages = [
          "CSharp",
          "Ruby",
          "NodeJS",
          "Python",
          "Go",
          "Java",
          "AzureResourceSchema"].filter(x => x.toLowerCase() === usedCodeGenerator.toLowerCase())[0];
        const codeGenerator = (config.AzureArm ? "Azure." : "") + languages + (config.Fluent ? ".Fluent" : "");

        const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
        let generatedFileScope = await autoRestDotNetPlugin.GenerateCode(codeModelGFM, config.DataStore.CreateScope("generate"),
          {
            namespace: config.__specials.namespace || "",
            codeGenerator: codeGenerator,
            clientNameOverride: getXmsCodeGenSetting("name"),
            internalConstructors: getXmsCodeGenSetting("internalConstructors") || false,
            useDateTimeOffset: getXmsCodeGenSetting("useDateTimeOffset") || false,
            header: config.__specials.header || null,
            payloadFlatteningThreshold: config.__specials.payloadFlatteningThreshold || getXmsCodeGenSetting("ft") || 0,
            syncMethods: config.__specials.syncMethods || getXmsCodeGenSetting("syncMethods") || "essential",
            addCredentials: config.__specials.addCredentials || false,
            rubyPackageName: config.__specials.rubyPackageName || "client"
          },
          messageSink);

        // C# simplifier
        if (codeGenerator.toLowerCase().indexOf("csharp") !== -1) {
          generatedFileScope = await autoRestDotNetPlugin.SimplifyCSharpCode(generatedFileScope, config.DataStore.CreateScope("simplify"), messageSink);
        }

        for (const fileName of await generatedFileScope.Enum()) {
          const handle = await generatedFileScope.ReadStrict(fileName);
          const relPath = decodeURIComponent(handle.key.split("/output/")[1]);
          const outputFileUri = ResolveUri(config.OutputFolderUri, relPath);
          await emitArtifact(`source-files-${usedCodeGenerator}`,
            outputFileUri, handle);
        }
      }
    }

    // validator
    if (azureValidator) {
      await autoRestDotNetPlugin.Validate(swagger, config.DataStore.CreateScope("validate"), messageSink);
    }
  }

  outstandingTaskAwaiter.Exit();
  await outstandingTaskAwaiter.Wait();
}
