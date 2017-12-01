/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as SchemaValidator from "z-schema";
import { ReadUri, ResolveUri } from '../ref/uri';
import { QuickDataSource } from '../data-store/data-store';
import { Parse } from '../ref/yaml';
import { CreatePerFilePlugin, PipelinePlugin } from "./common";

export async function GetPlugin_SchemaValidator(): Promise<PipelinePlugin> {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  // TODO: local
  const extensionSwaggerSchemaUrl = "https://raw.githubusercontent.com/Azure/autorest/master/schema/swagger-extensions.json";
  const extensionSwaggerSchema = Parse(await ReadUri(extensionSwaggerSchemaUrl));
  const swaggerSchemaUrl = "http://json.schemastore.org/swagger-2.0";
  const swaggerSchema = Parse(await ReadUri(swaggerSchemaUrl));
  const exampleSchemaUrl = "https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json";
  const exampleSchema = Parse(await ReadUri(exampleSchemaUrl));

  (validator as any).setRemoteReference(swaggerSchemaUrl, swaggerSchema);
  (validator as any).setRemoteReference(exampleSchemaUrl, exampleSchema);
  return CreatePerFilePlugin(async config => async (fileIn, sink) => {
    const obj = fileIn.ReadObject<any>();
    const result = await new Promise<Error | null>(res => validator.validate(obj, extensionSwaggerSchema, (err, valid) => res(valid ? null : err)));
    if (result !== null) {
      console.error(JSON.stringify(result));
    }
    return await sink.Forward(fileIn.Description, fileIn);
  });
}