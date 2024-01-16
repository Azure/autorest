import {
  CodeModel,
  DictionarySchema,
  isNumberSchema,
  isObjectSchema,
  NumberSchema,
  ObjectSchema,
  Property,
  Schema,
  SchemaType,
  StringSchema,
} from "@autorest/codemodel";
import { get } from "lodash";
import { getDataTypes } from "../data-types";
import { TypespecObject, TypespecObjectProperty } from "../interfaces";
import { addCorePageAlias } from "../utils/alias";
import { getModelDecorators, getPropertyDecorators } from "../utils/decorators";
import { getDiscriminator, getOwnDiscriminator } from "../utils/discriminator";
import { getLogger } from "../utils/logger";
import {
  isAnyObjectSchema,
  isAnySchema,
  isArmIdSchema,
  isArraySchema,
  isChoiceSchema,
  isConstantSchema,
  isDictionarySchema,
  isSealedChoiceSchema,
  isStringSchema,
} from "../utils/schemas";
import { getDefaultValue, transformValue } from "../utils/values";

const typespecTypes = new Map<string, string>([
  [SchemaType.Date, "plainDate"],
  [SchemaType.DateTime, "utcDateTime"],
  [SchemaType.UnixTime, "plainTime"],
  [SchemaType.String, "string"],
  [SchemaType.Time, "plainTime"],
  [SchemaType.Uuid, "string"],
  [SchemaType.Uri, "url"],
  [SchemaType.ByteArray, "bytes"],
  [SchemaType.Binary, "bytes"],
  [SchemaType.Number + "32", "float32"],
  [SchemaType.Number + "64", "float64"],
  [SchemaType.Number + "128", "decimal"],
  [SchemaType.Integer + "32", "int32"],
  [SchemaType.Integer + "64", "int64"],
  [SchemaType.Boolean, "boolean"],
  [SchemaType.Credential, "string"],
  [SchemaType.Duration, "duration"],
  [SchemaType.AnyObject, "object"],
]);

export function transformObject(schema: ObjectSchema, codeModel: CodeModel): TypespecObject {
  const typespecTypes = getDataTypes(codeModel);
  let visited: Partial<TypespecObject> = typespecTypes.get(schema) as TypespecObject;
  if (visited) {
    return visited as TypespecObject;
  }

  const logger = getLogger("transformObject");

  logger.info(`Transforming object ${schema.language.default.name}`);

  const name = schema.language.default.name.replace(/-/g, "_");
  const doc = schema.language.default.description;

  // Marking as visited before processing properties to avoid infinite recursion
  // when transforming properties that reference this object.
  visited = { name, doc };
  typespecTypes.set(schema, visited as any);

  const properties = (schema.properties ?? [])
    .filter((p) => !p.isDiscriminator)
    .map((p) => transformObjectProperty(p, codeModel));

  const ownDiscriminator = getOwnDiscriminator(schema);
  if (!ownDiscriminator) {
    const discriminatorProperty = getDiscriminator(schema);
    discriminatorProperty && properties.push(discriminatorProperty);
  }

  const updatedVisited: TypespecObject = {
    name,
    doc,
    kind: "object",
    properties,
    parents: getParents(schema),
    extendedParents: getExtendedParents(schema),
    spreadParents: getSpreadParents(schema, codeModel),
    decorators: getModelDecorators(schema),
  };

  addCorePageAlias(updatedVisited);
  addFixmes(updatedVisited);

  typespecTypes.set(schema, updatedVisited);
  return updatedVisited;
}

function addFixmes(typespecObject: TypespecObject): void {
  typespecObject.fixMe = typespecObject.fixMe ?? [];

  if ((typespecObject.extendedParents ?? []).length > 1) {
    typespecObject.fixMe
      .push(`// FIXME: (multiple-inheritance) Multiple inheritance is not supported in Typespec, so this type will only inherit from one parent.
     // this may happen because of multiple parents having discriminator properties.
     // Parents not included ${typespecObject.extendedParents?.join(", ")}`);
  }
}

export function transformObjectProperty(propertySchema: Property, codeModel: CodeModel): TypespecObjectProperty {
  const name = propertySchema.language.default.name;
  const doc = propertySchema.language.default.description;
  if (isObjectSchema(propertySchema.schema)) {
    const dataTypes = getDataTypes(codeModel);
    let visited = dataTypes.get(propertySchema.schema) as TypespecObject;
    if (!visited) {
      visited = transformObject(propertySchema.schema, codeModel);
      dataTypes.set(propertySchema.schema, visited);
    }

    return {
      kind: "property",
      name: name,
      doc: doc,
      isOptional: propertySchema.required !== true,
      type: visited.name,
      decorators: getPropertyDecorators(propertySchema),
      defaultValue: getDefaultValue(propertySchema.schema),
    };
  }

  const logger = getLogger("getDiscriminatorProperty");

  logger.info(`Transforming property ${propertySchema.language.default.name} of type ${propertySchema.schema.type}`);
  return {
    kind: "property",
    doc,
    name,
    isOptional: propertySchema.required !== true,
    type: getTypespecType(propertySchema.schema, codeModel),
    decorators: getPropertyDecorators(propertySchema),
    fixMe: getFixme(propertySchema, codeModel),
    defaultValue: getDefaultValue(propertySchema.schema),
  };
}

function getFixme(property: Property, codeModel: CodeModel): string[] {
  const typespecType = getTypespecType(property.schema, codeModel);
  if (typespecType === "utcDateTime") {
    return ["// FIXME: (utcDateTime) Please double check that this is the correct type for your scenario."];
  }

  return [];
}

function getParents(schema: ObjectSchema): string[] {
  const immediateParents = schema.parents?.immediate ?? [];

  return immediateParents
    .filter((p) => p.language.default.name !== schema.language.default.name)
    .map((p) => p.language.default.name);
}

function getExtendedParents(schema: ObjectSchema): string[] {
  const immediateParents = schema.parents?.immediate ?? [];
  return immediateParents
    .filter((p) => p.language.default.name !== schema.language.default.name)
    .filter((p) => getOwnDiscriminator(p as ObjectSchema))
    .map((p) => p.language.default.name);
}

function getSpreadParents(schema: ObjectSchema, codeModel: CodeModel): string[] {
  const immediateParents = schema.parents?.immediate ?? [];
  const spreadingParents = immediateParents
    .filter((p) => p.language.default.name !== schema.language.default.name)
    .filter((p) => !isDictionarySchema(p))
    .filter((p) => !getOwnDiscriminator(p as ObjectSchema))
    .map((p) => p.language.default.name);

  const dictionaryParent = immediateParents.find((p) => isDictionarySchema(p)) as DictionarySchema | undefined;
  if (dictionaryParent) {
    spreadingParents.push(`Record<${getTypespecType(dictionaryParent.elementType, codeModel)}>`);
  }
  return spreadingParents;
}

function getArmIdType(schema: Schema): string {
  const allowedResources = schema.extensions?.["x-ms-arm-id-details"]?.["allowedResources"];
  if (allowedResources) {
    return `ResourceIdentifier<[${schema.extensions?.["x-ms-arm-id-details"]?.["allowedResources"]
      .map((r: { [x: string]: string }) => '{type: "' + r["type"] + '";}')
      .join(",")}]>`;
  } else {
    return "ResourceIdentifier";
  }
}

export function getTypespecType(schema: Schema, codeModel: CodeModel): string {
  let schemaType = schema.type as string;
  const visited = getDataTypes(codeModel).get(schema);

  if (visited) {
    return visited.name;
  }

  if (isConstantSchema(schema)) {
    return `${transformValue(schema.value.value as any)}`;
  }

  if (isArraySchema(schema)) {
    const elementType = getTypespecType(schema.elementType, codeModel);
    return `${elementType}[]`;
  }

  if (isObjectSchema(schema)) {
    return schema.language.default.name.replace(/-/g, "_");
  }

  if (isChoiceSchema(schema) || isSealedChoiceSchema(schema)) {
    return schema.language.default.name.replace(/-/g, "_");
  }

  if (isDictionarySchema(schema)) {
    return `Record<${getTypespecType(schema.elementType, codeModel)}>`;
  }

  if (isAnySchema(schema)) {
    return `unknown`;
  }

  if (isAnyObjectSchema(schema)) {
    return `Record<unknown>`;
  }

  if (isArmIdSchema(schema) || (schema as StringSchema).extensions?.["x-ms-arm-id-details"]) {
    return getArmIdType(schema);
  }

  if (isNumberSchema(schema)) {
    schemaType += `${(schema as NumberSchema).precision}`;
  }

  const typespecType = typespecTypes.get(schemaType);

  if (!typespecType) {
    throw new Error(`Unknown type ${(schema as any).type}`);
  }

  return typespecType;
}
