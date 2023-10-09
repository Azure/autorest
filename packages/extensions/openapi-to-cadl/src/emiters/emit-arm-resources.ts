import { join } from "path";
import { getSession } from "../autorest-session";
import { generateArmOperations } from "../generate/generate-arm-operations";
import { generateObject } from "../generate/generate-object";
import { CadlProgram } from "../interfaces";
import { getAllArmResources } from "../transforms/transform-resources";
import { formatCadlFile } from "../utils/format";
import { getResourcesImports } from "../utils/imports";
import { getNamespace } from "../utils/namespace";

export function emitArmResources(program: CadlProgram, basePath: string) {
  // Create a file per resource
  const session = getSession();

  const allArmResources = getAllArmResources(session.model);
  for (const [_schema, armResource] of allArmResources.entries()) {
    const { modules, namespaces } = getResourcesImports(program, armResource);
    const filePath = join(basePath, `${armResource.name}.tsp`);
    const generatedResource = generateObject(armResource);
    const armOperations = generateArmOperations(armResource);
    const content = [
      modules.join("\n"),
      "\n",
      namespaces.join("\n"),
      "\n",
      getNamespace(program),
      generatedResource,
      "\n",
      armOperations.join("\n"),
    ].join("\n");
    session.writeFile({ filename: filePath, content: formatCadlFile(content, filePath) });
  }
}
