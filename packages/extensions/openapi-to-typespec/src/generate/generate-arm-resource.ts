import { Case } from "change-case-all";
import { TypespecOperation, TspArmResource } from "interfaces";
import _ from "lodash";
import pluralize from "pluralize";
import { replaceGeneratedResourceObject } from "../transforms/transform-arm-resources";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getModelPropertiesDeclarations } from "../utils/model-generation";
import { generateOperation } from "./generate-operations";

export function generateArmResource(resource: TspArmResource): string {
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

  definitions.push(`model ${resource.name} is ${resource.resourceKind}<${resource.propertiesModelName}> {`);

  definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

  for (const p of resource.optionalStandardProperties) {
    definitions.push(`\n...${p}`);
  }

  definitions.push("}\n");

  definitions.push("\n");

  definitions.push(generateArmResourceOperation(resource));

  return definitions.join("\n");
}

function generateArmResourceOperation(resource: TspArmResource): string {
  const formalOperationGroupName = pluralize(resource.name);
  const definitions: string[] = [];

  definitions.push("@armResourceOperations");
  if (resource.name === formalOperationGroupName) {
    definitions.push(`@projectedName("client", "${formalOperationGroupName}")`);
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
      operation.operationId &&
      operation.operationId !== getGeneratedOperationId(formalOperationGroupName, operation.name)
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"`);
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
    if (!example.operationId) {
      example.operationId = operationId;
      example.title = title;
    }
    let filename = operationId;
    if (count > 1) {
      filename = `${filename}_${Case.pascal(title)}`;
    }
    generatedExamples[filename] = JSON.stringify(example, null, 2);
  }
}

function getGeneratedOperationId(operationGroupName: string, operationName: string): string {
  return `${Case.pascal(operationGroupName)}_${Case.pascal(operationName)}`;
}
