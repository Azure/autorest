import { TypespecEnum } from "../interfaces";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";

export function generateEnums(typespecEnum: TypespecEnum) {
  const definitions: string[] = [];
  const doc = generateDocs(typespecEnum);
  definitions.push(doc);

  for (const fixme of typespecEnum.fixMe ?? []) {
    definitions.push(`\n${fixme}`);
  }

  const decorators = generateDecorators(typespecEnum.decorators);
  decorators && definitions.push(decorators);

  const enumDefinition = typespecEnum.isExtensible && !["ApiVersion"].includes(typespecEnum.name)? `
    union ${typespecEnum.name} {
        ${typespecEnum.choiceType},\n
        ${typespecEnum.members
          .map((m) => {
            const kv = `"${m.name}"` !== m.value ? `"${m.name}": ${m.value}` : m.value;
            return `${generateDocs(m)}${kv}`;
          })
          .join(", ")}
    }\n\n` : `
    enum ${typespecEnum.name} {
        ${typespecEnum.members
          .map((m) => {
            const kv = `"${m.name}"` !== m.value ? `"${m.name}": ${m.value}` : m.value;
            return `${generateDocs(m)}${kv}`;
          })
          .join(", ")}
    }\n\n`;

  definitions.push(enumDefinition);

  return definitions;
}
