/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Channel } from '../message';
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

export type DataPromise = MultiPromise<DataHandleRead>;

export async function RunPipeline(config: ConfigurationView): Promise<void> {
  // load Swaggers
  let inputs = From(config.inputFileUris).ToArray();

  const uriScope = (uri: string) => inputs.indexOf(uri) !== -1 || /^http/.test(uri) || true; // TODO: unlock further URIs here
  const swaggers = await LoadLiterateSwaggers(
    config.DataStore.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uriScope),
    inputs, config.DataStore.CreateScope("loader"));

  // compose Swaggers
  const swagger = config.__specials.infoSectionOverride || swaggers.length !== 1
    ? await ComposeSwaggers(config.__specials.infoSectionOverride || {}, swaggers, config.DataStore.CreateScope("compose"), true)
    : swaggers[0];
  const rawSwagger = await swagger.ReadObject<any>();

  const result: { [name: string]: DataPromise } = {
    componentSwaggers: MultiPromiseUtility.list(swaggers),
    swagger: MultiPromiseUtility.single(swagger)
  };

  //
  // AutoRest.dll realm
  //
  if (config.__specials.azureValidator || config.__specials.codeGenerator) {
    const autoRestDotNetPlugin = new AutoRestDotNetPlugin();
    autoRestDotNetPlugin.Message.Subscribe((_, m) => {
      switch (m.Channel) {
        case Channel.Debug: config.Debug.Dispatch(m); break;
        case Channel.Error: config.Error.Dispatch(m); break;
        case Channel.Fatal: config.Fatal.Dispatch(m); break;
        case Channel.Information: config.Information.Dispatch(m); break;
        case Channel.Verbose: config.Verbose.Dispatch(m); break;
        case Channel.Warning: config.Warning.Dispatch(m); break;
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
    if (config.__specials.azureValidator) {
      await autoRestDotNetPlugin.Validate(swagger, config.DataStore.CreateScope("validate"));
    }
  }
}