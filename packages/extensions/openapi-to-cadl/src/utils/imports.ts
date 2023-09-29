import { CadlProgram, TypespecArmResource } from "../interfaces";
import { ArmResourcesCache } from "../transforms/transform-resources";

type Imports = {
  modules: string[];
  namespaces: string[];
};

export function getResourcesImports(_program: CadlProgram, armResource: TypespecArmResource) {
  const imports: Imports = {
    modules: [
      `import "@azure-tools/typespec-azure-core";`,
      `import "@azure-tools/typespec-azure-resource-manager";`,
      `import "@typespec/rest";`,
      `import "./models.tsp";`,
    ],
    namespaces: [
      `using TypeSpec.Rest;`,
      `using Azure.ResourceManager;`,
      `using Azure.ResourceManager.Foundations;`,
      `using TypeSpec.Http;`,
    ],
  };

  if (armResource.resourceParent?.name) {
    imports.modules.push(`import "./${armResource.resourceParent.name}.tsp";`);
  }

  return imports;
}

export function getModelsImports(program: CadlProgram) {
  const modules = new Set<string>();
  const namespaces = new Set<string>();
  for (const choice of program.models.enums) {
    for (const decorator of choice.decorators ?? []) {
      decorator.module && modules.add(`import "${decorator.module}";`);
      decorator.namespace && namespaces.add(`using ${decorator.namespace};`);
    }
  }
  for (const model of program.models.objects) {
    model.alias?.module && modules.add(`import "${model.alias.module}";`);
    for (const decorator of model.decorators ?? []) {
      decorator.module && modules.add(`import "${decorator.module}";`);
      decorator.namespace && namespaces.add(`using ${decorator.namespace};`);
    }

    for (const property of model.properties) {
      for (const decorator of property.decorators ?? []) {
        decorator.module && modules.add(`import "${decorator.module}";`);
        decorator.namespace && namespaces.add(`using ${decorator.namespace};`);
      }
    }
  }

  if (ArmResourcesCache.size) {
    modules.add(`import "@azure-tools/typespec-azure-resource-manager";`);
    namespaces.add(`using Azure.ResourceManager;`);
    namespaces.add(`using Azure.ResourceManager.Foundations;`);
  }

  return {
    modules: [...modules],
    namespaces: [...namespaces],
  };
}

export function getRoutesImports(_program: CadlProgram) {
  const imports: Imports = {
    modules: [`import "@azure-tools/typespec-azure-core";`, `import "@typespec/rest";`, `import "./models.tsp";`],
    namespaces: [`using TypeSpec.Rest;`, `using TypeSpec.Http;`],
  };

  return imports;
}
