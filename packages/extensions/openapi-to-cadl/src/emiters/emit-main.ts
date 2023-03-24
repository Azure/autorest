import { getSession } from "../autorest-session";
import { generateServiceInformation } from "../generate/generate-service-information";
import { CadlProgram } from "../interfaces";
import { formatCadlFile } from "../utils/format";

export async function emitMain(filePath: string, program: CadlProgram): Promise<void> {
  const content = getServiceInformation(program);
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
