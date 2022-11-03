import { CadlProgram } from "../interfaces";
import { writeFile } from "fs/promises";
import { generateOperationGroup } from "../generate/generateOperations";
import { formatCadlFile } from "../utils/format";
import { getNamespace } from "../utils/namespace";
import { getRoutesImports } from "../utils/imports";

export async function emitRoutes(
  filePath: string,
  program: CadlProgram
): Promise<void> {
  const content = generateRoutes(program);
  await writeFile(filePath, formatCadlFile(content, filePath));
}

function generateRoutes(program: CadlProgram) {
  const { operationGroups } = program;
  const { modules, namespaces } = getRoutesImports(program);
  const content = operationGroups.map(generateOperationGroup);

  return [
    ...modules,
    "\n",
    ...namespaces,
    "\n",
    getNamespace(program),
    "\n",
    ...content,
  ].join("\n");
}
