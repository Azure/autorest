import { CodeModel, isObjectSchema, Schema } from "@autorest/codemodel";
import { getDataTypes } from "./dataTypes";
import { CadlDataType, CadlProgram } from "./interfaces";
import { transformEnum } from "./transforms/transformChoices";
import { getCadlType, transformObject } from "./transforms/transformObject";
import { transformOperationGroup } from "./transforms/transformOperations";
import { transformServiceInformation } from "./transforms/transformServiceInformation";
import { isChoiceSchema } from "./utils/schemas";

let models: Map<CodeModel, CadlProgram> = new Map();

export function getModel(codeModel: CodeModel): CadlProgram {
  let model = models.get(codeModel);

  if (!model) {
    getDataTypes(codeModel);
    model = transformModel(codeModel);
    models.set(codeModel, model);
  }

  return model;
}

export function transformDataType(
  schema: Schema,
  codeModel: CodeModel
): CadlDataType {
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
  const caldEnums = [
    ...(codeModel.schemas.choices ?? []),
    ...(codeModel.schemas.sealedChoices ?? []),
  ].map((c) => transformEnum(c, codeModel));

  const cadlObjects =
    codeModel.schemas.objects?.map((o) => transformObject(o, codeModel)) ?? [];

  const serviceInformation = transformServiceInformation(codeModel);

  const cadlOperationGroups = codeModel.operationGroups.map((g) =>
    transformOperationGroup(g, codeModel)
  );

  return {
    serviceInformation,
    models: {
      enums: caldEnums,
      objects: cadlObjects,
    },
    operationGroups: cadlOperationGroups,
  };
}
