import pluralize from "pluralize";
import { TspArmResource, TypespecObject, TypespecEnum, TypespecOperation } from "../interfaces";
import { generateAugmentedDecorators } from "../utils/decorators";

export function generateObjectClientDecorator(typespecObject: TypespecObject) {
  const definitions: string[] = [];

  definitions.push(generateAugmentedDecorators(typespecObject.name, typespecObject.clientDecorators));

  for (const property of typespecObject.properties ?? []) {
    const decorators = generateAugmentedDecorators(
      `${typespecObject.name}.\`${property.name}\``, // TO-DO: this a workaround to add `\``, we need a better way
      property.clientDecorators,
    );
    decorators && definitions.push(decorators);
  }

  return definitions.join("\n");
}

export function generateEnumClientDecorator(typespecEnum: TypespecEnum) {
  const definitions: string[] = [];

  definitions.push(generateAugmentedDecorators(typespecEnum.name, typespecEnum.clientDecorators));

  for (const choice of typespecEnum.members) {
    const decorators = generateAugmentedDecorators(`${typespecEnum.name}.${choice.name}`, choice.clientDecorators);
    decorators && definitions.push(decorators);
  }

  return definitions.join("\n");
}

export function generateOperationClientDecorator(operation: TypespecOperation) {
  const definitions: string[] = [];

  definitions.push(generateAugmentedDecorators(operation.name, operation.clientDecorators));

  return definitions.join("\n");
}

export function generateArmResourceClientDecorator(resource: TspArmResource): string {
  const definitions: string[] = [];

  const formalOperationGroupName = pluralize(resource.name);
  const targetName = formalOperationGroupName;

  if (resource.clientDecorators && resource.clientDecorators.length > 0)
    definitions.push(generateAugmentedDecorators(resource.name, resource.clientDecorators));

  for (const op of resource.resourceOperationGroups.flatMap((g) => g.resourceOperations)) {
    if (op.clientDecorators && op.clientDecorators.length > 0)
      definitions.push(generateAugmentedDecorators(`${targetName}.${op.name}`, op.clientDecorators));
  }

  for (const property of resource.properties) {
    if (property.kind !== "property") continue;
    const decorators = generateAugmentedDecorators(`${targetName}.${property.name}`, property.clientDecorators);
    decorators && definitions.push(decorators);
  }

  const propertyDecorators = generateAugmentedDecorators(
    `${resource.name}.properties`,
    resource.propertiesPropertyClientDecorator,
  );
  propertyDecorators && definitions.push(propertyDecorators);

  return definitions.join("\n");
}
