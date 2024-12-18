import { Case } from "change-case-all";
import _ from "lodash";
import pluralize from "pluralize";
import {
  TypespecOperation,
  TspArmResource,
  isArmResourceActionOperation,
  TypespecTemplateModel,
  TypespecVoidType,
  TspLroHeaders,
} from "../interfaces";
import { getOptions } from "../options";
import { getTSPOperationGroupName } from "../transforms/transform-arm-resources";
import { generateAugmentedDecorators, generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { getLogger } from "../utils/logger";
import { getModelPropertiesDeclarations } from "../utils/model-generation";
import { generateSuppressions } from "../utils/suppressions";
import { generateOperation, generateParameters } from "./generate-operations";
import { generateParameter } from "./generate-parameter";

const logger = () => getLogger("generate-arm-resource");

export function generateArmResource(resource: TspArmResource): string {
  const definitions: string[] = [];

  definitions.push(generateArmResourceModel(resource));

  definitions.push("\n");

  definitions.push(generateArmResourceOperation(resource));

  definitions.push("\n");

  for (const a of resource.augmentDecorators ?? []) {
    definitions.push(generateAugmentedDecorators(a.target!, [a]));
  }

  for (const o of resource.resourceOperations) {
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
    definitions.push(`${resource.keyExpression}`);
  }
  definitions = [...definitions, ...getModelPropertiesDeclarations(resource.properties)];

  for (const p of resource.optionalStandardProperties) {
    definitions.push(`\n...${p}`);
  }

  definitions.push("}\n");
  return definitions.join("\n");
}

function generateArmResourceOperation(resource: TspArmResource): string {
  const { isFullCompatible } = getOptions();

  const formalOperationGroupName = getTSPOperationGroupName(resource.name);
  const definitions: string[] = [];

  definitions.push("@armResourceOperations");
  definitions.push(`interface ${formalOperationGroupName} {`);

  for (const operation of resource.resourceOperations) {
    for (const fixme of operation.fixMe ?? []) {
      definitions.push(fixme);
    }
    definitions.push(generateDocs(operation));
    const decorators = generateDecorators(operation.decorators);
    decorators && definitions.push(decorators);
    if (
      isFullCompatible &&
      operation.operationId &&
      operation.operationId !== getGeneratedOperationId(formalOperationGroupName, operation.name)
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"`);
    }
    if (isFullCompatible && operation.suppressions) {
      definitions.push(...generateSuppressions(operation.suppressions));
    }

    if (isArmResourceActionOperation(operation)) {
      definitions.push(
        `${operation.name} is ${operation.kind}<${operation.resource}, ${operation.request}, ${generateArmResponse(
          operation.response,
        )}${operation.baseParameters ? `, BaseParameters = ${operation.baseParameters[0]}` : ""}${
          operation.parameters ? `, Parameters = { ${generateParameters(operation.parameters)} }` : ""
        }${operation.lroHeaders ? `, LroHeaders = ${generateLroHeaders(operation.lroHeaders)}` : ""}>`,
      );
    } else {
      definitions.push(
        `${operation.name} is ${operation.kind}<${operation.resource}${
          operation.patchModel ? `, PatchModel = ${operation.patchModel}` : ""
        }${operation.baseParameters ? `, BaseParameters = ${operation.baseParameters[0]}` : ""}${
          operation.parameters ? `, Parameters = { ${generateParameters(operation.parameters)} }` : ""
        }${operation.response ? `, Response = ${generateArmResponse(operation.response)}` : ""}${
          operation.lroHeaders ? `, LroHeaders = ${generateLroHeaders(operation.lroHeaders)}` : ""
        }>`,
      );
    }
    definitions.push("\n");
  }
  for (const operation of resource.normalOperations) {
    if (
      isFullCompatible &&
      operation.operationId &&
      operation.operationId !== getGeneratedOperationId(formalOperationGroupName, operation.name)
    ) {
      definitions.push(`@operationId("${operation.operationId}")`);
      definitions.push(`#suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"`);
    }
    definitions.push(generateOperation(operation as TypespecOperation));
    definitions.push("");
  }

  definitions.push("}\n");

  return definitions.join("\n");
}

function generateLroHeaders(lroHeaders: TspLroHeaders): string {
  if (lroHeaders === "Azure-AsyncOperation") {
    return "ArmAsyncOperationHeader & Azure.Core.Foundations.RetryAfterHeader";
  } else if (lroHeaders === "Location") {
    return "ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader";
  }
  throw new Error(`Unknown LRO header: ${lroHeaders}`);
}

function generateArmResponse(responses: TypespecTemplateModel[] | TypespecVoidType): string {
  if (!Array.isArray(responses)) {
    return "void";
  }

  return responses.map((r) => generateTemplateModel(r)).join(" | ");
}

function generateTemplateModel(templateModel: TypespecTemplateModel): string {
  return `${templateModel.name}${
    templateModel.arguments ? `<${templateModel.arguments.map((a) => a.name).join(",")}>` : ""
  }${
    templateModel.additionalProperties
      ? ` & { ${templateModel.additionalProperties.map((p) => generateParameter(p)).join(";")} }`
      : ""
  }`;
}

export function generateArmResourceExamples(resource: TspArmResource): Record<string, string> {
  const formalOperationGroupName = pluralize(resource.name);
  const examples: Record<string, string> = {};
  for (const operation of resource.resourceOperations) {
    generateExamples(
      operation.examples ?? {},
      operation.operationId ?? getGeneratedOperationId(formalOperationGroupName, operation.name),
      examples,
    );
  }
  for (const operation of resource.normalOperations) {
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
