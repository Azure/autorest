import { CadlOperation, CadlOperationGroup, CadlParameter } from "../interfaces";
import { generateDocs, generateSummary } from "../utils/docs";

export function generateOperation(operation: CadlOperation, operationGroup: CadlOperationGroup) {
  const doc = generateDocs(operation);
  const summary = generateSummary(operation);
  const { verb, name, route, responses, parameters } = operation;
  const params = generateParameters(parameters);
  const statements: string[] = [];
  summary && statements.push(summary);
  statements.push(doc);
  generateMultiResponseWarning(responses, statements);

  for (const fixme of operation.fixMe ?? []) {
    statements.push(fixme);
  }

  if (!operation.resource) {
    const names = [name, ...responses, ...parameters.map((p) => p.name)];
    const duplicateNames = findDuplicates(names);
    generateNameCollisionWarning(duplicateNames, statements);
    statements.push(`@route("${route}")`);
    statements.push(
      `@${verb} op ${name} is Azure.Core.Foundations.Operation<{${params ? params : ""}}, ${responses.join(
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
    const parametersString = !resourceParameters ? `` : `, { parameters: {${resourceParameters}}}`;
    statements.push(
      `${operationGroup.name ? "" : "op "}`,
      `${name} is Azure.Core.${resource.kind}<${resource.response.name} ${parametersString}>;\n\n\n`,
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
       //      This needs to be revisited as CADL supports linking specific responses to each request`,
    );
}

function generateParameters(parameters: CadlParameter[]) {
  const params: string[] = [];
  for (const parameter of parameters) {
    const location = parameter.location;
    params.push(generateDocs(parameter));
    params.push(`@${location} "${parameter.name}": ${parameter.type},`);
  }
  return params.join("\n");
}

export function generateOperationGroup(operationGroup: CadlOperationGroup) {
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
