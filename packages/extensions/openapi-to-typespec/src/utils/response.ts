import { ArraySchema, ObjectSchema, SchemaResponse } from "@autorest/codemodel";
import { getSession } from "../autorest-session";
import { getDataTypes } from "../data-types";
import { TypespecModel, TypespecObjectProperty } from "../interfaces";
import { getOptions } from "../options";
import { isArraySchema } from "./schemas";
import { isResourceListResult } from "./type-mapping";

export function transformSchemaResponse(response: SchemaResponse): TypespecModel {
  const codeModel = getSession().model;
  const dataTypes = getDataTypes(codeModel);
  const isArm = getOptions().isArm;

  const mediaTypes = response.protocol.http?.mediaTypes;
  let contentType = "";
  if (mediaTypes && ((mediaTypes as string[]).length !== 1 || (mediaTypes as string[])[0] !== "application/json")) {
    contentType = (mediaTypes as string[]).map((m) => `"${m}"`).join(" | ");
  }
  const additionalProperties: TypespecObjectProperty[] | undefined =
    contentType !== ""
      ? [
          {
            kind: "property",
            name: "contentType",
            isOptional: false,
            type: contentType,
            decorators: [{ name: "header" }],
          },
        ]
      : undefined;

  if (isArm && isResourceListResult(response as SchemaResponse)) {
    const valueSchema = ((response as SchemaResponse).schema as ObjectSchema).properties?.find(
      (p) => p.language.default.name === "value",
    );
    const valueName = dataTypes.get((valueSchema!.schema as ArraySchema).elementType)?.name ?? "void";
    return {
      kind: "template",
      name: "ResourceListResult",
      arguments: [{ kind: "object", name: valueName }],
      additionalProperties: additionalProperties,
    };
  }

  if (isArraySchema(response.schema)) {
    const itemName = dataTypes.get(response.schema.elementType)?.name;
    return {
      kind: "template",
      name: "Azure.Core.Page",
      arguments: [{ kind: "object", name: itemName! }],
      additionalProperties: additionalProperties,
    };
  }

  return { kind: "object", name: response.schema.language.default.name, additionalProperties };
}
