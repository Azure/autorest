import { Schema } from "@autorest/codemodel";
import { isChoiceSchema, isSealedChoiceSchema } from "./schemas";

export function transformValue(value: string | number | boolean) {
  if (typeof value === "string") {
    return `"${value}"`;
  }

  return value;
}

export function getDefaultValue(type: string, schema: Schema) {
  if (schema.defaultValue === undefined) {
    return undefined;
  }
  if (isChoiceSchema(schema) || isSealedChoiceSchema(schema)) {
    for (const choice of schema.choices) {
      if (schema.defaultValue === choice.value.toString()) {
        return `${type}.\`${choice.language.default.name}\``;
      }
    }
  } else {
    return transformValue(schema.defaultValue);
  }
}
