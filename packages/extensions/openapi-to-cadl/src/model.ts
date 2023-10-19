import { CodeModel, isObjectSchema, Schema } from "@autorest/codemodel";
import { getDataTypes } from "./data-types";
import { CadlDataType, CadlProgram } from "./interfaces";
import { getOptions } from "./options";
import { transformTspArmResource } from "./transforms/transform-arm-resources";
import { transformEnum } from "./transforms/transform-choices";
import { getCadlType, transformObject } from "./transforms/transform-object";
import { transformOperationGroup } from "./transforms/transform-operations";
import { transformServiceInformation } from "./transforms/transform-service-information";
import {
  ArmResourceSchema,
  filterResourceRelatedObjects,
  isResourceSchema,
  isResourceUpdateSchema,
} from "./utils/resource-discovery";
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

  const { isArm } = getOptions();

  const armResources =
    codeModel.schemas.objects
      ?.filter((o) => isResourceSchema(o))
      .map((o) => transformTspArmResource(codeModel, o as ArmResourceSchema)) ?? [];

  const cadlObjects = (
    (isArm ? filterResourceRelatedObjects(codeModel.schemas.objects, armResources) : codeModel.schemas.objects) ?? []
  ).map((o) => transformObject(o, codeModel));

  const serviceInformation = transformServiceInformation(codeModel);

  const cadlOperationGroups = [];

  for (const og of codeModel.operationGroups) {
    const cadlOperationGroup = transformOperationGroup(og, codeModel);
    if (cadlOperationGroup.operations.length > 0) {
      cadlOperationGroups.push(cadlOperationGroup);
    }
  }

  return {
    serviceInformation,
    models: {
      enums: caldEnums,
      objects: cadlObjects,
      armResources,
    },
    operationGroups: cadlOperationGroups,
  };
}
