import { TypespecDecorator, TypespecProgram } from "../interfaces";
import { getOptions } from "../options";

export type Imports = {
  modules: string[];
  namespaces: string[];
};

export function getModelsImports(program: TypespecProgram): Imports {
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
  const addImports = (decs: TypespecDecorator[] | undefined) => {
    for (const dec of decs ?? []) {
      dec.module && modules.add(`import "${dec.module}";`);
      dec.namespace && namespaces.add(`using ${dec.namespace};`);
    }
  };
  for (const model of program.models.objects) {
    addImports(model.clientDecorators);
    for (const property of model.properties) {
      addImports(property.clientDecorators);
    }
  }

  for (const model of program.models.enums) {
    addImports(model.clientDecorators);
    for (const choice of model.members) {
      addImports(choice.clientDecorators);
    }
  }

  for (const resource of program.models.armResources) {
    addImports(resource.clientDecorators);
    for (const property of resource.properties) {
      addImports(property.clientDecorators);
    }
    for (const op of resource.resourceOperations) {
      addImports(op.clientDecorators);
    }
    for (const op of resource.normalOperations) {
      addImports(op.clientDecorators);
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
