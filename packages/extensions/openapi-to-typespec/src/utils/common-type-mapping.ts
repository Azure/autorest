import { ChoiceSchema, isObjectSchema, ObjectSchema, Schema, SealedChoiceSchema } from "@autorest/codemodel";
import { ArmCommonTypeVersion, getArmCommonTypeVersion } from "../autorest-session";
import { isChoiceSchema, isDictionarySchema, isSealedChoiceSchema, isUuidSchema } from "./schemas";

interface PropertyCondition {
  serializedName: string;
  required: boolean;
  schema: (property: Schema) => boolean;
}
function isEquivalentObject(schema: ObjectSchema, properties: Record<string, PropertyCondition>): boolean {
  if (schema.properties?.length !== Object.keys(properties).length) return false;

  for (const property of schema.properties ?? []) {
    if (property.serializedName in properties) {
      const propertySchema = properties[property.serializedName];
      if ((property.required ?? false) !== propertySchema.required) return false;
      if (!propertySchema.schema(property.schema)) return false;
    } else return false;
  }
  return true;
}

interface ChoiceValueCondition {
  value: string;
}
function isEquivalentChoice(
  schema: SealedChoiceSchema | ChoiceSchema,
  choices: Record<ArmCommonTypeVersion, Record<string, ChoiceValueCondition>>,
): boolean {
  const commonTypeVersion = getArmCommonTypeVersion();
  const choiceVersion = choices[commonTypeVersion];
  if (schema.choices.length !== Object.keys(choiceVersion).length) return false;

  for (const choice of schema.choices) {
    if (choice.language.default.name in choiceVersion) {
      if (choiceVersion[choice.language.default.name].value !== choice.value) return false;
    } else return false;
  }
  return true;
}

const skuProperties: Record<string, PropertyCondition> = {
  name: { serializedName: "name", required: true, schema: (schema) => schema.type === "string" },
  tier: { serializedName: "tier", required: false, schema: isSkuTier },
  size: { serializedName: "size", required: false, schema: (schema) => schema.type === "string" },
  family: { serializedName: "family", required: false, schema: (schema) => schema.type === "string" },
  capacity: { serializedName: "capacity", required: false, schema: (schema) => schema.type === "integer" },
};
export function isSku(schema: Schema): boolean {
  return isObjectSchema(schema) && isEquivalentObject(schema, skuProperties);
}

const skuTierChoiceValues: Record<ArmCommonTypeVersion, Record<string, ChoiceValueCondition>> = [
  "v3",
  "v4",
  "v5",
  "v6",
].reduce(
  (acc, version) => {
    acc[version] = {
      Free: { value: "Free" },
      Basic: { value: "Basic" },
      Standard: { value: "Standard" },
      Premium: { value: "Premium" },
    };
    return acc;
  },
  {} as Record<string, Record<string, ChoiceValueCondition>>,
);
function isSkuTier(schema: Schema): boolean {
  return isSealedChoiceSchema(schema) && isEquivalentChoice(schema, skuTierChoiceValues);
}

const extendedLocationProperties: Record<string, PropertyCondition> = {
  type: { serializedName: "type", required: true, schema: isExtendedLocationType },
  name: { serializedName: "name", required: true, schema: (schema) => schema.type === "string" },
};
export function isExtendedLocation(schema: Schema): boolean {
  return isObjectSchema(schema) && isEquivalentObject(schema, extendedLocationProperties);
}

const extendLocationTypeChoiceValues: Record<ArmCommonTypeVersion, Record<string, ChoiceValueCondition>> = [
  "v3",
  "v4",
  "v5",
  "v6",
].reduce(
  (acc, version) => {
    acc[version] = {
      Edge: { value: "Edge" },
      CustomLocation: { value: "CustomLocation" },
    };
    return acc;
  },
  {} as Record<string, Record<string, ChoiceValueCondition>>,
);
function isExtendedLocationType(schema: Schema): boolean {
  return isChoiceSchema(schema) && isEquivalentChoice(schema, extendLocationTypeChoiceValues);
}

const planProperties: Record<string, PropertyCondition> = {
  name: { serializedName: "name", required: true, schema: (schema) => schema.type === "string" },
  publisher: { serializedName: "publisher", required: true, schema: (schema) => schema.type === "string" },
  product: { serializedName: "product", required: true, schema: (schema) => schema.type === "string" },
  promotionCode: { serializedName: "promotionCode", required: false, schema: (schema) => schema.type === "string" },
  version: { serializedName: "version", required: false, schema: (schema) => schema.type === "string" },
};
export function isPlan(schema: Schema): boolean {
  return isObjectSchema(schema) && isEquivalentObject(schema, planProperties);
}

const managedServiceIdentityProperties: Record<string, PropertyCondition> = {
  principalId: { serializedName: "principalId", required: false, schema: isUuidSchema },
  tenantId: { serializedName: "tenantId", required: false, schema: isUuidSchema },
  type: { serializedName: "type", required: true, schema: isManagedSerivceIdentityType },
  userAssignedIdentities: {
    serializedName: "userAssignedIdentities",
    required: false,
    schema: (schema) => isDictionarySchema(schema) && isUserAssignedIdentity(schema.elementType),
  },
};
export function isManagedSerivceIdentity(schema: Schema): boolean {
  return isObjectSchema(schema) && isEquivalentObject(schema, managedServiceIdentityProperties);
}

const managedServiceIdentityTypeChoiceValues: Record<ArmCommonTypeVersion, Record<string, ChoiceValueCondition>> = {
  v3: {
    None: { value: "None" },
    SystemAssigned: { value: "SystemAssigned" },
    UserAssigned: { value: "UserAssigned" },
    "SystemAssigned,UserAssigned": { value: "SystemAssigned,UserAssigned" },
  },
  v4: {
    None: { value: "None" },
    SystemAssigned: { value: "SystemAssigned" },
    UserAssigned: { value: "UserAssigned" },
    "SystemAssigned, UserAssigned": { value: "SystemAssigned, UserAssigned" },
  },
  v5: {
    None: { value: "None" },
    SystemAssigned: { value: "SystemAssigned" },
    UserAssigned: { value: "UserAssigned" },
    "SystemAssigned,UserAssigned": { value: "SystemAssigned, UserAssigned" },
  },
  v6: {
    None: { value: "None" },
    SystemAssigned: { value: "SystemAssigned" },
    UserAssigned: { value: "UserAssigned" },
    "SystemAssigned,UserAssigned": { value: "SystemAssigned,UserAssigned" },
  },
};
function isManagedSerivceIdentityType(schema: Schema): boolean {
  return isChoiceSchema(schema) && isEquivalentChoice(schema, managedServiceIdentityTypeChoiceValues);
}

const userAssignedIdentityProperties: Record<string, PropertyCondition> = {
  principalId: { serializedName: "principalId", required: false, schema: isUuidSchema },
  clientId: { serializedName: "clientId", required: false, schema: isUuidSchema },
};
function isUserAssignedIdentity(schema: Schema): boolean {
  return isObjectSchema(schema) && isEquivalentObject(schema, userAssignedIdentityProperties);
}
