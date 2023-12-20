import { Dictionary } from "@azure-tools/openapi/v3";
import { CadlOperation, TspArmResource, TspArmResourceOperation } from "interfaces";
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
  const groupedOperations: Dictionary<(TspArmResourceOperation | CadlOperation)[]> = {};
  for (const operation of resource.resourceOperations) {
    if (!groupedOperations[operation.operationGroupName]) {
      groupedOperations[operation.operationGroupName] = [];
    }
    groupedOperations[operation.operationGroupName].push(operation);
  }
  for (const operation of resource.normalOperations) {
    if (!groupedOperations[operation.operationGroupName!]) {
      groupedOperations[operation.operationGroupName!] = [];
    }
    groupedOperations[operation.operationGroupName!].push(operation);
  }
  const definitions: string[] = [];

  for (const [operationGroupName, operations] of Object.entries(groupedOperations)) {
    definitions.push("@armResourceOperations");
    definitions.push(`interface ${operationGroupName} {`);
    for (let operation of operations) {
      if ((operation as TspArmResourceOperation).kind) {
        operation = operation as TspArmResourceOperation;
        for (const fixme of operation.fixMe ?? []) {
          definitions.push(fixme);
        }
        definitions.push(generateDocs(operation));
        const decorators = generateDecorators(operation.decorators);
        decorators && definitions.push(decorators);
        if (operation.kind === "ArmResourceExists") {
          definitions.push(`op ${operation.name}(${operation.parameters.join(",")}): ${operation.responses.join("|")}`);
        } else {
          definitions.push(
            `${operation.name} is ${operation.kind}<${(operation.templateParameters ?? [])
              .map(replaceGeneratedResourceObject)
              .join(",")}>`,
          );
        }
      } else {
        definitions.push(generateOperation(operation as CadlOperation));
      }
    }
    definitions.push("}\n");
  }

  return definitions.join("\n");
}
