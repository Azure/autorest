import { getSession } from "../autorest-session";
import { formatFile } from "../utils/format";

export async function emitCadlConfig(filePath: string): Promise<void> {
  const content = `
  emit:
    - "@azure-tools/typespec-autorest":
    # Uncomment this line and add "@azure-tools/typespec-python" to your package.json to generate Python code
    # "@azure-tools/typespec-python":
    #   "basic-setup-py": true
    #   "package-version":
    #   "package-name":
    #   "output-path":
    # Uncomment this line and add "@azure-tools/typespec-java" to your package.json to generate Java code
    # "@azure-tools/typespec-java": true
    # Uncomment this line and add "@azure-tools/typespec-csharp" to your package.json to generate C# code
    # "@azure-tools/typespec-csharp": true
    # Uncomment this line and add "@azure-tools/typespec-ts" to your package.json to generate Typescript code
    # "@azure-tools/typespec-ts": true
`;

  const session = getSession();
  session.writeFile({ filename: filePath, content: formatFile(content, filePath) });
}
