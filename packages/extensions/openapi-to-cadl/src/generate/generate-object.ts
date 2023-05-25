import { CadlObject, CadlObjectProperty } from "../interfaces";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";

export function generateObject(cadlObject: CadlObject) {
  const definitions: string[] = [];

  const fixme = getFixme(cadlObject);
  fixme && definitions.push(fixme);

  const doc = generateDocs(cadlObject);
  definitions.push(doc);

  const decorators = generateDecorators(cadlObject.decorators);
  decorators && definitions.push(decorators);

  if (cadlObject.extendedParents?.length) {
    const firstParent = cadlObject.extendedParents[0];
    definitions.push(`model ${cadlObject.name} extends ${firstParent} {`);
  } else if (cadlObject.alias) {
    const { alias, params } = cadlObject.alias;

    definitions.push(`model ${cadlObject.name} is ${alias}${params ? `<${params.join(",")}>` : ""} {`);
  } else {
    definitions.push(`model ${cadlObject.name} {`);
  }

  for (const parent of cadlObject.spreadParents ?? []) {
    definitions.push(`...${parent};`);
  }

  for (const property of cadlObject.properties) {
    const propertyDoc = generateDocs(property);
    propertyDoc && definitions.push(propertyDoc);
    const decorators = generateDecorators(property.decorators);
    decorators && definitions.push(decorators);
    property.fixMe && property.fixMe.length && definitions.push(property.fixMe.join("\n"));
    definitions.push(`"${property.name}"${getOptionalOperator(property)}: ${property.type};`);
  }
  definitions.push("}");

  return definitions.join("\n");
}

function getFixme(cadlObject: CadlObject): string | undefined {
  if (!cadlObject.fixMe) {
    return undefined;
  }

  return cadlObject.fixMe.join("\n");
}

function getOptionalOperator(property: CadlObjectProperty) {
  return property.isOptional ? "?" : "";
}
