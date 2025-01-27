import { isObjectSchema, Schema } from "@autorest/codemodel";
import { getArmCommonTypeVersion } from "../autorest-session";
import { isChoiceSchema, isDictionarySchema, isSealedChoiceSchema, isUriSchema, isUuidSchema } from "./schemas";

export function isSku(schema: Schema): boolean {
  if (!isObjectSchema(schema) || schema.properties?.length !== 5) return false;

  let nameFound = false;
  let tierFound = false;
  let sizeFound = false;
  let familyFound = false;
  let capacityFound = false;

  for (const property of schema.properties) {
    if (property.serializedName === "name" && property.required && property.schema.type === "string") {
      nameFound = true;
    } else if (property.serializedName === "tier" && !property.required && isSkuTier(property.schema)) {
      tierFound = true;
    } else if (property.serializedName === "size" && !property.required && property.schema.type === "string") {
      sizeFound = true;
    } else if (property.serializedName === "family" && !property.required && property.schema.type === "string") {
      familyFound = true;
    } else if (property.serializedName === "capacity" && !property.required && property.schema.type === "integer") {
      capacityFound = true;
    }
  }
  return nameFound && tierFound && sizeFound && familyFound && capacityFound;
}

function isSkuTier(schema: Schema): boolean {
  if (!isSealedChoiceSchema(schema) || schema.choices.length !== 4) return false;

  let freeFound = false;
  let basicFound = false;
  let standardFound = false;
  let premiumFound = false;
  for (const choice of schema.choices) {
    if (choice.value === "Free") {
      freeFound = true;
    } else if (choice.value === "Basic") {
      basicFound = true;
    } else if (choice.value === "Standard") {
      standardFound = true;
    } else if (choice.value === "Premium") {
      premiumFound = true;
    }
  }
  return freeFound && basicFound && standardFound && premiumFound;
}

export function isExtendedLocation(schema: Schema): boolean {
  if (!isObjectSchema(schema) || schema.properties?.length !== 2) return false;

  let typeFound = false;
  let nameFound = false;

  for (const property of schema.properties) {
    if (property.serializedName === "type" && property.required && isExtendedLocationType(property.schema)) {
      typeFound = true;
    } else if (property.serializedName === "name" && property.required && property.schema.type === "string") {
      nameFound = true;
    }
  }
  return typeFound && nameFound;
}

function isExtendedLocationType(schema: Schema): boolean {
  if (!isChoiceSchema(schema) || schema.choices.length !== 2) return false;

  let edgeFound = false;
  let customLocationFound = false;

  for (const choice of schema.choices) {
    if (choice.value === "Edge") {
      edgeFound = true;
    } else if (choice.value === "CustomLocation") {
      customLocationFound = true;
    }
  }
  return edgeFound && customLocationFound;
}

export function isPlan(schema: Schema): boolean {
  if (!isObjectSchema(schema) || schema.properties?.length !== 5) return false;

  let nameFound = false;
  let publisherFound = false;
  let productFound = false;
  let promotionCodeFound = false;
  let versionFound = false;

  for (const property of schema.properties) {
    if (property.serializedName === "name" && property.required && property.schema.type === "string") {
      nameFound = true;
    } else if (property.serializedName === "publisher" && property.required && property.schema.type === "string") {
      publisherFound = true;
    } else if (property.serializedName === "product" && property.required && property.schema.type === "string") {
      productFound = true;
    } else if (property.serializedName === "promotionCode" && !property.required && property.schema.type === "string") {
      promotionCodeFound = true;
    } else if (property.serializedName === "version" && !property.required && property.schema.type === "string") {
      versionFound = true;
    }
  }

  return nameFound && publisherFound && productFound && promotionCodeFound && versionFound;
}

export function isManagedSerivceIdentity(schema: Schema): boolean {
  if (!isObjectSchema(schema) || schema.properties?.length !== 4) return false;

  const commonTypeVersion = getArmCommonTypeVersion();
  let principalIdFound = false;
  let tenantIdFound = false;
  let typeFound = false;
  let userAssignedIdentitiesFound = false;

  for (const property of schema.properties) {
    if (property.serializedName === "principalId" && !property.required && isUuidSchema(property.schema)) {
      principalIdFound = true;
    } else if (property.serializedName === "tenantId" && !property.required && isUuidSchema(property.schema)) {
      tenantIdFound = true;
    } else if (
      property.serializedName === "type" &&
      property.required &&
      isManagedSerivceIdentityType(property.schema)
    ) {
      typeFound = true;
    }
    // For all the common type versions only check if it is dictionary with specific value type because of https://github.com/Azure/typespec-azure/issues/1163
    else if (
      property.serializedName === "userAssignedIdentities" &&
      !property.required &&
      isDictionarySchema(property.schema) &&
      isUserAssignedIdentity(property.schema.elementType)
    ) {
      return (userAssignedIdentitiesFound = true);
    }
  }

  return principalIdFound && tenantIdFound && typeFound && userAssignedIdentitiesFound;
}

function isManagedSerivceIdentityType(schema: Schema): boolean {
  if (!isChoiceSchema(schema) || schema.choices.length !== 4) return false;

  const commonTypeVersion = getArmCommonTypeVersion();
  let noneFound = false;
  let systemAssignedFound = false;
  let userAssignedFound = false;
  let systemAssignedUserAssignedFound = false;

  for (const choice of schema.choices) {
    if (choice.value === "None") {
      noneFound = true;
    } else if (choice.value === "SystemAssigned") {
      systemAssignedFound = true;
    } else if (choice.value === "UserAssigned") {
      userAssignedFound = true;
    } else if (
      (choice.value === "SystemAssigned,UserAssigned" && ["v6", "v5", "v3"].includes(commonTypeVersion)) ||
      (choice.value === "SystemAssigned, UserAssigned" && commonTypeVersion === "v4")
    ) {
      systemAssignedUserAssignedFound = true;
    }
  }

  return noneFound && systemAssignedFound && userAssignedFound && systemAssignedUserAssignedFound;
}

function isUserAssignedIdentity(schema: Schema): boolean {
  if (!isObjectSchema(schema) || schema.properties?.length !== 2) return false;

  let principalIdFound = false;
  let clientIdFound = false;

  for (const property of schema.properties) {
    if (property.serializedName === "principalId" && !property.required && isUuidSchema(property.schema)) {
      principalIdFound = true;
    } else if (property.serializedName === "clientId" && !property.required && isUuidSchema(property.schema)) {
      clientIdFound = true;
    }
  }

  return principalIdFound && clientIdFound;
}
