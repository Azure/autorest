/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable @typescript-eslint/no-var-requires */
import { parseJsonPointer } from "@azure-tools/datastore";
import * as SchemaValidator from "z-schema";
import { OperationAbortedException } from "../exception";
import { Channel } from "../message";
import { createPerFilePlugin, PipelinePlugin } from "./common";

export function createSwaggerSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  const extendedSwaggerSchema = require(`@autorest/schemas/swagger-extensions.json`);
  (<any>validator).setRemoteReference(
    "http://json.schemastore.org/swagger-2.0",
    require(`@autorest/schemas/swagger.json`),
  );
  (<any>validator).setRemoteReference(
    "https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json",
    require(`@autorest/schemas/example-schema.json`),
  );
  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];

    const errors = await new Promise<Array<{
      code: string;
      params: Array<string>;
      message: string;
      path: string;
    }> | null>((res) => validator.validate(obj, extendedSwaggerSchema, (err, valid) => res(valid ? null : err)));
    if (errors !== null) {
      for (const error of errors) {
        const path = parseJsonPointer(error.path);
        config.Message({
          // secondary files have reduced schema compliancy, so we're gonna just warn them for now.
          Channel: isSecondary ? Channel.Warning : Channel.Error,
          Details: error,
          Plugin: "schema-validator-swagger",
          Source: [{ document: fileIn.key, Position: <any>{ path } }],
          Text: `Schema violation: ${error.message} (${path.join(" > ")})`,
        });
      }
      if (!isSecondary) {
        throw new OperationAbortedException();
      }
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}

/* @internal */
export function createOpenApiSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  const extendedOpenApiSchema = require(`@autorest/schemas/openapi3-schema.json`);
  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const errors = await new Promise<Array<{
      code: string;
      params: Array<string>;
      message: string;
      path: string;
    }> | null>((res) => validator.validate(obj, extendedOpenApiSchema, (err, valid) => res(valid ? null : err)));
    if (errors !== null) {
      for (const error of errors) {
        const path = parseJsonPointer(error.path);
        config.Message({
          Channel: Channel.Warning,
          Details: error,
          Plugin: "schema-validator-openapi",
          Source: [{ document: fileIn.key, Position: <any>{ path: parseJsonPointer(error.path) } }],
          Text: `Schema violation: ${error.message} (${path.join(" > ")})`,
        });
      }
      // throw new OperationAbortedException();
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}
