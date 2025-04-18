import { join } from "path";
import { getSession } from "../autorest-session";
import { generateServiceInformation } from "../generate/generate-service-information";
import { TypespecProgram } from "../interfaces";
import { getOptions } from "../options";
import { formatTypespecFile } from "../utils/format";
import { getMainImports } from "../utils/imports";
import { Metadata } from "../utils/resource-discovery";
const packageInfo = require("../../package.json");

export async function emitMain(
  program: TypespecProgram,
  metadata: Metadata | undefined,
  basePath: string,
): Promise<void> {
  const { isArm } = getOptions();
  const content = `${getHeaders()}\n${
    isArm ? getArmServiceInformation(program, metadata!) : getServiceInformation(program)
  }${
    isArm && program.listOperation !== undefined
      ? "\n\ninterface Operations extends Azure.ResourceManager.Operations {}"
      : ""
  }`;
  const filePath = join(basePath, "main.tsp");
  const session = getSession();
  session.writeFile({ filename: filePath, content: await formatTypespecFile(content, filePath) });

  if (program.listOperation?.examples) {
    emitExamples(program.listOperation.examples, program.serviceInformation.versions, basePath);
  }
}

function getHeaders() {
  const { isTest, isFullCompatible, guessResourceKey } = getOptions();
  return [
    `/**`,
    `* PLEASE DO NOT REMOVE - USED FOR CONVERTER METRICS`,
    `* Generated by package: ${packageInfo.name}`,
    `* Parameters used:`,
    `*   isFullCompatible: ${isFullCompatible}`,
    `*   guessResourceKey: ${guessResourceKey}`,
    `* Version: ${isTest ? "Not generated in test" : packageInfo.version}`,
    `* Date: ${isTest ? "Not generated in test" : new Date().toISOString()}`,
    `*/`,
  ].join("\n");
}

function getServiceInformation(program: TypespecProgram) {
  const { modules, namespaces: namespacesSet } = getMainImports(program);
  const imports = [
    ...new Set<string>([`import "@typespec/rest";`, `import "@typespec/http";`, ...modules, `import "./routes.tsp"`]),
  ].join("\n");
  const namespaces = [
    ...new Set<string>([
      `using TypeSpec.Rest;`,
      `using TypeSpec.Http;`,
      `using TypeSpec.Versioning;`,
      ...namespacesSet,
    ]),
  ].join("\n");
  return [imports, "\n", namespaces, "\n", generateServiceInformation(program)].join("\n");
}

function getArmServiceInformation(program: TypespecProgram, metadata: Metadata) {
  const { isFullCompatible } = getOptions();
  const imports = [
    `import "@typespec/rest";`,
    `import "@typespec/versioning";`,
    `import "@azure-tools/typespec-azure-core";`,
    `import "@azure-tools/typespec-azure-resource-manager";`,
    `import "./models.tsp";`,
  ];
  if (isFullCompatible) {
    imports.push(`import "./back-compatible.tsp";`);
  }
  imports.push(
    ...[
      ...getArmResourceImports(program, metadata),
      ``,
      `using TypeSpec.Rest;`,
      `using TypeSpec.Http;`,
      `using Azure.ResourceManager.Foundations;`,
      `using Azure.Core;`,
      `using Azure.ResourceManager;`,
      `using TypeSpec.Versioning;`,
    ],
  );
  const content = generateServiceInformation(program);

  return [...imports, content].join("\n");
}

function getArmResourceImports(program: TypespecProgram, metadata: Metadata): string[] {
  const imports: string[] = [];

  for (const resource in metadata.Resources) {
    const fileName = metadata.Resources[resource][0].SwaggerModelName;
    if (fileName) {
      imports.push(`import "./${fileName}.tsp";`);
    }
  }

  if (program.operationGroups.length > 0) {
    imports.push(`import "./routes.tsp";`);
  }

  if (Object.keys(metadata.Resources).find((key) => metadata.Resources[key].length > 1)) {
    imports.push(`import "./legacy.tsp";`);
  }

  return imports;
}

export function emitExamples(examples: Record<string, string>, versions: string[] | undefined, basePath: string): void {
  const session = getSession();
  for (const [filename, content] of Object.entries(examples)) {
    if (versions) {
      session.writeFile({
        filename: join(basePath, "examples", versions[0], filename), // TODO: how to handle multiple versions?
        content,
      });
    } else {
      session.writeFile({ filename: join(basePath, "examples", "unknown", filename), content });
    }
  }
}
