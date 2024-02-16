import { getSession } from "../autorest-session";
import { generateOperationGroup } from "../generate/generate-operations";
import { TypespecProgram } from "../interfaces";
import { formatTypespecFile } from "../utils/format";
import { getRoutesImports } from "../utils/imports";
import { getNamespaceStatement } from "../utils/namespace";

export async function emitRoutes(filePath: string, program: TypespecProgram): Promise<void> {
  if (program.operationGroups.length === 0) {
    return;
  }
  const content = generateRoutes(program);
  const session = getSession();
  session.writeFile({ filename: filePath, content: await formatTypespecFile(content, filePath) });
}

function generateRoutes(program: TypespecProgram) {
  const { operationGroups } = program;
  const { modules, namespaces } = getRoutesImports(program);
  const content = operationGroups.map(generateOperationGroup);

  return [...modules, "\n", ...namespaces, "\n", getNamespaceStatement(program), "\n", ...content].join("\n");
}
