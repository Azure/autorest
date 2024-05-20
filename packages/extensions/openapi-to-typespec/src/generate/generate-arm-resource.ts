import { Case } from "change-case-all";
import { TypespecOperation, TspArmResource } from "interfaces";
import _ from "lodash";
import pluralize from "pluralize";
import { getArmCommonTypeVersion } from "../autorest-session";
import { getOptions } from "../options";
import { replaceGeneratedResourceObject } from "../transforms/transform-arm-resources";
import { generateAugmentedDecorators, generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getModelPropertiesDeclarations } from "../utils/model-generation";
import { generateSuppressions } from "../utils/suppressions";
import { generateOperation } from "./generate-operations";

export function generateArmResource(resource: TspArmResource): string {
  const definitions: string[] = [];

  definitions.push(generateArmResourceModel(resource));

  definitions.push("\n");

  definitions.push(generateArmResourceOperation(resource));

  definitions.push("\n");

  for (const a of resource.augmentDecorators ?? []) {
    definitions.push(generateAugmentedDecorators(a.target!, [a]));
  }

  for (const o of resource.resourceOperations) {
    for (const d of o.customizations ?? []) {
      definitions.push(`${d}`);
    }
  }

  return definitions.join("\n");
}

function generateArmResourceModel(resource: TspArmResource): string {
  const { isFullCompatible } = getOptions();

  let definitions: string[] = [];

  for (const fixme of resource.fixMe ?? []) {
    definitions.push(fixme);
  }

  const doc = generateDocs(resource);
  definitions.push(doc);

  const decorators = generateDecorators(resource.decorators);
  decorators && definitions.push(decorators);

  if (resource.resourceParent) {
    definitions.push(`@parentResource(${resource.resourceParent.name})`);
  }

  if (resource.locationParent) {
    definitions.push(`@parentResource(${resource.locationParent})`);
  }

  if (
    !isFullCompatible ||
    (getArmCommonTypeVersion() &&
      !resource.propertiesPropertyRequired &&
      resource.propertiesPropertyVisibility.length === 2 &&
      resource.propertiesPropertyVisibility.includes("read") &&
      resource.propertiesPropertyVisibility.includes("create"))
  ) {
    definitions.push(
      `model ${resource.name} is Azure.ResourceManager.${resource.resourceKind}<${resource.propertiesModelName}> {`,
    );

    if (resource.keyExpression) {
      definitions.push(`${resource.keyExpression}`);
    }
    definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];
  } else {
    definitions.push(
      `#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"`,
    );
    definitions.push(
      `#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"`,
    );
    definitions.push(`@includeInapplicableMetadataInPayload(false)`);

    if (!getArmCommonTypeVersion()) {
      if (resource.baseModelName) {
        definitions.push(`model ${resource.name} extends ${resource.baseModelName} {`);
      } else {
        definitions.push(`model ${resource.name} {`);
      }
    } else {
      definitions.push(`@Azure.ResourceManager.Private.armResourceInternal(${resource.propertiesModelName})`);
      definitions.push(`model ${resource.name} extends Foundations.${resource.resourceKind} {`);
    }

    if (resource.keyExpression) {
      definitions.push(`${resource.keyExpression}`);
    }
    definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

    const propertyDoc = generateDocs({ doc: resource.propertiesPropertyDescription });
    propertyDoc && definitions.push(propertyDoc);

    definitions.push(`@extension("x-ms-client-flatten", true)`);
    if (resource.propertiesPropertyVisibility.length > 0) {
      definitions.push(`@visibility("${resource.propertiesPropertyVisibility.join(",")}")`);
    }

    definitions.push(`properties${resource.propertiesPropertyRequired ? "" : "?"}: ${resource.propertiesModelName}`);
  }

  for (const p of resource.optionalStandardProperties) {
    definitions.push(`\n...${p}`);
  }

  definitions.push("}\n");
  return definitions.join("\n");
}

function generateArmResourceOperation(resource: TspArmResource): string {
  const { isFullCompatible } = getOptions();

  const formalOperationGroupName = pluralize(resource.name);
  const definitions: string[] = [];

  definitions.push("@armResourceOperations");
  if (resource.name === formalOperationGroupName) {
    definitions.push(`interface ${formalOperationGroupName}OperationGroup {`);
  } else {
    definitions.push(`interface ${formalOperationGroupName} {`);
  }

  for (const operation of resource.resourceOperations) {
    for (const fixme of operation.fixMe ?? []) {
      definitions.push(fixme);
    }
    definitions.push(generateDocs(operation));
    const decorators = generateDecorators(operation.decorators);
    decorators && definitions.push(decorators);
    if (
      isFullCompatible &&
      operation.operationId &&
      (operation.operationId !== getGeneratedOperationId(formalOperationGroupName, operation.name) ||
        operation.kind === "ArmResourceListByParent")
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"`);
    }
    if (isFullCompatible && operation.suppressions) {
      definitions.push(...generateSuppressions(operation.suppressions));
    }
    if (operation.kind === "ArmResourceExists") {
      definitions.push(`op ${operation.name}(${operation.parameters.join(",")}): ${operation.responses.join("|")}`);
    } else if (operation.templateParameters?.length) {
      definitions.push(
        `${operation.name} is ${operation.kind}<${(operation.templateParameters ?? [])
          .map(replaceGeneratedResourceObject)
          .join(",")}>`,
      );
    } else {
      definitions.push(`${operation.name} is ${operation.kind}`);
    }
    definitions.push("");
  }
  for (const operation of resource.normalOperations) {
    if (
      isFullCompatible &&
      operation.operationId &&
      operation.operationId !== getGeneratedOperationId(formalOperationGroupName, operation.name)
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"`);
    }
    definitions.push(generateOperation(operation as TypespecOperation));
    definitions.push("");
  }

  definitions.push("}\n");

  return definitions.join("\n");
}

export function generateArmResourceExamples(resource: TspArmResource): Record<string, string> {
  const formalOperationGroupName = pluralize(resource.name);
  const examples: Record<string, string> = {};
  for (const operation of resource.resourceOperations) {
    generateExamples(
      operation.examples ?? {},
      operation.operationId ?? getGeneratedOperationId(formalOperationGroupName, operation.name),
      examples,
    );
  }
  for (const operation of resource.normalOperations) {
    generateExamples(
      operation.examples ?? {},
      operation.operationId ?? getGeneratedOperationId(formalOperationGroupName, operation.name),
      examples,
    );
  }
  return examples;
}

function generateExamples(
  examples: Record<string, Record<string, unknown>>,
  operationId: string,
  generatedExamples: Record<string, string>,
) {
  const count = _.keys(examples).length;
  for (const [title, example] of _.entries(examples)) {
    example.operationId = operationId;
    example.title = title;
    let filename = operationId;
    if (count > 1) {
      if (title.startsWith(filename)) {
        filename = title;
      } else {
        const suffix = Case.train(title).replaceAll("-", "_");
        filename = `${filename}_${suffix}`;
      }
    }
    generatedExamples[filename] = JSON.stringify(example, null, 2);
  }
}

function getGeneratedOperationId(operationGroupName: string, operationName: string): string {
  return `${Case.pascal(operationGroupName)}_${Case.pascal(operationName)}`;
}
