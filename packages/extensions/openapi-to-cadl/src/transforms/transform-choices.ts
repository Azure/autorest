import { ChoiceSchema, ChoiceValue, CodeModel, SchemaType, SealedChoiceSchema } from "@autorest/codemodel";
import { getDataTypes } from "../data-types";
import { CadlChoiceValue, CadlEnum } from "../interfaces";
import { getEnumDecorators } from "../utils/decorators";
import { transformValue } from "../utils/values";

export function transformEnum(schema: SealedChoiceSchema | ChoiceSchema, codeModel: CodeModel): CadlEnum {
  const dataTypes = getDataTypes(codeModel);

  let cadlEnum = dataTypes.get(schema) as CadlEnum;

  if (!cadlEnum) {
    cadlEnum = {
      decorators: getEnumDecorators(schema),
      doc: schema.language.default.documentation,
      kind: "enum",
      name: schema.language.default.name.replace(/-/g, "_"),
      members: schema.choices.map((choice) => transformChoiceMember(choice)),
      isExtensible: !isSealedChoiceSchema(schema),
      ...(hasSyntheticName(schema) && {
        fixMe: [
          "// FIXME: (synthetic-name) This enum has a generated name. Please rename it to something more appropriate.",
        ],
      }),
    };
  }
  return cadlEnum;
}

function hasSyntheticName(schema: ChoiceSchema | SealedChoiceSchema) {
  return schema.language.default.name.startsWith("components·");
}

function transformChoiceMember(member: ChoiceValue): CadlChoiceValue {
  return {
    doc: member.language.default.description,
    name: member.language.default.name,
    value: transformValue(member.value),
  };
}

const isSealedChoiceSchema = (schema: any): schema is SealedChoiceSchema => {
  return schema.type === SchemaType.SealedChoice;
};
