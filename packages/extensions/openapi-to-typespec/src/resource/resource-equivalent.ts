import {
  ArraySchema,
  getAllProperties,
  isObjectSchema,
  ObjectSchema,
  Operation,
  SchemaResponse,
} from "@autorest/codemodel";
import { isArmIdSchema, isArraySchema, isDictionarySchema, isResponseSchema, isStringSchema } from "../utils/schemas";

// Common-type v2 resource doesn't have systemData
export function isResource(schema: ObjectSchema): boolean {
  let idPropertyFound = false;
  let typePropertyFound = false;
  let namePropertyFound = false;
  for (const property of getAllProperties(schema)) {
    if (property.flattenedNames) continue;

    if (property.serializedName === "id" && (isStringSchema(property.schema) || isArmIdSchema(property.schema))) {
      idPropertyFound = true;
    } else if (property.serializedName === "type" && isStringSchema(property.schema)) {
      typePropertyFound = true;
    } else if (property.serializedName === "name" && isStringSchema(property.schema)) {
      namePropertyFound = true;
    }
  }
  return idPropertyFound && typePropertyFound && namePropertyFound;
}

export function isTrackedResource(schema: ObjectSchema): boolean {
  if (!isResource(schema)) return false;

  let isLocationFound = false;
  let isTagsFound = false;
  for (const property of getAllProperties(schema)) {
    if (property.flattenedNames) continue;

    if (property.serializedName === "location" && isStringSchema(property.schema)) {
      isLocationFound = true;
    } else if (property.serializedName === "tags" && isDictionarySchema(property.schema)) {
      isTagsFound = true;
    }
  }
  return isLocationFound && isTagsFound;
}

export function getPagingItemType(operation: Operation): string | undefined {
  const response = operation.responses?.find((r) => isResponseSchema(r));
  if (response === undefined) return undefined;

  let itemName = "value";
  if (operation.extensions?.["x-ms-pageable"]?.itemName) {
    itemName = operation.extensions?.["x-ms-pageable"]?.itemName;
  }

  const schemaResponse = response as SchemaResponse;
  if (isArraySchema(schemaResponse.schema)) return schemaResponse.schema.elementType.language.default.name;
  if (isObjectSchema(schemaResponse.schema)) {
    const responseSchema = schemaResponse.schema.properties?.find(
      (p) => p.serializedName === itemName && isArraySchema(p.schema),
    );
    if (!responseSchema) return undefined;
    return (responseSchema.schema as ArraySchema).elementType.language.default.name;
  }
  return undefined;
}
