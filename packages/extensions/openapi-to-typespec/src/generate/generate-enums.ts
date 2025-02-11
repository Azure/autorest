import { TypespecEnum } from "../interfaces";
import { getOptions } from "../options";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import {
  generateSuppressionForNoEnum,
  generateSuppressions,
  getSuppressionWithCode,
  SuppressionCode,
} from "../utils/suppressions";

export function generateEnums(typespecEnum: TypespecEnum) {
  const { isFullCompatible } = getOptions();
  const definitions: string[] = [];
  const doc = generateDocs(typespecEnum);
  definitions.push(
    doc.length > 0 || !isFullCompatible
      ? doc
      : `${generateSuppressions([getSuppressionWithCode(SuppressionCode.DocumentRequired)])}\n`,
  );

  const isExtensible = typespecEnum.isExtensible && !["ApiVersion"].includes(typespecEnum.name);
  if (!isExtensible && isFullCompatible) definitions.push(`${generateSuppressionForNoEnum()}\n`);

  for (const fixme of typespecEnum.fixMe ?? []) {
    definitions.push(`\n${fixme}`);
  }

  const decorators = generateDecorators(typespecEnum.decorators);
  decorators && definitions.push(decorators);

  if (isFullCompatible && typespecEnum.suppressions) {
    definitions.push(...generateSuppressions(typespecEnum.suppressions));
  }
  const enumDefinition =
    typespecEnum.isExtensible && !["ApiVersion"].includes(typespecEnum.name)
      ? `
    union ${typespecEnum.name} {
        ${typespecEnum.choiceType},\n
        ${typespecEnum.members
          .map((m) => {
            const doc = generateDocs(m);
            const kv = `"${m.name}": ${m.value}`;
            if (doc.length > 0 || !isFullCompatible) return `${doc}${kv}`;
            else return `${generateSuppressions([getSuppressionWithCode(SuppressionCode.DocumentRequired)])}\n${kv}`;
          })
          .join(", ")}
    }\n\n`
      : `
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
