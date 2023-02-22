import { getSession } from "../autorest-session";
import { CadlProgram } from "../interfaces";
import { formatFile } from "../utils/format";

export async function emitPackage(filePath: string, program: CadlProgram): Promise<void> {
  const name = program.serviceInformation.name.toLowerCase().replace(/ /g, "-");
  const description = program.serviceInformation.doc;
  const content = JSON.stringify(getPackage(name, description as string));
  const session = getSession();
  session.writeFile({ filename: filePath, content: formatFile(content, filePath) });
}

const getPackage = (name: string, description: string) => ({
  name: `@cadl-api-spec/${name}`,
  author: "Microsoft Corporation",
  description,
  license: "MIT",
  dependencies: {
    "@cadl-lang/compiler": "^0.40.0",
    "@cadl-lang/rest": "^0.40.0",
    "@cadl-lang/versioning": "^0.40.0",
    "@cadl-lang/prettier-plugin-cadl": "^0.40.0",
    "@azure-tools/cadl-azure-core": "^0.26.0",
    "@azure-tools/cadl-autorest": "^0.26.0",
    prettier: "^2.7.1",
  },
  private: true,
});
