import { TypespecOperation, TypespecOperationGroup, TypespecParameter } from "../interfaces";
import { getOptions } from "../options";
import { replaceGeneratedResourceObject } from "../transforms/transform-arm-resources";
import { generateDocs, generateSummary } from "../utils/docs";
import { generateParameter } from "./generate-parameter";

export function generateOperation(operation: TypespecOperation, operationGroup?: TypespecOperationGroup) {
  const { isArm } = getOptions();
  const doc = generateDocs(operation);
  const summary = generateSummary(operation);
  const { verb, name, route, parameters } = operation;
  const responses = operation.responses.map(replaceGeneratedResourceObject);
  const params = generateParameters(parameters);
  const statements: string[] = [];
  summary && statements.push(summary);
  statements.push(doc);
  generateMultiResponseWarning(responses, statements);

  for (const fixme of operation.fixMe ?? []) {
    statements.push(fixme);
  }

  if (isArm) {
    statements.push(`@route("${route}")`);
    statements.push(
      `@${verb} op \`${name}\`(
        ...ApiVersionParameter,
        ${params}
        ): ArmResponse<${responses.join(" | ")}> | ErrorResponse;\n\n\n`,
    );
  } else if (!operation.resource) {
    const names = [name, ...responses, ...parameters.map((p) => p.name)];
    const duplicateNames = findDuplicates(names);
    generateNameCollisionWarning(duplicateNames, statements);
    statements.push(`@route("${route}")`);
    statements.push(
      `@${verb} op \`${name}\` is Azure.Core.Foundations.Operation<${params ? params : "{}"}, ${responses.join(
        " | ",
      )}>;\n\n\n`,
    );
  } else {
    const { resource } = operation;
    const names = [name, ...responses, ...parameters.map((p) => p.name)];
    const duplicateNames = findDuplicates(names);
    generateNameCollisionWarning(duplicateNames, statements);
    const resourceParameters = generateParameters(
      parameters.filter((param) => !["path", "body"].some((p) => p === param.location)),
    );
    const parametersString = resourceParameters ? `, { parameters: ${resourceParameters}}` : "";
    statements.push(
      `${operationGroup?.name ? "" : "op "}`,
      `\`${name}\` is Azure.Core.${resource.kind}<${resource.response.name} ${parametersString}>;\n\n\n`,
    );
  }
  return statements.join("\n");
}

function findDuplicates(arr: string[]) {
  return arr.filter((item, index) => arr.indexOf(item) != index);
}

function generateNameCollisionWarning(duplicateNames: string[], statements: string[]) {
  if (!duplicateNames.length) {
    return;
  }

  const unique = [...new Set(duplicateNames)];
  const message = `// FIXME: (name-collision-error) There is a potential collision with Operation, Parameter and Response names.
          // Problematic names: [${unique.join()}]`;

  statements.push(message);
}

function generateMultiResponseWarning(responses: string[], statements: string[]) {
  responses.length > 2 &&
    statements.push(
      `// FIXME: (multi-response) Swagger defines multiple requests and responses.
       //      This needs to be revisited as Typespec supports linking specific responses to each request`,
    );
}

export function generateParameters(parameters: TypespecParameter[]) {
  const { isArm } = getOptions();
  if (parameters.length === 0) {
    return "";
  }
  if (parameters.length === 1 && parameters[0].location === "body") {
    if (parameters[0].type === "unknown") {
      return "unknown";
    } else {
      return parameters[0].type;
    }
  }
  const params: string[] = [];
  for (const parameter of parameters) {
    params.push(generateParameter(parameter));
  }
  if (isArm) {
    return `${params.join(",\n")}`;
  }
  return `{${params.join("\n")}}`;
}

export function generateOperationGroup(operationGroup: TypespecOperationGroup) {
  const statements: string[] = [];
  const doc = generateDocs(operationGroup);
  const { name, operations } = operationGroup;

  statements.push(`${doc}`);
  const hasInterface = Boolean(name);
  hasInterface && statements.push(`interface ${name} {`);
  for (const operation of operations) {
    statements.push(generateOperation(operation, operationGroup));
  }
  hasInterface && statements.push(`}`);

  return statements.join("\n");
}
