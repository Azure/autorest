import { Case } from "change-case-all";
import _ from "lodash";
import pluralize from "pluralize";
import {
  TypespecOperation,
  TspArmResource,
  TypespecTemplateModel,
  TypespecVoidType,
  TspLroHeaders,
  TypespecParameter,
  TypespecDataType,
  TspArmResourceOperationGroup,
  TspArmOperationType,
} from "../interfaces";
import { getOptions } from "../options";
import { getTSPOperationGroupName } from "../transforms/transform-arm-resources";
import { generateAugmentedDecorators, generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getLogger } from "../utils/logger";
import { generateLroHeaders } from "../utils/lro";
import { getModelPropertiesDeclarations } from "../utils/model-generation";
import { generateSuppressions } from "../utils/suppressions";
import { generateOperation, generateParameters } from "./generate-operations";
import { generateParameter } from "./generate-parameter";

const logger = () => getLogger("generate-arm-resource");

export function generateArmResource(resource: TspArmResource): string {
  const definitions: string[] = [];

  definitions.push(generateArmResourceModel(resource));

  definitions.push("\n");

  definitions.push(generateArmResourceOperationGroups(resource));

  definitions.push("\n");

  for (const a of resource.augmentDecorators ?? []) {
    definitions.push(generateAugmentedDecorators(a.target!, [a]));
  }

  for (const o of resource.resourceOperationGroups.flatMap((g) => g.resourceOperations)) {
    for (const d of o.augmentedDecorators ?? []) {
      definitions.push(`${d}`);
    }
  }

  return definitions.join("\n");
}

function generateArmResourceModel(resource: TspArmResource): string {
  let definitions: string[] = [];

  for (const fixme of resource.fixMe ?? []) {
    definitions.push(fixme);
  }

  const doc = generateDocs(resource);
  definitions.push(doc);

  const decorators = generateDecorators(resource.decorators);
  decorators && definitions.push(decorators);

  if (resource.resourceParent) {
    definitions.push(`@parentResource(${resource.resourceParent.name})`);
  }

  if (resource.locationParent) {
    definitions.push(`@parentResource(${resource.locationParent})`);
  }

  definitions.push(
    `model ${resource.name} is Azure.ResourceManager.${resource.resourceKind}<${resource.propertiesModelName}${
      resource.propertiesPropertyRequired ? ", false" : ""
    }> {`,
  );

  if (resource.keyExpression) {
    definitions.push(`${resource.keyExpression};`);
  }
  definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

  for (const p of resource.optionalStandardProperties) {
    definitions.push(`\n...${p}`);
  }

  definitions.push("}\n");
  return definitions.join("\n");
}

function generateArmResourceOperationGroups(resource: TspArmResource): string {
  const definitions: string[] = [];

  for (const operationGroup of resource.resourceOperationGroups) {
    definitions.push(generateArmResourceOperationGroup(operationGroup));
  }

  return definitions.join("\n");
}

function generateArmResourceOperationGroup(operationGroup: TspArmResourceOperationGroup): string {
  const { isFullCompatible } = getOptions();

  const definitions: string[] = [];

  if (operationGroup.isLegacy) {
    definitions.push("@armResourceOperations");
    definitions.push(
      `interface ${
        operationGroup.legacyOperationGroup!.interfaceName
      } extends Azure.ResourceManager.Legacy.LegacyOperations<{${operationGroup.legacyOperationGroup!.parentParameters.join(
        ";",
      )}}, ${operationGroup.legacyOperationGroup!.resourceTypeParameter}> {}`,
    );
    definitions.push("\n");
  }

  definitions.push("@armResourceOperations");
  definitions.push(`interface ${operationGroup.interfaceName} {`);

  for (const operation of operationGroup.resourceOperations) {
    for (const fixme of operation.fixMe ?? []) {
      definitions.push(fixme);
    }
    definitions.push(generateDocs(operation));
    const decorators = generateDecorators(operation.decorators);
    decorators && definitions.push(decorators);
    if (
      isFullCompatible &&
      operation.operationId &&
      operation.operationId !== getGeneratedOperationId(operationGroup.interfaceName, operation.name)
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"`);
    }
    if (isFullCompatible && operation.suppressions) {
      definitions.push(...generateSuppressions(operation.suppressions));
    }

    const operationKind = operationGroup.isLegacy
      ? `${operationGroup.legacyOperationGroup!.interfaceName}.${getLegacyOperationKind(operation.kind)}`
      : operation.kind;
    if (operation.kind === "ArmResourceActionSync" || operation.kind === "ArmResourceActionAsync") {
      definitions.push(
        `${operation.name} is ${operationKind}<${operation.resource}, ${generateArmRequest(
          operation.request,
        )}, ${generateArmResponse(operation.response)}${
          operation.baseParameters && !operationGroup.isLegacy
            ? `, BaseParameters = ${operation.baseParameters[0]}`
            : ""
        }${operation.parameters ? `, Parameters = { ${generateParameters(operation.parameters)} }` : ""}${
          operation.lroHeaders ? `, LroHeaders = ${generateLroHeaders(operation.lroHeaders)}` : ""
        }>;`,
      );
    } else if (operation.kind === "ArmResourceActionAsyncBase") {
      definitions.push(
        `${operation.name} is ${operationKind}<${operation.resource}, ${generateArmRequest(
          operation.request,
        )}, ${generateArmResponse(operation.response)}, BaseParameters = ${operation.baseParameters![0]}${
          operation.parameters ? `, Parameters = { ${generateParameters(operation.parameters)} }` : ""
        }>;`,
      );
    } else {
      definitions.push(
        `${operation.name} is ${operationKind}<${operation.resource}${
          operation.patchModel ? `, PatchModel = ${operation.patchModel}` : ""
        }${
          operation.baseParameters && !operationGroup.isLegacy
            ? `, BaseParameters = ${operation.baseParameters[0]}`
            : ""
        }${operation.parameters ? `, Parameters = { ${generateParameters(operation.parameters)} }` : ""}${
          operation.response ? `, Response = ${generateArmResponse(operation.response)}` : ""
        }${operation.lroHeaders ? `, LroHeaders = ${generateLroHeaders(operation.lroHeaders)}` : ""}>;`,
      );
    }
    definitions.push("\n");
  }

  definitions.push("}");
  return definitions.join("\n");
}

function getLegacyOperationKind(kind: TspArmOperationType): string {
  switch (kind) {
    case "ArmResourceRead":
      return "Read";
    case "ArmResourceCheckExistence":
      return "CheckExistence";
    case "ArmResourceCreateOrReplaceSync":
      return "CreateOrUpdateSync";
    case "ArmResourceCreateOrReplaceAsync":
      return "CreateOrUpdateAsync";
    case "ArmResourcePatchSync":
      return "PatchSync";
    case "ArmResourcePatchAsync":
      return "PatchAsync";
    case "ArmCustomPatchSync":
      return "CustomPatchSync";
    case "ArmCustomPatchAsync":
      return "CustomPatchAsync";
    case "ArmResourceDeleteSync":
      return "DeleteSync";
    case "ArmResourceDeleteWithoutOkAsync":
      return "DeleteWithoutOkAsync";
    case "ArmResourceActionSync":
      return "ActionSync";
    case "ArmResourceActionAsync":
      return "ActionAsync";
    case "ArmResourceActionAsyncBase":
      return "ActionAsyncBase";
    case "ArmResourceListByParent":
      return "List";
    case "ArmListBySubscription":
      return "ListBySubscription";
    case "ArmResourceListAtScope":
      return "ListAtScope";
  }
}

function generateArmRequest(request: TypespecParameter | TypespecVoidType | TypespecDataType): string {
  if (request.kind === "void") {
    return "void";
  }

  if (request.kind === "parameter") {
    return `{${generateParameter(request as TypespecParameter)}}`;
  }

  return request.name;
}

function generateArmResponse(responses: TypespecTemplateModel[] | TypespecVoidType): string {
  if (!Array.isArray(responses)) {
    return "void";
  }

  return responses.map((r) => generateTemplateModel(r)).join(" | ");
}

export function generateTemplateModel(templateModel: TypespecTemplateModel): string {
  return `${templateModel.name}${
    templateModel.arguments
      ? `<${templateModel.arguments
          .map((a) => (a.kind === "template" ? generateTemplateModel(a as TypespecTemplateModel) : a.name))
          .join(",")}>`
      : ""
  }${
    templateModel.additionalProperties
      ? ` & { ${templateModel.additionalProperties.map((p) => generateParameter(p)).join(";")} }`
      : ""
  }${templateModel.additionalTemplateModel ? templateModel.additionalTemplateModel : ""}`;
}

export function generateArmResourceExamples(resource: TspArmResource): Record<string, string> {
  const formalOperationGroupName = pluralize(resource.name);
  const examples: Record<string, string> = {};
  for (const operation of resource.resourceOperationGroups.flatMap((g) => g.resourceOperations)) {
    generateExamples(
      operation.examples ?? {},
      operation.operationId ?? getGeneratedOperationId(formalOperationGroupName, operation.name),
      examples,
    );
  }
  return examples;
}

function generateExamples(
  examples: Record<string, Record<string, unknown>>,
  operationId: string,
  generatedExamples: Record<string, string>,
) {
  const count = _.keys(examples).length;
  for (const [title, example] of _.entries(examples)) {
    example.operationId = operationId;
    example.title = title;

    let filename = undefined;
    const originalFile = example["x-ms-original-file"] as string;
    if (originalFile) {
      const exampleIndex = originalFile.lastIndexOf("/examples/");
      if (exampleIndex !== -1) {
        filename = originalFile.substring(exampleIndex + "/examples/".length);
        delete example["x-ms-original-file"];
        generatedExamples[filename] = JSON.stringify(example, null, 2);
        continue;
      }
    }

    logger().info(
      `Cannot find the example original path or the path isn't in the examples folder for operation ${operationId}`,
    );
    filename = operationId;
    if (count > 1) {
      if (title.startsWith(filename)) {
        filename = title;
      } else {
        const suffix = Case.train(title).replaceAll("-", "_");
        filename = `${filename}_${suffix}`;
      }
    }
    generatedExamples[filename] = JSON.stringify(example, null, 2);
  }
}

function getGeneratedOperationId(operationGroupName: string, operationName: string): string {
  return `${Case.pascal(operationGroupName)}_${Case.pascal(operationName)}`;
}
