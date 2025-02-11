import { WithSuppressDirective } from "../interfaces";

export enum SuppressionCode {
  NoEnum = "@azure-tools/typespec-azure-core/no-enum",
  ArmPutOperationResponseCodes = "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes",
  DocumentRequired = "@azure-tools/typespec-azure-core/documentation-required",
  NoResponseBody = "@azure-tools/typespec-azure-resource-manager/no-response-body",
  LroLocationHeader = "@azure-tools/typespec-azure-resource-manager/lro-location-header",
  ArmDeleteOperationResponseCodes = "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes",
  ArmResourceInvalidEnvelopeProperty = "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property",
  ArmNoRecord = "@azure-tools/typespec-azure-resource-manager/arm-no-record",
  ArmResourceInterfaceRequiresDecorator = "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator",
}

export function generateSuppressionForNoEnum(): string {
  return `#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"`;
}

export function generateSuppressions(suppressions: WithSuppressDirective[]): string[] {
  const definitions: string[] = [];
  for (const suppression of suppressions) {
    definitions.push(`#suppress "${suppression.suppressionCode}" "${suppression.suppressionMessage}"`);
  }
  return definitions;
}

export function getSuppressionWithCode(suppressionCode: SuppressionCode): WithSuppressDirective {
  return {
    suppressionCode,
    suppressionMessage: "For backward compatibility",
  };
}

export function getSuppressionsForModelExtension(): WithSuppressDirective[] {
  return [
    {
      suppressionCode: "@azure-tools/typespec-azure-core/composition-over-inheritance",
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
