import { getSession } from "../autorest-session";
import { generateEnums } from "../generate/generate-enums";
import { generateObject } from "../generate/generate-object";
import { TypespecEnum, TypespecProgram } from "../interfaces";
import { getOptions } from "../options";
import { formatTypespecFile } from "../utils/format";
import { getModelsImports } from "../utils/imports";
import { getNamespaceStatement } from "../utils/namespace";

export async function emitModels(filePath: string, program: TypespecProgram): Promise<void> {
  const content = generateModels(program);

  const session = getSession();
  session.writeFile({ filename: filePath, content: await formatTypespecFile(content, filePath) });
}

function generateModels(program: TypespecProgram) {
  const { models } = program;
  const { modules, namespaces: namespacesSet } = getModelsImports(program);
  const imports = [...new Set<string>([`import "@typespec/rest";`, `import "@typespec/http";`, ...modules])].join("\n");

  const namespaces = [...new Set<string>([`using TypeSpec.Rest;`, `using TypeSpec.Http;`, ...namespacesSet])].join(
    "\n",
  );

  const defContent = containsDfe(program)
    ? `
  union Dfe<T> {
    T,
    DataFactoryElement,
  }

  model DataFactoryElement {
    kind: "Expression";
    value: string;
  }
  `
    : "";

  const enums = flattenEnums(models.enums).join("");
  const objects = models.objects.map(generateObject).join("\n\n");
  return [
    imports,
    "\n",
    namespaces,
    "\n",
    getNamespaceStatement(program),
    `\n${defContent}`,
    enums,
    "\n",
    objects,
  ].join("\n");
}

function flattenEnums(enums: TypespecEnum[]) {
  return enums.reduce<string[]>((a, c) => {
    return [...a, ...generateEnums(c)];
  }, []);
}

function containsDfe(program: TypespecProgram): boolean {
  for (const model of program.models.objects) {
    for (const property of model.properties ?? []) {
      if (property.type.includes("Dfe<")) {
        return true;
      }
    }
  }
  return false;
}
