import { getSession } from "../autorest-session";
import { generateServiceInformation } from "../generate/generate-service-information";
import { CadlProgram } from "../interfaces";
import { getOptions } from "../options";
import { formatCadlFile } from "../utils/format";
import { getArmResourcesMetadata } from "../utils/resource-discovery";

export async function emitMain(filePath: string, program: CadlProgram): Promise<void> {
  const { isArm } = getOptions();
  const content = isArm ? getArmServiceInformation(program) : getServiceInformation(program);
  const session = getSession();
  session.writeFile({ filename: filePath, content: formatCadlFile(content, filePath) });
}

function getServiceInformation(program: CadlProgram) {
  const imports = [
    `import "@typespec/rest";`,
    `import "@typespec/http";`,
    `import "./routes.tsp";`,
    ``,
    `using TypeSpec.Rest;`,
    `using TypeSpec.Http;`,
  ];
  const content = generateServiceInformation(program);

  return [...imports, content].join("\n");
}

function getArmServiceInformation(program: CadlProgram) {
  const imports = [
    `import "@typespec/rest";`,
    `import "@typespec/versioning";`,
    `import "@azure-tools/typespec-azure-core";`,
    `import "@azure-tools/typespec-azure-resource-manager";`,
    `import "./models.tsp";`,
    ...getArmResourceImports(),
    ``,
    `using TypeSpec.Rest;`,
    `using TypeSpec.Http;`,
    `using Azure.ResourceManager.Foundations;`,
    `using Azure.Core;`,
    `using Azure.ResourceManager;`,
    `using TypeSpec.Versioning;`,
  ];
  const content = generateServiceInformation(program);

  return [...imports, content].join("\n");
}

function getArmResourceImports(): string[] {
  const resourceMetadata = getArmResourcesMetadata();
  const imports: string[] = [];

  for (const resource in resourceMetadata) {
    imports.push(`import "./${resource}.tsp";`);
  }

  return imports;
}
