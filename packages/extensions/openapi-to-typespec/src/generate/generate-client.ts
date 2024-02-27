import pluralize from "pluralize";
import { TspArmResource, TypespecObject } from "../interfaces";
import { generateAugmentedDecorators } from "../utils/decorators";

export function generateObjectClientDecorator(typespecObject: TypespecObject) {
  const definitions: string[] = [];

  for (const property of typespecObject.properties) {
    const decorators = generateAugmentedDecorators(
      `${typespecObject.name}.${property.name}`,
      property.clientDecorators,
    );
    decorators && definitions.push(decorators);
  }

  return definitions.join("\n");
}

export function generateArmResourceClientDecorator(resource: TspArmResource): string {
  const formalOperationGroupName = pluralize(resource.name);

  if (resource.name === formalOperationGroupName) {
    return `@@clientName(${formalOperationGroupName}OperationGroup, "${formalOperationGroupName}")`;
  }
  return "";
}
