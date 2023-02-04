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
  const imports = [`import "@cadl-lang/rest";`, `import "./routes.cadl";`, ``, `using Cadl.Rest;`, `using Cadl.Http;`];
  const content = generateServiceInformation(program);

  return [...imports, content].join("\n");
}
