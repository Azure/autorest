import { CodeModel, isObjectSchema, Schema } from "@autorest/codemodel";
import { getDataTypes } from "./data-types";
import { CadlDataType, CadlProgram } from "./interfaces";
import { transformEnum } from "./transforms/transform-choices";
import { getCadlType, transformObject } from "./transforms/transform-object";
import { transformOperationGroup } from "./transforms/transform-operations";
import { transformServiceInformation } from "./transforms/transform-service-information";
import { isChoiceSchema } from "./utils/schemas";

const models: Map<CodeModel, CadlProgram> = new Map();

export function getModel(codeModel: CodeModel): CadlProgram {
  let model = models.get(codeModel);

  if (!model) {
    getDataTypes(codeModel);
    model = transformModel(codeModel);
    models.set(codeModel, model);
  }

  return model;
}

export function transformDataType(schema: Schema, codeModel: CodeModel): CadlDataType {
  if (isObjectSchema(schema)) {
    return transformObject(schema, codeModel);
  }

  if (isChoiceSchema(schema)) {
    return transformEnum(schema, codeModel);
  }

  return {
    name: getCadlType(schema, codeModel),
    kind: "wildcard",
    doc: schema.language.default.documentation,
  };
}

function transformModel(codeModel: CodeModel): CadlProgram {
  const caldEnums = [...(codeModel.schemas.choices ?? []), ...(codeModel.schemas.sealedChoices ?? [])].map((c) =>
    transformEnum(c, codeModel),
  );

  const cadlObjects = codeModel.schemas.objects?.map((o) => transformObject(o, codeModel)) ?? [];

  const serviceInformation = transformServiceInformation(codeModel);

  const cadlOperationGroups = codeModel.operationGroups.map((g) => transformOperationGroup(g, codeModel));

  return {
    serviceInformation,
    models: {
      enums: caldEnums,
      objects: cadlObjects,
    },
    operationGroups: cadlOperationGroups,
  };
}
