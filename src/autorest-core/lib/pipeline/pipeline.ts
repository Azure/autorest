/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { BlameTree } from '../source-map/blaming';
import { Artifact } from '../artifact';
import { Supressor } from './supression';
import { IEvent } from '../events';
import { Channel, Message, SourceLocation, Range } from '../message';
import { MultiPromiseUtility, MultiPromise } from "../multi-promise";
import { ResolveUri } from "../ref/uri";
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
import { TryDecodePathFromName } from "../source-map/source-map";

export type DataPromise = MultiPromise<DataHandleRead>;

class OutstandingTaskAwaiter {
  private outstandingTaskCount: number = 0;
  private awaiter: Promise<void>;
  private resolve: () => void;

  public constructor() {
    this.awaiter = new Promise<void>(res => this.resolve = res);
  }

  public async Wait(): Promise<void> {
    return this.awaiter;
  }

  public Enter(): void { this.outstandingTaskCount++; }
  public Exit(): void { this.outstandingTaskCount--; this.Signal(); }

  private Signal(): void {
    if (this.outstandingTaskCount === 0) {
      this.resolve();
    }
  }
}

export async function RunPipeline(config: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  const outstandingTaskAwaiter = new OutstandingTaskAwaiter();
  outstandingTaskAwaiter.Enter();

  // load Swaggers
  let inputs = From(config.inputFileUris).ToArray();

  config.Debug.Dispatch({ Text: `Starting Pipeline - Inputs are ${inputs}` });

  const swaggers = await LoadLiterateSwaggers(
    config.DataStore.CreateScope(KnownScopes.Input).AsFileScopeReadThroughFileSystem(fileSystem),
    inputs, config.DataStore.CreateScope("loader"));
  // const rawSwaggers = await Promise.all(swaggers.map(async x => { return <Artifact>{ uri: x.key, content: await x.ReadData() }; }));

  config.Debug.Dispatch({ Text: `Loading Literate Swaggers` });

  // compose Swaggers
  const swagger = config.__specials.infoSectionOverride || swaggers.length !== 1
    ? await ComposeSwaggers(config.__specials.infoSectionOverride || {}, swaggers, config.DataStore.CreateScope("compose"), true)
    : swaggers[0];
  const rawSwagger = await swagger.ReadObject<any>();

  config.Debug.Dispatch({ Text: `Composing Swaggers. ` });
  const result: { [name: string]: DataPromise } = {
    componentSwaggers: MultiPromiseUtility.list(swaggers),
    swagger: MultiPromiseUtility.single(swagger)
  };

  const azureValidator = config.__specials.azureValidator || (config.azureArm && !config.disableValidation);

  //
  // AutoRest.dll realm
  //
  if (azureValidator || config.__specials.codeGenerator) {
    const autoRestDotNetPlugin = new AutoRestDotNetPlugin();
    const supressor = new Supressor(config);

    // setup message pipeline (source map resolution, filter, forward)
    const processMessage = async (sink: IEvent<ConfigurationView, Message>, m: Message) => {
      outstandingTaskAwaiter.Enter();

      try {
        // update source locations to point to loaded Swagger
        if (m.Source) {
          const blameSources = await Promise.all(m.Source.map(async s => {
            try {
              const blameTree = await config.DataStore.Blame(s.document, s.Position);
              const result = [...blameTree.BlameInputs()];
              if (result.length > 0) {
                return result.map(r => <SourceLocation>{ document: r.source, Position: { line: r.line, column: r.column, path: TryDecodePathFromName(r.name) } });
              }
            } catch (e) {
              // TODO: activate as soon as .NET swagger loader stuff (inline responses, inline path level parameters, ...)
              //console.log(`Failed blaming '${JSON.stringify(s.Position)}' in '${s.document}'`);
              //console.log(e);
            }
            return [s];
          }));
          m.Source = blameSources.map(x => x[0]); // just take the first source of every issue (or take all of them? has impact on both supression and highlighting!)
        }

        // set range (dummy)
        m.Range = m.Source === undefined ? undefined : m.Source.map(s =>
          <Range>{
            document: s.document,
            start: s.Position,
            end: { column: (s.Position as any).column + 3, line: (s.Position as any).line }
          });

        // filter
        const mx = supressor.Filter(m);

        // forward
        if (mx !== null) {
          sink.Dispatch(mx);
        }
      } catch (e) {
        console.error(e);
      }

      outstandingTaskAwaiter.Exit();
    };

    autoRestDotNetPlugin.Message.Subscribe((_, m) => {
      switch (m.Channel) {
        case Channel.Debug: processMessage(config.Debug, m); break;
        case Channel.Error: processMessage(config.Error, m); break;
        case Channel.Fatal: processMessage(config.Fatal, m); break;
        case Channel.Information: processMessage(config.Information, m); break;
        case Channel.Verbose: processMessage(config.Verbose, m); break;
        case Channel.Warning: processMessage(config.Warning, m); break;
      }
    });

    // modeler
    const codeModel = await autoRestDotNetPlugin.Model(swagger, config.DataStore.CreateScope("model"),
      {
        namespace: config.__specials.namespace || ""
      });

    // code generator
    const codeGenerator = config.__specials.codeGenerator;
    if (codeGenerator) {
      const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
      let generatedFileScope = await autoRestDotNetPlugin.GenerateCode(codeModel, config.DataStore.CreateScope("generate"),
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
        });

      // C# simplifier
      if (codeGenerator.toLowerCase().indexOf("csharp") !== -1) {
        generatedFileScope = await autoRestDotNetPlugin.SimplifyCSharpCode(generatedFileScope, config.DataStore.CreateScope("simplify"));
      }

      for (const fileName of await generatedFileScope.Enum()) {
        const handle = await generatedFileScope.ReadStrict(fileName);
        const relPath = decodeURIComponent(handle.key.split("/output/")[1]);
        const outputFileUri = ResolveUri(config.outputFolderUri, relPath);
        config.GeneratedFile.Dispatch({
          uri: outputFileUri,
          content: await handle.ReadData()
        });
      }
    }

    // validator
    if (azureValidator) {
      await autoRestDotNetPlugin.Validate(swagger, config.DataStore.CreateScope("validate"));
    }
  }


  outstandingTaskAwaiter.Exit();
  await outstandingTaskAwaiter.Wait();
}