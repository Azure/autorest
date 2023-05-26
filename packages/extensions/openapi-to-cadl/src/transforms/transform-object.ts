import {
  CodeModel,
  DictionarySchema,
  isObjectSchema,
  ObjectSchema,
  Property,
  Schema,
  SchemaType,
} from "@autorest/codemodel";
import { getDataTypes } from "../data-types";
import { CadlObject, CadlObjectProperty } from "../interfaces";
import { addCorePageAlias } from "../utils/alias";
import { getModelDecorators, getPropertyDecorators } from "../utils/decorators";
import { getDiscriminator, getOwnDiscriminator } from "../utils/discriminator";
import { getLogger } from "../utils/logger";
import {
  isAnySchema,
  isArraySchema,
  isChoiceSchema,
  isConstantSchema,
  isDictionarySchema,
  isSealedChoiceSchema,
} from "../utils/schemas";
import { transformValue } from "../utils/values";

const cadlTypes = new Map<SchemaType, string>([
  [SchemaType.Date, "plainDate"],
  [SchemaType.DateTime, "utcDateTime"],
  [SchemaType.UnixTime, "plainTime"],
  [SchemaType.String, "string"],
  [SchemaType.Time, "plainTime"],
  [SchemaType.Uuid, "string"],
  [SchemaType.Uri, "string"],
  [SchemaType.ByteArray, "bytes"],
  [SchemaType.Binary, "bytes"],
  [SchemaType.Number, "float32"],
  [SchemaType.Integer, "int32"],
  [SchemaType.Boolean, "boolean"],
  [SchemaType.Credential, "@secret string"],
  [SchemaType.Duration, "duration"],
  [SchemaType.AnyObject, "object"],
]);

export function transformObject(schema: ObjectSchema, codeModel: CodeModel): CadlObject {
  const cadlTypes = getDataTypes(codeModel);
  let visited: Partial<CadlObject> = cadlTypes.get(schema) as CadlObject;
  if (visited) {
    return visited as CadlObject;
  }

  const logger = getLogger("transformOperationGroup");

  logger.info(`Transforming object ${schema.language.default.name}`);

  const name = schema.language.default.name.replace(/-/g, "_");
  const doc = schema.language.default.description;

  // Marking as visited before processing properties to avoid infinite recursion
  // when transforming properties that reference this object.
  visited = { name, doc };
  cadlTypes.set(schema, visited as any);

  const properties = (schema.properties ?? [])
    .filter((p) => !p.isDiscriminator)
    .map((p) => transformObjectProperty(p, codeModel));

  const ownDiscriminator = getOwnDiscriminator(schema);
  if (!ownDiscriminator) {
    const discriminatorProperty = getDiscriminator(schema);
    discriminatorProperty && properties.push(discriminatorProperty);
  }

  const updatedVisited: CadlObject = {
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

  cadlTypes.set(schema, updatedVisited);
  return updatedVisited;
}

function addFixmes(cadlObject: CadlObject): void {
  cadlObject.fixMe = cadlObject.fixMe ?? [];

  if ((cadlObject.extendedParents ?? []).length > 1) {
    cadlObject.fixMe
      .push(`// FIXME: (multiple-inheritance) Multiple inheritance is not supported in CADL, so this type will only inherit from one parent.
     // this may happen because of multiple parents having discriminator properties.
     // Parents not included ${cadlObject.extendedParents?.join(", ")}`);
  }
}

export function transformObjectProperty(propertySchema: Property, codeModel: CodeModel): CadlObjectProperty {
  const name = propertySchema.language.default.name;
  const doc = propertySchema.language.default.description;
  if (isObjectSchema(propertySchema.schema)) {
    const dataTypes = getDataTypes(codeModel);
    let visited = dataTypes.get(propertySchema.schema) as CadlObject;
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
      ...(propertySchema.readOnly === true && { visibility: "read" }),
    };
  }

  const logger = getLogger("getDiscriminatorProperty");

  logger.info(`Transforming property ${propertySchema.language.default.name} of type ${propertySchema.schema.type}`);
  return {
    kind: "property",
    doc,
    name,
    isOptional: propertySchema.required !== true,
    type: getCadlType(propertySchema.schema, codeModel),
    decorators: getPropertyDecorators(propertySchema),
    fixMe: getFixme(propertySchema, codeModel),
  };
}

function getFixme(property: Property, codeModel: CodeModel): string[] {
  const cadlType = getCadlType(property.schema, codeModel);
  if (cadlType === "utcDateTime") {
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
    spreadingParents.push(`Record<${getCadlType(dictionaryParent.elementType, codeModel)}>`);
  }
  return spreadingParents;
}

export function getCadlType(schema: Schema, codeModel: CodeModel): string {
  const schemaType = schema.type;
  const visited = getDataTypes(codeModel).get(schema);

  if (visited) {
    return visited.name;
  }

  if (isConstantSchema(schema)) {
    return `${transformValue(schema.value.value as any)}`;
  }

  if (isArraySchema(schema)) {
    const elementType = getCadlType(schema.elementType, codeModel);
    return `${elementType}[]`;
  }

  if (isObjectSchema(schema)) {
    return schema.language.default.name.replace(/-/g, "_");
  }

  if (isChoiceSchema(schema) || isSealedChoiceSchema(schema)) {
    return schema.language.default.name.replace(/-/g, "_");
  }

  if (isDictionarySchema(schema)) {
    return `Record<${getCadlType(schema.elementType, codeModel)}>`;
  }

  if (isAnySchema(schema)) {
    return `unknown`;
  }

  const cadlType = cadlTypes.get(schemaType);

  if (!cadlType) {
    throw new Error(`Unknown type ${(schema as any).type}`);
  }

  return cadlType;
}
