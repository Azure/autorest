import { generateParameter } from "../generate/generate-parameter";
import { TypespecObjectProperty, TypespecSpreadStatement, TypespecTemplateModel } from "../interfaces";
import { getOptions } from "../options";
import { generateDecorators } from "./decorators";
import { generateDocs } from "./docs";
import { generateSuppressions } from "./suppressions";
import { getFullyQualifiedName } from "./type-mapping";

export function getModelPropertiesDeclarations(properties: TypespecObjectProperty[]): string[] {
  const definitions: string[] = [];
  for (const property of properties) {
    definitions.push(...getModelPropertyDeclarations(property));
  }

  return definitions;
}

export function getModelPropertyDeclarations(property: TypespecObjectProperty): string[] {
  const definitions: string[] = [];
  const propertyDoc = generateDocs(property);
  propertyDoc && definitions.push(propertyDoc);
  const decorators = generateDecorators(property.decorators);
  decorators && definitions.push(decorators);
  property.fixMe && property.fixMe.length && definitions.push(property.fixMe.join("\n"));
  let defaultValue = "";
  if (property.defaultValue) {
    defaultValue = ` = ${property.defaultValue}`;
  }
  if (property.suppressions) {
    definitions.push(...generateSuppressions(property.suppressions));
  }
  definitions.push(
    `"${property.name}"${getOptionalOperator(property)}: ${getFullyQualifiedName(property.type)}${defaultValue};`,
  );
  return definitions;
}

export function getSpreadExpressionDecalaration(property: TypespecSpreadStatement): string {
  return `...${generateTemplateModel(property.model)}`;
}

function getOptionalOperator(property: TypespecObjectProperty) {
  return property.isOptional ? "?" : "";
}

export function generateTemplateModel(templateModel: TypespecTemplateModel): string {
  return `${templateModel.name}${
    templateModel.namedArguments
      ? `<${Object.keys(templateModel.namedArguments)
          .map((k) => `${k} = ${templateModel.namedArguments![k]}`)
          .join(",")}>`
      : ""
  }${
    !templateModel.namedArguments && templateModel.arguments
      ? `<${templateModel.arguments
          .map((a) => (a.kind === "template" ? generateTemplateModel(a as TypespecTemplateModel) : a.name))
          .join(",")}>`
      : ""
  }${
    templateModel.additionalProperties
      ? ` & { ${templateModel.additionalProperties.map((p) => generateParameter(p)).join(";")} }`
      : ""
  }${templateModel.additionalTemplateModel ? templateModel.additionalTemplateModel : ""}`;
}
