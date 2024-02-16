import { CodeModel, isObjectSchema, Operation } from "@autorest/codemodel";
import { isResponseSchema } from "./schemas";

export function markLRO(codeModel: CodeModel) {
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      operation.extensions ?? {};
      if (!hasLROExtension(operation)) {
        continue;
      }

      for (const response of operation.responses ?? []) {
        if (!isResponseSchema(response)) {
          continue;
        }

        if (!isObjectSchema(response.schema)) {
          continue;
        }

        response.schema.language.default.lro = {
          ...response.schema.language.default.lro,
          isLRO: true,
        };

        // TODO: mark the response as an LRO
      }
    }
  }
}

export function hasLROExtension(operation: Operation) {
  return (
    operation.extensions?.["x-ms-long-running-operation"] ||
    operation.extensions?.["x-ms-long-running-operation-options"]
  );
}
