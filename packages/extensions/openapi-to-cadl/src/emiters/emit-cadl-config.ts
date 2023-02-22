import { writeFileSync } from "fs";
import { getSession } from "../autorest-session";
import { formatFile } from "../utils/format";

export async function emitCadlConfig(filePath: string): Promise<void> {
  const content = `
  emitters:
    "@azure-tools/cadl-autorest": true
    # Uncomment this line and add "@azure-tools/cadl-python" to your package.json to generate Python code
    # "@azure-tools/cadl-python":
    #   "basic-setup-py": true
    #   "package-version":
    #   "package-name":
    #   "output-path":
    # Uncomment this line and add "@azure-tools/cadl-java" to your package.json to generate Java code
    # "@azure-tools/cadl-java": true
    # Uncomment this line and add "@azure-tools/cadl-csharp" to your package.json to generate C# code
    # "@azure-tools/cadl-csharp": true
    # Uncomment this line and add "@azure-tools/cadl-typescript" to your package.json to generate Typescript code
    # "@azure-tools/cadl-typescript": true
`;

  const session = getSession();
  session.writeFile({ filename: filePath, content: formatFile(content, filePath) });
}
