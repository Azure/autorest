import { CadlEnum } from "../interfaces";
import { generateDocs } from "../utils/docs";

export function generateEnums(cadlEnum: CadlEnum) {
  const definitions: string[] = [];
  const doc = generateDocs(cadlEnum);
  definitions.push(doc);

  for (const fixme of cadlEnum.fixMe ?? []) {
    definitions.push(`\n${fixme}`);
  }

  const enumDefinition = `
    enum ${cadlEnum.name}${cadlEnum.isExtensible ? "KnownValues" : ""} {
        ${cadlEnum.members
          .map((m) => {
            return `"${m.name}"` !== m.value ? `${m.name}: ${m.value}` : m.value;
          })
          .join(", ")}
    }\n`;

  definitions.push(enumDefinition);

  if (cadlEnum.isExtensible) {
    const knownValues = `
    @knownValues(${cadlEnum.name}KnownValues)
    model ${cadlEnum.name} is string {}\n\n`;

    definitions.push(knownValues);
  }

  return definitions;
}
