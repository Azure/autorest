import { writeFile } from "fs/promises";
import { CadlProgram } from "../interfaces";
import { formatFile } from "../utils/format";

export async function emitPackage(filePath: string, program: CadlProgram): Promise<void> {
  const name = program.serviceInformation.name.toLowerCase().replace(/ /g, "-");
  const description = program.serviceInformation.doc;
  const content = JSON.stringify(getPackage(name, description as string));
  await writeFile(filePath, formatFile(content, filePath));
}

const getPackage = (name: string, description: string) => ({
  name: `@cadl-api-spec/${name}`,
  author: "Microsoft Corporation",
  description,
  license: "MIT",
  dependencies: {
    "@cadl-lang/compiler": "^0.37.0",
    "@cadl-lang/rest": "^0.19.0",
    "@cadl-lang/versioning": "^0.10.0",
    "@cadl-lang/prettier-plugin-cadl": "^0.5.17",
    "@azure-tools/cadl-azure-core": "^0.9.0",
    "@azure-tools/cadl-autorest": "^0.22.0",
    "@azure-tools/cadl-python": "^0.4.10",
    prettier: "^2.7.1",
  },
  private: true,
});
