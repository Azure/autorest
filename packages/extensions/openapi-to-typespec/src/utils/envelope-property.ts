import { Property, Schema } from "@autorest/codemodel";
import { TypespecDecorator, TypespecSpreadStatement } from "../interfaces";
import { isExtendedLocation, isManagedSerivceIdentity, isPlan, isSku } from "./common-type-mapping";
import { ArmResourceSchema } from "./resource-discovery";
import { isArraySchema, isStringSchema } from "./schemas";

interface Envelope {
  serializedName: string;
  required: boolean;
  isReadOnly: boolean;
  check: (schema: Schema) => boolean;

  envelopeName: string;
}

const knownEnvelopes: Record<string, Envelope> = {
  sku: {
    serializedName: "sku",
    required: false,
    isReadOnly: false,
    check: isSku,
    envelopeName: "Azure.ResourceManager.ResourceSkuProperty",
  },
  plan: {
    serializedName: "plan",
    required: false,
    isReadOnly: false,
    check: isPlan,
    envelopeName: "Azure.ResourceManager.ResourcePlanProperty",
  },
  extendedLocation: {
    serializedName: "extendedLocation",
    required: false,
    isReadOnly: true,
    check: isExtendedLocation,
    envelopeName: "Azure.ResourceManager.ExtendedLocationProperty",
  },
  zones: {
    serializedName: "zones",
    required: false,
    isReadOnly: false,
    check: (schema) => isArraySchema(schema) && isStringSchema(schema.elementType),
    envelopeName: "Azure.ResourceManager.AvailabilityZonesProperty",
  },
  identity: {
    serializedName: "identity",
    required: false,
    isReadOnly: false,
    check: isManagedSerivceIdentity,
    envelopeName: "Azure.ResourceManager.ManagedServiceIdentityProperty",
  },
  eTag: {
    serializedName: "eTag",
    required: false,
    isReadOnly: true,
    check: isStringSchema,
    envelopeName: "Azure.ResourceManager.EntityTagProperty",
  },
};

export function getEnvelopeProperty(property: Property): TypespecSpreadStatement | undefined {
  for (const key of Object.keys(knownEnvelopes)) {
    const envelope = knownEnvelopes[key];
    if (
      property.serializedName.toLowerCase() === envelope.serializedName.toLowerCase() &&
      (property.required ?? false) === envelope.required &&
      (property.readOnly ?? false) === envelope.isReadOnly &&
      envelope.check(property.schema)
    ) {
      return {
        kind: "spread",
        model: {
          kind: "template",
          name: envelope.envelopeName,
        },
      };
    }
  }
}

export function getEnvelopeAugmentedDecorator(
  schema: ArmResourceSchema,
  property: Property,
): TypespecDecorator | undefined {
  for (const key of Object.keys(knownEnvelopes)) {
    const envelope = knownEnvelopes[key];
    if (
      property.serializedName.toLowerCase() === envelope.serializedName.toLowerCase() &&
      property.serializedName !== envelope.serializedName
    ) {
      return {
        name: "encodedName",
        target: `${schema.resourceMetadata[0].SwaggerModelName}.${envelope.serializedName}`,
        arguments: ["application/json", property.serializedName], // Currently we only support application/json
      };
    }
  }
}
