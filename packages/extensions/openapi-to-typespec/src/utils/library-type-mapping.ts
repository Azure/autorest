import { ChoiceSchema, isObjectSchema, Schema, SealedChoiceSchema } from "@autorest/codemodel";
import { getArmCommonTypeVersion } from "../autorest-session";
import { isArraySchema, isChoiceSchema, isDictionarySchema, isSealedChoiceSchema, isUuidSchema } from "./schemas";

// TO-DO: we might need a isReadonly
interface LibraryPropertyBase {
  serializedName: string;
  required: boolean;
  type: string;
}

interface LibraryPrimitiveProperty extends LibraryPropertyBase {
  type: "primitive";
  schema: (schema: Schema) => boolean;
}

interface LibraryNonPrimitiveProperty extends LibraryPropertyBase {
  type: "nonPrimitive";
  schema: () => LibraryType;
}

type LibraryProperty = LibraryPrimitiveProperty | LibraryNonPrimitiveProperty;

interface LibraryTypeBase {
  name: string;
  type: string;
}

interface LibraryObjectType extends LibraryTypeBase {
  type: "object";
  properties: Record<string, LibraryProperty>;
}

interface LibraryArrayType extends LibraryTypeBase {
  type: "array";
  elementType: () => LibraryType;
}

interface LibraryPrimitiveType extends LibraryTypeBase {
  type: "primitive";
  schema: (schema: Schema) => boolean;
}

interface LibraryEnumType extends LibraryTypeBase {
  type: "enum";
  sealed: boolean;
  values: Record<string, string>;
}

interface LibraryDictionaryType extends LibraryTypeBase {
  type: "dictionary";
  valueType: () => LibraryType;
}

export type LibraryType =
  | LibraryObjectType
  | LibraryEnumType
  | LibraryArrayType
  | LibraryPrimitiveType
  | LibraryDictionaryType;

export function isEquivalent(schema: Schema, expected: LibraryType): boolean {
  if (expected.type === "object") {
    if (!isObjectSchema(schema)) return false;
    if (schema.properties?.length !== Object.keys(expected.properties).length) return false;

    for (const property of schema.properties ?? []) {
      if (property.serializedName in expected.properties) {
        const expectedProperty = expected.properties[property.serializedName];
        if ((property.required ?? false) !== expectedProperty.required) return false;

        if (expectedProperty.type === "primitive") {
          if (!expectedProperty.schema(property.schema)) return false;
        } else {
          if (!isEquivalent(property.schema, expectedProperty.schema())) return false;
        }
      } else return false;
    }
  } else if (expected.type === "enum") {
    if (expected.sealed && !isSealedChoiceSchema(schema)) return false;
    if (!expected.sealed && !isChoiceSchema(schema)) return false;

    const actualSchema = schema as SealedChoiceSchema | ChoiceSchema;
    if (actualSchema.choices.length !== Object.keys(expected.values).length) return false;

    for (const choice of actualSchema.choices) {
      if (choice.language.default.name in expected.values) {
        if (expected.values[choice.language.default.name] !== choice.value) return false;
      } else return false;
    }
  } else if (expected.type === "array") {
    if (!isArraySchema(schema)) return false;
    if (!isEquivalent(schema.elementType, expected.elementType())) return false;
  } else if (expected.type === "primitive") {
    if (!expected.schema(schema)) return false;
  } else if (expected.type === "dictionary") {
    if (!isDictionarySchema(schema)) return false;
    if (!isEquivalent(schema.elementType, expected.valueType())) return false;
  }

  return true;
}

const skuTierLibraryType: LibraryEnumType = {
  name: "skuTier",
  type: "enum",
  sealed: true,
  values: {
    Free: "Free",
    Basic: "Basic",
    Standard: "Standard",
    Premium: "Premium",
  },
};

export const skuLibraryType: LibraryObjectType = {
  name: "sku",
  type: "object",
  properties: {
    name: { serializedName: "name", required: true, type: "primitive", schema: (schema) => schema.type === "string" },
    tier: { serializedName: "tier", required: false, type: "nonPrimitive", schema: () => skuTierLibraryType },
    size: { serializedName: "size", required: false, type: "primitive", schema: (schema) => schema.type === "string" },
    family: {
      serializedName: "family",
      required: false,
      type: "primitive",
      schema: (schema) => schema.type === "string",
    },
    capacity: {
      serializedName: "capacity",
      required: false,
      type: "primitive",
      schema: (schema) => schema.type === "integer",
    },
  },
};

const extendedLocationTypeLibraryType: LibraryEnumType = {
  name: "extendedLocationType",
  type: "enum",
  sealed: false,
  values: {
    Edge: "Edge",
    CustomLocation: "CustomLocation",
  },
};

export const extendedLocationLibraryType: LibraryObjectType = {
  name: "extendedLocation",
  type: "object",
  properties: {
    type: {
      serializedName: "type",
      required: true,
      type: "nonPrimitive",
      schema: () => extendedLocationTypeLibraryType,
    },
    name: { serializedName: "name", required: true, type: "primitive", schema: (schema) => schema.type === "string" },
  },
};

export const planLibraryType: LibraryObjectType = {
  name: "plan",
  type: "object",
  properties: {
    name: { serializedName: "name", required: true, type: "primitive", schema: (schema) => schema.type === "string" },
    publisher: {
      serializedName: "publisher",
      required: true,
      type: "primitive",
      schema: (schema) => schema.type === "string",
    },
    product: {
      serializedName: "product",
      required: true,
      type: "primitive",
      schema: (schema) => schema.type === "string",
    },
    promotionCode: {
      serializedName: "promotionCode",
      required: false,
      type: "primitive",
      schema: (schema) => schema.type === "string",
    },
    version: {
      serializedName: "version",
      required: false,
      type: "primitive",
      schema: (schema) => schema.type === "string",
    },
  },
};

const managedServiceIdentityTypeLibraryType: LibraryEnumType = {
  name: "managedServiceIdentityType",
  type: "enum",
  sealed: false,
  values: {
    None: "None",
    SystemAssigned: "SystemAssigned",
    UserAssigned: "UserAssigned",
    "SystemAssigned,UserAssigned": "SystemAssigned,UserAssigned",
  },
};

const managedServiceIdentityTypeLibraryTypeV4: LibraryEnumType = {
  name: "managedServiceIdentityType",
  type: "enum",
  sealed: false,
  values: {
    None: "None",
    SystemAssigned: "SystemAssigned",
    UserAssigned: "UserAssigned",
    "SystemAssigned, UserAssigned": "SystemAssigned, UserAssigned",
  },
};

const userAssignedIdentityLibraryType: LibraryObjectType = {
  name: "userAssignedIdentity",
  type: "object",
  properties: {
    principalId: { serializedName: "principalId", required: false, type: "primitive", schema: isUuidSchema },
    clientId: { serializedName: "clientId", required: false, type: "primitive", schema: isUuidSchema },
  },
};

export const managedServiceIdentityLibraryType: LibraryObjectType = {
  name: "managedServiceIdentity",
  type: "object",
  properties: {
    principalId: { serializedName: "principalId", required: false, type: "primitive", schema: isUuidSchema },
    tenantId: { serializedName: "tenantId", required: false, type: "primitive", schema: isUuidSchema },
    type: {
      serializedName: "type",
      required: true,
      type: "nonPrimitive",
      schema: () =>
        getArmCommonTypeVersion() === "v4"
          ? managedServiceIdentityTypeLibraryTypeV4
          : managedServiceIdentityTypeLibraryType,
    },
    // https://github.com/Azure/typespec-azure/issues/1163
    userAssignedIdentities: {
      serializedName: "userAssignedIdentities",
      required: false,
      type: "nonPrimitive",
      schema: () => ({ name: "_", type: "dictionary", valueType: () => userAssignedIdentityLibraryType }),
    },
  },
};
