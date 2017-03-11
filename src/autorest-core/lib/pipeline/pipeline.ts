/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { MultiPromiseUtility, MultiPromise } from "../approved-imports/multi-promise";
import { ResolveUri } from "../approved-imports/uri";
import { WriteString } from "../approved-imports/writefs";
import { AutoRestConfigurationManager, AutoRestConfiguration } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/data-store";
import { Parse as ParseLiterateYaml } from "../parsing/literate-yaml";
import { AutoRestDotNetPlugin } from "./plugins/autorest-dotnet";
import { ComposeSwaggers, LoadLiterateSwaggers } from "./swagger-loader";

export type DataPromise = MultiPromise<DataHandleRead>;

export async function RunPipeline(configurationUri: string, workingScope: DataStoreView): Promise<{ [name: string]: DataPromise }> {
  // load config
  const hConfig = await ParseLiterateYaml(
    await workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => uri === configurationUri).ReadStrict(configurationUri),
    workingScope.CreateScope("config"));
  const config = new AutoRestConfigurationManager(await hConfig.ReadObject<AutoRestConfiguration>(), configurationUri);

  // load Swaggers
  const swaggers = await LoadLiterateSwaggers(
    // TODO: unlock further URIs here
    workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => config.inputFileUris.indexOf(uri) !== -1),
    config.inputFileUris, workingScope.CreateScope("loader"));

  // compose Swaggers (may happen in LoadLiterateSwaggers, BUT then we can't call other people (e.g. Amar's tools) with the component swaggers... hmmm...)
  const swagger = await ComposeSwaggers(config.__specials.infoSectionOverride || {}, swaggers, workingScope.CreateScope("compose"), true);

  //
  // AutoRest.dll realm
  //
  if (config.__specials.azureValidator || config.__specials.codeGenerator) {
    const autoRestDotNetPlugin = new AutoRestDotNetPlugin();

    // modeler
    const codeModel = await autoRestDotNetPlugin.Model(swagger, workingScope.CreateScope("model"));

    // code generator
    if (config.__specials.codeGenerator) {
      const generatedFileScope = await autoRestDotNetPlugin.GenerateCode(config.__specials.codeGenerator, codeModel, workingScope.CreateScope("generate"));
      // commit to disk
      for (const fileName of await generatedFileScope.Enum()) {
        const outputFileUri = ResolveUri(config.outputFolderUri, fileName);
        const fileHandle = await generatedFileScope.ReadStrict(fileName);
        await WriteString(outputFileUri, await fileHandle.ReadData());
      }
    }

    // validator
    if (config.__specials.azureValidator) {
      const messages = await autoRestDotNetPlugin.Validate(swagger, workingScope.CreateScope("validate"));
    }
  }

  return {
    componentSwaggers: MultiPromiseUtility.list(swaggers),
    swagger: MultiPromiseUtility.single(swagger)
  };
}