import { CodeModel, isObjectSchema, Schema } from "@autorest/codemodel";
import { getDataTypes } from "./data-types";
import { TypespecDataType, TypespecProgram } from "./interfaces";
import { getOptions } from "./options";
import { transformTspArmResource } from "./transforms/transform-arm-resources";
import { transformEnum } from "./transforms/transform-choices";
import { getTypespecType, transformObject } from "./transforms/transform-object";
import { transformOperationGroup } from "./transforms/transform-operations";
import { transformServiceInformation } from "./transforms/transform-service-information";
import { ArmResourceSchema, filterArmEnums, filterArmModels, isResourceSchema } from "./utils/resource-discovery";
import { isChoiceSchema } from "./utils/schemas";

const models: Map<CodeModel, TypespecProgram> = new Map();

export function getModel(codeModel: CodeModel): TypespecProgram {
  let model = models.get(codeModel);

  if (!model) {
    getDataTypes(codeModel);
    model = transformModel(codeModel);
    models.set(codeModel, model);
  }

  return model;
}

export function transformDataType(schema: Schema, codeModel: CodeModel): TypespecDataType {
  if (isObjectSchema(schema)) {
    return transformObject(schema, codeModel);
  }

  if (isChoiceSchema(schema)) {
    return transformEnum(schema, codeModel);
  }

  return {
    name: getTypespecType(schema, codeModel),
    kind: "wildcard",
    doc: schema.language.default.description,
  };
}

function transformModel(codeModel: CodeModel): TypespecProgram {
  const typespecEnums = [...(codeModel.schemas.choices ?? []), ...(codeModel.schemas.sealedChoices ?? [])]
    .filter((c) => c.language.default.name !== "Versions")
    .map((c) => transformEnum(c, codeModel));

  const { isArm } = getOptions();

  // objects need to be converted first because they are used in operation convertion
  const typespecObjects = (codeModel.schemas.objects ?? []).map((o) => transformObject(o, codeModel));

  const armResources = isArm
    ? codeModel.schemas.objects
        ?.filter((o) => isResourceSchema(o))
        .map((o) => transformTspArmResource(o as ArmResourceSchema)) ?? []
    : [];

  const serviceInformation = transformServiceInformation(codeModel);

  const typespecOperationGroups = [];

  for (const og of codeModel.operationGroups) {
    const typespecOperationGroup = transformOperationGroup(og, codeModel);
    if (typespecOperationGroup.operations.length > 0) {
      typespecOperationGroups.push(typespecOperationGroup);
    }
  }

  return {
    serviceInformation,
    models: {
      enums: isArm ? filterArmEnums(typespecEnums) : typespecEnums,
      objects: isArm ? filterArmModels(codeModel, typespecObjects) : typespecObjects,
      armResources,
    },
    operationGroups: typespecOperationGroups,
  };
}
