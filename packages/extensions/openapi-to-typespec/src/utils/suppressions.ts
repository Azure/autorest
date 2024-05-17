import { WithSuppressDirective } from "../interfaces";

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
