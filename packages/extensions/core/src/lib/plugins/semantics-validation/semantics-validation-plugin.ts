import { PipelinePlugin } from "../../pipeline/common";
import oai3, { dereference, Refable } from "@azure-tools/openapi";
import { validateOpenAPISemantics } from "./semantics-validation";
import { DataHandle } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import util from "util";
import { SemanticError } from "./types";
import { JsonRef, parseJsonRef, stringifyJsonRef } from "@azure-tools/jsonschema";

export function createSemanticValidationPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    if (context.config["skip-semantics-validation"]) {
      context.trackWarning({ code: "SkippedSemanticValidation", message: "Semantic validation was skipped." });
      return input;
    }
    const inputs = await Promise.all((await input.enum()).map(async (x) => input.readStrict(x)));

    const specMap = new Map();

    for (const file of inputs) {
      const model = await file.readObject<oai3.Model>();
      specMap.set(file.identity[0], model);
    }

    const resolveReference = <T>(item: Refable<T>, from: string): T => {
      if (!("$ref" in item)) {
        return item;
      }
      const ref = parseJsonRef(item.$ref);
      const file = ref.file ?? from;
      const spec = specMap.get(file);
      if (!spec) {
        throw new Error(`Cannot find spec '${file}' referenced in ${stringifyJsonRef({ file, path: ref.path })}`);
      }
      return dereference<T>(spec, {
        $ref: stringifyJsonRef({ path: ref.path }),
      }).instance;
    };

    for (const [name, spec] of specMap.entries()) {
      const errors = validateOpenAPISemantics(spec, (item) => resolveReference(item, name));
      if (errors.length > 0) {
        for (const error of errors) {
          logValidationError(context, spec, error);
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
