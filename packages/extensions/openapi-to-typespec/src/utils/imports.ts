import { TypespecProgram } from "../interfaces";
import { getOptions } from "../options";

type Imports = {
  modules: string[];
  namespaces: string[];
};

export function getModelsImports(program: TypespecProgram) {
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
  const { isArm } = getOptions();

  if (isArm) {
    modules.add(`import "@azure-tools/typespec-azure-resource-manager";`);
    namespaces.add("using Azure.ResourceManager;");
    namespaces.add("using Azure.ResourceManager.Foundations;");
  }

  return {
    modules: [...modules],
    namespaces: [...namespaces],
  };
}

export function getClientImports(program: TypespecProgram) {
  const modules = new Set<string>();
  const namespaces = new Set<string>();
  for (const model of program.models.objects) {
    for (const property of model.properties) {
      for (const decorator of property.clientDecorators ?? []) {
        decorator.module && modules.add(`import "${decorator.module}";`);
        decorator.namespace && namespaces.add(`using ${decorator.namespace};`);
      }
    }
  }

  return {
    modules: [...modules],
    namespaces: [...namespaces],
  };
}

export function getRoutesImports(_program: TypespecProgram) {
  const modules = new Set<string>();
  const namespaces = new Set<string>();

  modules.add(`import "@azure-tools/typespec-azure-core";`);
  modules.add(`import "@typespec/rest";`);
  modules.add(`import "./models.tsp";`);

  namespaces.add(`using TypeSpec.Rest;`);
  namespaces.add(`using TypeSpec.Http;`);

  const { isArm } = getOptions();

  if (isArm) {
    modules.add(`import "@azure-tools/typespec-azure-resource-manager";`);
    namespaces.add("using Azure.ResourceManager;");
  }

  for (const og of _program.operationGroups) {
    for (const operation of og.operations) {
      for (const param of operation.parameters) {
        for (const decorator of param.decorators ?? []) {
          decorator.module && modules.add(`import "${decorator.module}";`);
          decorator.namespace && namespaces.add(`using ${decorator.namespace};`);
        }
      }
    }
  }

  return {
    modules: [...modules],
    namespaces: [...namespaces],
  };
}
