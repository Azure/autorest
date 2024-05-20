import { TypespecObjectProperty } from "../interfaces";
import { getOptions } from "../options";
import { generateDecorators } from "./decorators";
import { generateDocs } from "./docs";
import { generateSuppressions } from "./suppressions";
import { getFullyQualifiedName } from "./type-mapping";

export function getModelPropertiesDeclarations(properties: TypespecObjectProperty[]): string[] {
  const { isFullCompatible } = getOptions();
  const definitions: string[] = [];
  for (const property of properties) {
    const propertyDoc = generateDocs(property);
    propertyDoc && definitions.push(propertyDoc);
    const decorators = generateDecorators(property.decorators);
    decorators && definitions.push(decorators);
    property.fixMe && property.fixMe.length && definitions.push(property.fixMe.join("\n"));
    let defaultValue = "";
    if (property.defaultValue) {
      defaultValue = ` = ${property.defaultValue}`;
    }
    if (isFullCompatible && property.suppressions) {
      definitions.push(...generateSuppressions(property.suppressions));
    }
    definitions.push(
      `"${property.name}"${getOptionalOperator(property)}: ${getFullyQualifiedName(property.type)}${defaultValue};`,
    );
  }

  return definitions;
}

function getOptionalOperator(property: TypespecObjectProperty) {
  return property.isOptional ? "?" : "";
}
