import { TspArmResource } from "interfaces";
import { plural } from "pluralize";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getModelPropertiesDeclarations } from "../utils/model-generation";

export function generateArmResource(resource: TspArmResource): string {
  let definitions: string[] = [];

  const doc = generateDocs(resource);
  definitions.push(doc);

  const decorators = generateDecorators(resource.decorators);
  decorators && definitions.push(decorators);

  definitions.push(`model ${resource.name} is ${resource.resourceKind}<${resource.propertiesModelName}> {`);

  definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

  definitions.push("}\n");

  definitions.push("\n");

  definitions.push(generateArmResourceOperation(resource));

  return definitions.join("\n");
}

function generateArmResourceOperation(resource: TspArmResource): string {
  const definitions: string[] = [];
  definitions.push("@armResourceOperations");
  definitions.push(`interface ${plural(resource.name)} {`);
  for (const operation of resource.operations) {
    definitions.push(generateDocs(operation));
    definitions.push(`${operation.name} is ${operation.kind}<${operation.templateParameters.join()}>`);
  }
  definitions.push("}");

  return definitions.join("\n");
}
