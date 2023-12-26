import { TypespecObjectProperty } from "../interfaces";
import { generateDecorators } from "./decorators";
import { generateDocs } from "./docs";
import { transformDefaultValue } from "./values";

export function getModelPropertiesDeclarations(properties: TypespecObjectProperty[]): string[] {
  const definitions: string[] = [];
  for (const property of properties) {
    const propertyDoc = generateDocs(property);
    propertyDoc && definitions.push(propertyDoc);
    const decorators = generateDecorators(property.decorators);
    decorators && definitions.push(decorators);
    property.fixMe && property.fixMe.length && definitions.push(property.fixMe.join("\n"));
    let defaultValue = "";
    if (property.defaultValue) {
      defaultValue = ` = ${transformDefaultValue(property.type, property.defaultValue)}`;
    }
    definitions.push(`"${property.name}"${getOptionalOperator(property)}: ${property.type}${defaultValue};`);
  }

  return definitions;
}

function getOptionalOperator(property: TypespecObjectProperty) {
  return property.isOptional ? "?" : "";
}
