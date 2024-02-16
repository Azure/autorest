import { TypespecObject } from "../interfaces";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getModelPropertiesDeclarations } from "../utils/model-generation";

export function generateObject(typespecObject: TypespecObject) {
  let definitions: string[] = [];

  const fixme = getFixme(typespecObject);
  fixme && definitions.push(fixme);

  const doc = generateDocs(typespecObject);
  definitions.push(doc);

  const decorators = generateDecorators(typespecObject.decorators);
  decorators && definitions.push(decorators);

  if (typespecObject.extendedParents?.length) {
    const firstParent = typespecObject.extendedParents[0];
    definitions.push(`model ${typespecObject.name} extends ${firstParent} {`);
  } else if (typespecObject.spreadParents && typespecObject.spreadParents.length === 1) {
    definitions.push(`model ${typespecObject.name} extends ${typespecObject.spreadParents[0]} {`);
  } else if (typespecObject.alias) {
    const { alias, params } = typespecObject.alias;

    definitions.push(`model ${typespecObject.name} is ${alias}${params ? `<${params.join(",")}>` : ""} {`);
  } else {
    definitions.push(`model ${typespecObject.name} {`);
  }

  if (typespecObject.spreadParents?.length) {
    if (typespecObject.extendedParents?.length || typespecObject.spreadParents.length > 1) {
      for (const parent of typespecObject.spreadParents) {
        definitions.push(`...${parent};`);
      }
    }
  }

  definitions = [...definitions, ...getModelPropertiesDeclarations(typespecObject.properties)];
  definitions.push("}");

  return definitions.join("\n");
}

function getFixme(typespecObject: TypespecObject): string | undefined {
  if (!typespecObject.fixMe) {
    return undefined;
  }

  return typespecObject.fixMe.join("\n");
}
