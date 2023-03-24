import { CadlEnum } from "../interfaces";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";

export function generateEnums(cadlEnum: CadlEnum) {
  const definitions: string[] = [];
  const doc = generateDocs(cadlEnum);
  definitions.push(doc);

  for (const fixme of cadlEnum.fixMe ?? []) {
    definitions.push(`\n${fixme}`);
  }

  const decorators = generateDecorators(cadlEnum.decorators);
  decorators && definitions.push(decorators);

  const enumDefinition = `
    enum ${cadlEnum.name} {
        ${cadlEnum.members
          .map((m) => {
            const kv = `"${m.name}"` !== m.value ? `${m.name}: ${m.value}` : m.value;
            return `${generateDocs(m)}${kv}`;
          })
          .join(", ")}
    }\n`;

  definitions.push(enumDefinition);

  return definitions;
}
