/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { DataHandle } from "@azure-tools/datastore";
import { OperationAbortedException } from "@autorest/common";
import { Channel } from "../../message";
import { createPerFilePlugin, PipelinePlugin } from "../common";
import { AutorestContext } from "../../configuration";
import { SwaggerSchemaValidator } from "./swagger-schema-validator";
import { PositionedValidationError } from "./json-schema-validator";
import { OpenApi3SchemaValidator } from "./openapi3-schema-validator";

export const SCHEMA_VIOLATION_ERROR_CODE = "schema_violation";

export function createSwaggerSchemaValidatorPlugin(): PipelinePlugin {
  const swaggerValidator = new SwaggerSchemaValidator();

  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];

    const errors = await swaggerValidator.validateFile(fileIn);
    if (errors) {
      for (const error of errors) {
        // secondary files have reduced schema compliancy, so we're gonna just warn them for now.
        logValidationError(config, fileIn, error, isSecondary ? "warning" : "error");
      }
      if (!isSecondary) {
        throw new OperationAbortedException();
      }
    }
    return sink.Forward(fileIn.Description, fileIn);
  });
}

export function createOpenApiSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new OpenApi3SchemaValidator();

  return createPerFilePlugin(async (context) => async (fileIn, sink) => {
    const obj = await fileIn.ReadObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];
    const markErrorAsWarnings = context.config["mark-oai3-errors-as-warnings"];
    const errors = await validator.validateFile(fileIn);
    if (errors !== null) {
      for (const error of errors) {
        const level = markErrorAsWarnings || isSecondary ? "warning" : "error";
        logValidationError(context, fileIn, error as any, level);
      }
      if (!isSecondary) {
        context.Message({
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

const logValidationError = (
  config: AutorestContext,
  fileIn: DataHandle,
  error: PositionedValidationError,
  type: "error" | "warning",
) => {
  const msg = {
    code: SCHEMA_VIOLATION_ERROR_CODE,
    message: `Schema violation: ${error.message} (${error.path.join(" > ")})`,
    source: [{ document: fileIn.key, position: error.position }],
    details: error,
  };

  if (type == "warning") {
    config.trackWarning(msg);
  } else {
    config.trackError(msg);
  }
};
