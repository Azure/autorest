import { Schema } from "@autorest/codemodel";
import { isChoiceSchema } from "./schemas";

export function transformValue(value: string | number | boolean) {
  if (typeof value === "string") {
    return `"${value}"`;
  }

  return value;
}

export function transformDefaultValue(type: string, value: string | number | boolean) {
  if (type === "string" || type === "int32" || type === "boolean") {
    return transformValue(value);
  } else {
    return `${type}.${value}`;
  }
}

export function getDefaultValue(schema: Schema) {
  if (schema.defaultValue === undefined) {
    return undefined;
  }
  if (isChoiceSchema(schema)) {
    for (const choice of schema.choices) {
      if (schema.defaultValue === choice.value.toString()) {
        return choice.language.default.name;
      }
    }
  } else {
    return schema.defaultValue;
  }
}
