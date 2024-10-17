import { Property } from "@autorest/codemodel";
import { WithSuppressDirective } from "../interfaces";
import { isDictionarySchema } from "./schemas";

export function generateSuppressionForDocumentRequired(): string {
  return `#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"`;
}

export function generateSuppressionForNoEnum(): string {
  return `#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"`;
}

export function getPropertySuppressions(propertySchema: Property): WithSuppressDirective[] | undefined {
  return isDictionarySchema(propertySchema.schema) ? getSuppressionsForRecordProperty() : undefined;
}

export function generateSuppressions(suppressions: WithSuppressDirective[]): string[] {
  const definitions: string[] = [];
  for (const suppression of suppressions) {
    definitions.push(`#suppress "${suppression.suppressionCode}" "${suppression.suppressionMessage}"`);
  }
  return definitions;
}

export function getSuppressionsForArmResourceDeleteAsync(): WithSuppressDirective[] {
  return [
    { suppressionCode: "deprecated", suppressionMessage: "For backward compatibility" },
    {
      suppressionCode: "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes",
      suppressionMessage: "For backward compatibility",
    },
    {
      suppressionCode: "@azure-tools/typespec-azure-core/no-response-body",
      suppressionMessage: "For backward compatibility",
    },
  ];
}

export function getSuppressionsForArmResourceCreateOrReplaceAsync(): WithSuppressDirective[] {
  return [
    {
      suppressionCode: "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes",
      suppressionMessage: "For backward compatibility",
    },
    {
      suppressionCode: "@azure-tools/typespec-azure-resource-manager/no-response-body",
      suppressionMessage: "For backward compatibility",
    },
  ];
}

export function getSuppressionsForArmResourceDeleteSync(): WithSuppressDirective[] {
  return [
    {
      suppressionCode: "@azure-tools/typespec-azure-core/no-response-body",
      suppressionMessage: "For backward compatibility",
    },
  ];
}

export function getSuppressionsForRecordProperty(): WithSuppressDirective[] {
  return [
    {
      suppressionCode: "@azure-tools/typespec-azure-resource-manager/arm-no-record",
      suppressionMessage: "For backward compatibility",
    },
  ];
}

export function getSuppressionsForProvisioningState(): WithSuppressDirective[] {
  return [
    {
      suppressionCode: "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state",
      suppressionMessage: "For backward compatibility",
    },
  ];
}
