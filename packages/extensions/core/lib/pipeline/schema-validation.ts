/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable @typescript-eslint/no-var-requires */
import { DataHandle, parseJsonPointer } from "@azure-tools/datastore";
import * as SchemaValidator from "z-schema";
import { OperationAbortedException } from "../exception";
import { Channel } from "../message";
import { createPerFilePlugin, PipelinePlugin } from "./common";
import * as path from "path";
import { AppRoot } from "../constants";
import { ConfigurationView } from "../configuration";

// TODO-TIM: Find a better way? Move schema to a package?
const schemaFolder =
  process.env.JEST_WORKER_ID === undefined ? "." : path.resolve(AppRoot, "../../libs/autorest-schemas");

export function createSwaggerSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new SchemaValidator({ breakOnFirstError: false });

  const extendedSwaggerSchema = require(`${schemaFolder}/swagger-extensions.json`);
  (<any>validator).setRemoteReference(
    "http://json.schemastore.org/swagger-2.0",
    require(`${schemaFolder}/swagger.json`),
  );
  (<any>validator).setRemoteReference(
    "https://raw.githubusercontent.com/Azure/autorest/master/schema/example-schema.json",
    require(`${schemaFolder}/example-schema.json`),
  );
  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];

    const errors = await validateSchema(obj, extendedSwaggerSchema, validator);
    if (errors !== null) {
      for (const error of errors) {
        // secondary files have reduced schema compliancy, so we're gonna just warn them for now.
        logValidationError(config, fileIn, error, "schema-validator-swagger", isSecondary ? "warning" : "error");
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

  const extendedOpenApiSchema = require(`${schemaFolder}/openapi3-schema.json`);
  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];
    const markErrorAsWarnings = config["mark-oai3-errors-as-warnings"];
    const errors = await validateSchema(obj, extendedOpenApiSchema, validator);
    if (errors !== null) {
      for (const error of errors) {
        const level = markErrorAsWarnings || isSecondary ? "warning" : "error";
        logValidationError(config, fileIn, error, "schema-validator-openapi", level);
      }
      if (!isSecondary) {
        config.Message({
          Channel: Channel.Error,
          Plugin: "schema-validator-openapi",
          Text: [
            `Unrecoverable schema validation errors were encountered in OpenAPI 3 input files.`,
            `You can use --markOpenAPI3ErrorsAsWarning to keep mark as warning and let autorest keep going.`,
            `If you believe this the validation error is incorrect, please open an issue at https://github.com/Azure/autorest`,
            `NOTE: in the future this flag will be removed and validation error will fail the pipeline.`,
          ].join("\n"),
        });
        throw new OperationAbortedException();
      }
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}

interface ValidationError {
  code: "OBJECT_ADDITIONAL_PROPERTIES" | "ONE_OF_MISSING" | string;
  params: string[];
  message: string;
  path: string;
  inner?: ValidationError[];
}

/**
 * @param value Value to validate.
 * @param schema Schema as a javascript object.
 * @param validator Schema validator.
 */
const validateSchema = (
  value: unknown,
  schema: unknown,
  validator: SchemaValidator,
): Promise<ValidationError[] | null> => {
  return new Promise<ValidationError[] | null>((res) =>
    validator.validate(value, schema, (err, valid) => res(valid ? null : err)),
  );
};

const logValidationError = (
  config: ConfigurationView,
  fileIn: DataHandle,
  error: ValidationError,
  pluginName: string,
  type: "error" | "warning",
) => {
  const path = parseJsonPointer(error.path);
  config.Message({
    Channel: type == "warning" ? Channel.Warning : Channel.Error,
    Details: error,
    Plugin: pluginName,
    Source: [{ document: fileIn.key, Position: <any>{ path } }],
    Text: `Schema violation: ${error.message} (${path.join(" > ")})`,
  });
};
