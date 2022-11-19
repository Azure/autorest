import { writeFile } from "fs/promises";
import { generateEnums } from "../generate/generate-enums";
import { generateObject } from "../generate/generate-object";
import { CadlEnum, CadlProgram } from "../interfaces";
import { formatCadlFile } from "../utils/format";
import { getModelsImports } from "../utils/imports";
import { getNamespace } from "../utils/namespace";

export async function emitModels(filePath: string, program: CadlProgram): Promise<void> {
  const content = generateModels(program);

  await writeFile(filePath, formatCadlFile(content, filePath));
}

function generateModels(program: CadlProgram) {
  const { models } = program;
  const { modules, namespaces: namespacesSet } = getModelsImports(program);
  const imports = [...new Set<string>([`import "@cadl-lang/rest";`, ...modules])].join("\n");

  const namespaces = [...new Set<string>([`using Cadl.Rest;`, ...namespacesSet])].join("\n");

  const enums = flattenEnums(models.enums).join("");
  const objects = models.objects.map(generateObject).join("\n\n");
  return [imports, "\n", namespaces, "\n", getNamespace(program), "\n", enums, "\n", objects].join("\n");
}

function flattenEnums(enums: CadlEnum[]) {
  return enums.reduce<string[]>((a, c) => {
    return [...a, ...generateEnums(c)];
  }, []);
}
