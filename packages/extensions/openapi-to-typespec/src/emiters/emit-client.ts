import { getSession } from "../autorest-session";
import { generateObjectClientDecorator } from "../generate/generate-client";
import { TypespecProgram } from "../interfaces";
import { formatTypespecFile } from "../utils/format";
import { getClientImports } from "../utils/imports";
import { getNamespace } from "../utils/namespace";

export async function emitClient(filePath: string, program: TypespecProgram): Promise<void> {
  const content = generateClient(program);

  const session = getSession();
  session.writeFile({ filename: filePath, content: await formatTypespecFile(content, filePath) });
}

function generateClient(program: TypespecProgram) {
  const { models } = program;
  const { modules, namespaces: namespacesSet } = getClientImports(program);
  const imports = [...new Set<string>([`import "./main.tsp";`, ...modules])].join("\n");

  const namespaces = [...new Set<string>([...namespacesSet, `using ${getNamespace(program)};`])].join("\n");
  const objects = models.objects.map(generateObjectClientDecorator).join("\n\n");
  return [imports, "\n", namespaces, "\n", objects].join("\n");
}
