import { getSession } from "../autorest-session";
import { generateOperationGroup } from "../generate/generate-operations";
import { CadlProgram } from "../interfaces";
import { formatCadlFile } from "../utils/format";
import { getRoutesImports } from "../utils/imports";
import { getNamespace } from "../utils/namespace";

export async function emitRoutes(filePath: string, program: CadlProgram): Promise<void> {
  const content = generateRoutes(program);
  const session = getSession();
  session.writeFile({ filename: filePath, content: formatCadlFile(content, filePath) });
}

function generateRoutes(program: CadlProgram) {
  const { operationGroups } = program;
  const { modules, namespaces } = getRoutesImports(program);
  const content = operationGroups.map(generateOperationGroup);

  return [...modules, "\n", ...namespaces, "\n", getNamespace(program), "\n", ...content].join("\n");
}
