/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { parseJsonPointer } from '@microsoft.azure/datastore';
import * as SchemaValidator from 'z-schema';
import { OperationAbortedException } from '../exception';
import { Channel } from '../message';
import { createPerFilePlugin, PipelinePlugin } from './common';

export function createSwaggerSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  const extendedSwaggerSchema = require('./swagger-extensions.json');
  (<any>validator).setRemoteReference('http://json.schemastore.org/swagger-2.0', require('./swagger.json'));
  (<any>validator).setRemoteReference('https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json', require('./example-schema.json'));
  return createPerFilePlugin(async config => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const errors = await new Promise<Array<{ code: string, params: Array<string>, message: string, path: string }> | null>(res => validator.validate(obj, extendedSwaggerSchema, (err, valid) => res(valid ? null : err)));
    if (errors !== null) {
      for (const error of errors) {
        config.Message({
          Channel: Channel.Error,
          Details: error,
          Plugin: 'schema-validator-swagger',
          Source: [{ document: fileIn.key, Position: <any>{ path: parseJsonPointer(error.path) } }],
          Text: `Schema violation: ${error.message}`
        });
      }
      throw new OperationAbortedException();
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}

/* @internal */
export function createOpenApiSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  const extendedOpenApiSchema = require('./openapi3-schema.json');
  return createPerFilePlugin(async config => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const errors = await new Promise<Array<{ code: string; params: Array<string>; message: string; path: string }> | null>(res => validator.validate(obj, extendedOpenApiSchema, (err, valid) => res(valid ? null : err)));
    if (errors !== null) {
      for (const error of errors) {
        config.Message({
          Channel: Channel.Warning,
          Details: error,
          Plugin: 'schema-validator-openapi',
          Source: [{ document: fileIn.key, Position: <any>{ path: parseJsonPointer(error.path) } }],
          Text: `Schema violation: ${error.message}`
        });
      }
      // throw new OperationAbortedException();
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}
