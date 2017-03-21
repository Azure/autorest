/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { MultiPromiseUtility, MultiPromise } from "../multi-promise";
import { ResolveUri } from "../ref/uri";
import { WriteString } from "../ref/writefs";
import { AutoRestConfigurationImpl, Configuration, ConfigurationView } from '../configuration';
import {
  DataHandleRead,
  DataStore,
  DataStoreView,
  DataStoreViewReadonly,
  KnownScopes
} from '../data-store/data-store';
import { Parse as ParseLiterateYaml } from "../parsing/literate-yaml";
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";
import { RealFileSystem } from "../file-system"
import { From } from "../ref/linq"

export type DataPromise = MultiPromise<DataHandleRead>;

export async function RunPipeline(config: ConfigurationView): Promise<{ [name: string]: DataPromise }> {
  // load Swaggers
  let inputs = From(config.inputFileUris).ToArray();

  const uriScope = (uri: string) => inputs.indexOf(uri) !== -1 || /^http/.test(uri) || true; // TODO: unlock further URIs here
  const swaggers = await LoadLiterateSwaggers(
    config.workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uriScope),
    inputs, config.workingScope.CreateScope("loader"));

  // compose Swaggers (may happen in LoadLiterateSwaggers, BUT then we can't call other people (e.g. Amar's tools) with the component swaggers... hmmm...)
  const swagger = config.__specials.infoSectionOverride || swaggers.length !== 1
    ? await ComposeSwaggers(config.__specials.infoSectionOverride || {}, swaggers, config.workingScope.CreateScope("compose"), true)
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

    // modeler
    const codeModel = await autoRestDotNetPlugin.Model(swagger, config.workingScope.CreateScope("model"),
      {
        namespace: config.__specials.namespace || ""
      });

    // code generator
    result["generatedFiles"] = MultiPromiseUtility.fromCallbacks(async callback => {
      const codeGenerator = config.__specials.codeGenerator;
      if (codeGenerator) {
        const getXmsCodeGenSetting = (name: string) => (() => { try { return rawSwagger.info["x-ms-code-generation-settings"][name]; } catch (e) { return null; } })();
        let generatedFileScope = await autoRestDotNetPlugin.GenerateCode(codeModel, config.workingScope.CreateScope("generate"),
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
          generatedFileScope = await autoRestDotNetPlugin.SimplifyCSharpCode(generatedFileScope, config.workingScope.CreateScope("simplify"));
        }

        for (const fileName of await generatedFileScope.Enum()) {
          callback(await generatedFileScope.ReadStrict(fileName));
        }
      }
    });

    // validator
    result["azureValidationMessages"] = MultiPromiseUtility.fromCallbacks(async callback => {
      if (config.__specials.azureValidator) {
        // TODO: streamify
        const messages = await autoRestDotNetPlugin.Validate(swagger, config.workingScope.CreateScope("validate"));
        for (const fileName of await messages.Enum()) {
          callback(await messages.ReadStrict(fileName));
        }
      }
    });
  }

  // sinks (TODO: parallelize, streamify)

  if (result["generatedFiles"]) {
    await MultiPromiseUtility.toAsyncCallbacks(result["generatedFiles"], async fileHandle => {
      // commit to disk (TODO: extract output path more elegantly)
      const relPath = decodeURIComponent(fileHandle.key.split("/output/")[1]);
      const outputFileUri = ResolveUri(config.outputFolderUri, relPath);
      await WriteString(outputFileUri, await fileHandle.ReadData());
    });
  }

  if (result["azureValidationMessages"]) {
    await MultiPromiseUtility.toAsyncCallbacks(result["azureValidationMessages"], async fileHandle => {
      // print
      console.log(await fileHandle.ReadData());
    });
  }

  return result;
}