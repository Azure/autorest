/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as SchemaValidator from 'z-schema';
import { parseJsonPointer } from '../ref/jsonpath';
import { ReadUri, ResolveUri } from '../ref/uri';
import { QuickDataSource } from '../data-store/data-store';
import { Parse } from '../ref/yaml';
import { CreatePerFilePlugin, PipelinePlugin } from "./common";
import { Channel } from "../message";
import { OperationAbortedException } from '../exception';

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
    const errors = await new Promise<{ code: string, params: string[], message: string, path: string }[] | null>(res => validator.validate(obj, extensionSwaggerSchema, (err, valid) => res(valid ? null : err)));
    if (errors !== null) {
      for (const error of errors) {
        config.Message({
          Channel: Channel.Error,
          Details: error,
          Plugin: "schema-validator",
          Source: [{ document: fileIn.key, Position: { path: parseJsonPointer(error.path) } as any }],
          Text: `Schema violation: ${error.message}`
        });
      }
      throw new OperationAbortedException();
    }
    return await sink.Forward(fileIn.Description, fileIn);
  });
}