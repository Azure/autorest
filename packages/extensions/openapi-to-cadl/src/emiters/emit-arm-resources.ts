import { join } from "path";
import { getSession } from "../autorest-session";
import { generateArmResource } from "../generate/generate-arm-resource";
import { CadlProgram, TspArmResource } from "../interfaces";
import { formatCadlFile } from "../utils/format";
import { getNamespace } from "../utils/namespace";

export function emitArmResources(program: CadlProgram, basePath: string) {
  // Create a file per resource
  const session = getSession();
  for (const armResource of program.models.armResources) {
    const { modules, namespaces } = getResourcesImports(program, armResource);
    const filePath = join(basePath, `${armResource.name}.tsp`);
    const generatedResource = generateArmResource(armResource);
    const content = [
      modules.join("\n"),
      "\n",
      namespaces.join("\n"),
      "\n",
      getNamespace(program),
      generatedResource,
    ].join("\n");
    session.writeFile({ filename: filePath, content: formatCadlFile(content, filePath) });
  }
}

export function getResourcesImports(_program: CadlProgram, armResource: TspArmResource) {
  const imports = {
    modules: [
      `import "@azure-tools/typespec-azure-core";`,
      `import "@azure-tools/typespec-azure-resource-manager";`,
      `import "@typespec/rest";`,
      `import "./models.tsp";`,
    ],
    namespaces: [
      `using TypeSpec.Rest;`,
      `using Azure.ResourceManager;`,
      `using Azure.ResourceManager.Foundations;`,
      `using TypeSpec.Http;`,
    ],
  };

  if (armResource.resourceParent?.name) {
    imports.modules.push(`import "./${armResource.resourceParent.name}.tsp";`);
  }

  return imports;
}
