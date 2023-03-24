import {
  ArraySchema,
  ChoiceSchema,
  ConstantSchema,
  DictionarySchema,
  Schema,
  SchemaResponse,
  SchemaType,
  SealedChoiceSchema,
  Response,
  AnySchema,
} from "@autorest/codemodel";

export function isConstantSchema(schema: Schema): schema is ConstantSchema {
  return schema.type === SchemaType.Constant;
}

export function isArraySchema(schema: Schema): schema is ArraySchema {
  return schema.type === SchemaType.Array;
}

export function isChoiceSchema(schema: Schema): schema is ChoiceSchema {
  return schema.type === SchemaType.Choice;
}

export function isSealedChoiceSchema(schema: Schema): schema is SealedChoiceSchema {
  return schema.type === SchemaType.SealedChoice;
}

export function isDictionarySchema(schema: Schema): schema is DictionarySchema {
  return schema.type === SchemaType.Dictionary;
}

export function isResponseSchema(response: Response | SchemaResponse): response is SchemaResponse {
  return (response as SchemaResponse).schema !== undefined;
}

export function isAnySchema(schema: Schema): schema is AnySchema {
  return schema.type === SchemaType.Any || schema.type === SchemaType.AnyObject;
}
