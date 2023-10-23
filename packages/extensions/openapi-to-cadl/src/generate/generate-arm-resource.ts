import { TspArmResource } from "interfaces";
import { plural } from "pluralize";
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

  definitions.push(`model ${resource.name} is ${resource.resourceKind}<${resource.propertiesModelName}> {`);

  definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

  if (resource.msiType) {
    definitions.push(`\n...${resource.msiType}\n`);
  }

  definitions.push("}\n");

  definitions.push("\n");

  definitions.push(generateArmResourceOperation(resource));

  return definitions.join("\n");
}

function generateArmResourceOperation(resource: TspArmResource): string {
  const definitions: string[] = [];
  definitions.push("@armResourceOperations");
  definitions.push(`interface ${plural(resource.name)} {`);
  for (const operation of resource.resourceOperations) {
    for (const fixme of operation.fixMe ?? []) {
      definitions.push(fixme);
    }
    definitions.push(generateDocs(operation));
    definitions.push(`${operation.name} is ${operation.kind}<${operation.templateParameters.join()}>`);
  }
  for (const operation of resource.normalOperations) {
    definitions.push(generateOperation(operation));
  }
  definitions.push("}");

  return definitions.join("\n");
}
