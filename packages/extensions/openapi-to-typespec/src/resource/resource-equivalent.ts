import { getAllProperties, ObjectSchema } from "@autorest/codemodel";
import { isArmIdSchema, isDictionarySchema, isStringSchema } from "../utils/schemas";

export function isResource(schema: ObjectSchema): boolean {
    let idPropertyFound = false;
    let typePropertyFound = false;
    let namePropertyFound = false;
    for (const property of getAllProperties(schema)) {
        if (property.flattenedNames) continue;

        if (property.serializedName === "id" && (isStringSchema(property.schema) || isArmIdSchema(property.schema))) {
            idPropertyFound = true;
        }
        else if (property.serializedName === "type" && isStringSchema(property.schema)) {
            typePropertyFound = true;
        }
        else if (property.serializedName === "name" && isStringSchema(property.schema)) {
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
        }
        else if (property.serializedName === "tags" && isDictionarySchema(property.schema)) {
            isTagsFound = true;
        }
    }
    return isLocationFound && isTagsFound;
}