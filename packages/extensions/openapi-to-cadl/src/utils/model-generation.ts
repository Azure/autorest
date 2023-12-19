import { CadlObjectProperty } from "../interfaces";
import { generateDecorators } from "./decorators";
import { generateDocs } from "./docs";
import { transformValue } from "./values";

export function getModelPropertiesDeclarations(properties: CadlObjectProperty[]): string[] {
  const definitions: string[] = [];
  for (const property of properties) {
    const propertyDoc = generateDocs(property);
    propertyDoc && definitions.push(propertyDoc);
    const decorators = generateDecorators(property.decorators);
    decorators && definitions.push(decorators);
    property.fixMe && property.fixMe.length && definitions.push(property.fixMe.join("\n"));
    let defaultValue = "";
    if (property.defaultValue) {
      defaultValue = ` = ${transformValue(property.defaultValue)}`;
    }
    definitions.push(`"${property.name}"${getOptionalOperator(property)}: ${property.type}${defaultValue};`);
  }

  return definitions;
}

function getOptionalOperator(property: CadlObjectProperty) {
  return property.isOptional ? "?" : "";
}
