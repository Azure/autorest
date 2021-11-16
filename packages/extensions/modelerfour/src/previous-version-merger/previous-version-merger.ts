import { CodeModel, Operation, Parameter, ParametersOverload, Schema } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { cloneDeep, isEqual } from "lodash";

export async function mergeCodeModelWithPreviousVersion(
  logger: Session<CodeModel>,
  model: CodeModel,
  previousModel: CodeModel,
): Promise<CodeModel> {
  const currentModel = cloneDeep(model);
  const previousGroups = groupOperations(previousModel);

  for (const group of currentModel.operationGroups) {
    const previousGroup = previousGroups.get(group.$key);
    if (previousGroup === undefined) {
      continue;
    }

    for (const operation of group.operations) {
      const previousOperation = previousGroup.get(operation.language.default.name);
      if (previousOperation === undefined) {
        continue;
      }

      mergeOperationWithPeviousVersion(logger, operation, previousOperation);
    }
  }
  return currentModel;
}

function mergeOperationWithPeviousVersion(
  logger: Session<CodeModel>,
  operation: Operation,
  previousOperation: Operation,
) {
  const currentParams = operation.signatureParameters ?? [];
  const previousParams = previousOperation.signatureParameters ?? [];
  if (!validateParamsAreCompatible(logger, operation.language.default.name, currentParams, previousParams)) {
    return;
  }

  const newOverload: ParametersOverload = {
    version: previousOperation.apiVersions?.[0]?.version ?? "",
    parameters: currentParams.slice(0, previousParams.length),
  };

  operation.signatureParametersOverloads = [
    ...(previousOperation.signatureParametersOverloads
      ? convertPreviousOverloads(currentParams, previousOperation.signatureParametersOverloads)
      : []),
    newOverload,
  ];
}

function convertPreviousOverloads(
  currentParams: Parameter[],
  signatureParametersOverloads: ParametersOverload[],
): ParametersOverload[] {
  return signatureParametersOverloads.map((x) => {
    return {
      ...x,
      parameters: x.parameters.map((p) => {
        const currentParam = currentParams.find((x) => x.language.default.name === p.language.default.name);
        if (currentParam === undefined) {
          throw new Error(
            `Previous codemodel overloads contains unknown parameter '${p.language.default.name}'. It cannot be found in the current list of params.`,
          );
        }

        return currentParam;
      }),
    };
  });
}

function validateParamsAreCompatible(
  logger: Session<CodeModel>,
  operationName: string,
  currentParams: Parameter[],
  previousParams: Parameter[],
): boolean {
  if (previousParams.length > currentParams.length) {
    logger.error(
      `Cannot merge older version with this spec. A parameter was removed. This is a breaking change and it cannot be procesed.`,
      ["ModelerMerger/ParamRemoved"],
    );
    return false;
  }

  let failed = false;
  function fail(message: string, key: string[]) {
    logger.error(message, key);
    failed = true;
  }

  const previousParamsMap = groupParamsByName(previousParams);
  const currentParamsMap = groupParamsByName(currentParams);

  // Verify all the params present in the previous version are the same.
  for (const [name, previousParam] of previousParamsMap.entries()) {
    const currentParam = currentParamsMap.get(name);
    if (currentParam === undefined) {
      fail(
        `Cannot merge older version with this spec. The parameter named '${name}' for operation '${operationName}' is not found in the current spec.`,
        ["ModelerMerger/ParamRemoved"],
      );
    } else if (!areParamTheSame(currentParam, previousParam)) {
      fail(
        `Cannot merge older version with this spec. The parameter named '${name}' for operation '${operationName}' is not compatible with the older spec.`,
        ["ModelerMerger/IncompatibleParam"],
      );
    }

    currentParamsMap.delete(name);
  }

  // Verify the remaining params that were added are optional params
  for (const [name, currentParam] of currentParamsMap.entries()) {
    if (currentParam.required) {
      fail(
        `Cannot merge older version with this spec. The parameter named '${name}' for operation '${operationName}' is not optional, this is a breaking change.`,
        ["ModelerMerger/IncompatibleParam"],
      );
    }
  }

  return !failed;
}

function groupParamsByName(params: Parameter[]): Map<string, Parameter> {
  const map = new Map<string, Parameter>();
  for (const param of params) {
    map.set(param.language.default.name, param);
  }
  return map;
}

/**
 * Check the 2 parameters are the same:
 * - name
 * - schema
 * - location
 */
function areParamTheSame(param1: Parameter, param2: Parameter) {
  return (
    param1.language.default.name === param2.language.default.name &&
    param1.implementation === param2.implementation &&
    isEqual(param1.protocol, param2.protocol) &&
    areSchemasTheSame(param1.schema, param2.schema)
  );
}

function areSchemasTheSame(schema1: Schema, schema2: Schema) {
  return isEqual(schema1, schema2);
}

function groupOperations(codemodel: CodeModel): Map<string, Map<string, Operation>> {
  const previousGroups = new Map<string, Map<string, Operation>>();
  for (const group of codemodel.operationGroups) {
    const operations = new Map();

    for (const operation of group.operations) {
      operations.set(operation.language.default.name, operation);
    }
    previousGroups.set(group.$key, operations);
  }
  return previousGroups;
}
