import { PipelinePlugin } from "../../pipeline/common";
import oai3 from "@azure-tools/openapi";
import { validateOpenAPISemantics } from "./semantics-validation";
import { DataHandle } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import util from "util";
import { SemanticError } from "./types";

export function createSemanticValidationPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    if (context.config["skip-semantics-validation"]) {
      context.trackWarning({ code: "SkippedSemanticValidation", message: "Semantic validation was skipped." });
      return input;
    }
    const inputs = await Promise.all((await input.enum()).map(async (x) => input.readStrict(x)));

    for (const file of inputs) {
      const model = await file.readObject<oai3.Model>();
      const errors = validateOpenAPISemantics(model);
      if (errors.length > 0) {
        for (const error of errors) {
          logValidationError(context, file, error);
        }
        throw new Error("Semantic validation failed. There was some errors");
      }
    }

    return input;
  };
}

export function logValidationError(context: AutorestContext, fileIn: DataHandle, error: SemanticError) {
  const messageLines = [`Semantic violation: ${error.message} (${error.path.join(" > ")})`];
  for (const [name, value] of Object.entries(error.params)) {
    const formattedValue = util.inspect(value, { colors: true });
    messageLines.push(`  **${name}**: ${formattedValue}`);
  }

  context.trackError({
    code: error.code,
    message: messageLines.join("\n"),
    source: [{ document: fileIn.key, position: { path: error.path } }],
    details: error,
  });
}
