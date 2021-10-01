/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { OperationAbortedException } from "@autorest/common";
import { DataHandle } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { Channel } from "../../message";
import { createPerFilePlugin, PipelinePlugin } from "../../pipeline/common";
import { ValidationError } from "./json-schema-validator";
import { OpenApi3SchemaValidator } from "./openapi3-schema-validator";
import { SwaggerSchemaValidator } from "./swagger-schema-validator";

export const SCHEMA_VIOLATION_ERROR_CODE = "schema_violation";

export function createSwaggerSchemaValidatorPlugin(): PipelinePlugin {
  const swaggerValidator = new SwaggerSchemaValidator();

  return createPerFilePlugin(async (config) => async (fileIn, sink) => {
    const obj = await fileIn.readObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];

    const errors = await swaggerValidator.validateFile(fileIn);
    if (errors.length > 0) {
      for (const error of errors) {
        // secondary files have reduced schema compliancy, so we're gonna just warn them for now.
        logValidationError(config, fileIn, error, isSecondary ? "warning" : "error");
      }
      if (!isSecondary) {
        throw new OperationAbortedException();
      }
    }
    return sink.forward(fileIn.description, fileIn);
  });
}

export function createOpenApiSchemaValidatorPlugin(): PipelinePlugin {
  const validator = new OpenApi3SchemaValidator();

  return createPerFilePlugin(async (context) => async (fileIn, sink) => {
    const obj = await fileIn.readObject<any>();
    const isSecondary = !!obj["x-ms-secondary-file"];
    const errors = await validator.validateFile(fileIn);
    if (errors.length > 0) {
      for (const error of errors) {
        const level = isSecondary ? "warning" : "error";
        logValidationError(context, fileIn, error as any, level);
      }

      if (!isSecondary) {
        throw new OperationAbortedException();
      }
    }
    return sink.forward(fileIn.description, fileIn);
  });
}

const IGNORED_AJV_PARAMS = new Set(["type", "errors"]);

const logValidationError = (
  config: AutorestContext,
  fileIn: DataHandle,
  error: ValidationError,
  type: "error" | "warning",
) => {
  const messageLines = [`Schema violation: ${error.message} (${error.path.join(" > ")})`];
  for (const [name, value] of Object.entries(error.params).filter(([name]) => !IGNORED_AJV_PARAMS.has(name))) {
    const formattedValue = Array.isArray(value) ? [...new Set(value)].join(", ") : value;
    messageLines.push(`  ${name}: ${formattedValue}`);
  }

  const msg = {
    code: SCHEMA_VIOLATION_ERROR_CODE,
    message: messageLines.join("\n"),
    source: [{ document: fileIn.key, position: { path: error.path } }],
    details: error,
  };

  if (type == "warning") {
    config.trackWarning(msg);
  } else {
    config.trackError(msg);
  }
};
