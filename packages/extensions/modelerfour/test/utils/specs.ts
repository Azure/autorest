import { clone } from "@azure-tools/linq";

export const InitialTestSpec = Object.freeze({
  info: {
    title: "Test OpenAPI 3 Specification",
    description: "A test document",
    contact: {
      name: "Microsoft Corporation",
      url: "https://microsoft.com",
      email: "devnull@microsoft.com",
    },
    license: "MIT",
    version: "1.0",
  },
  paths: {},
  components: {
    schemas: {},
  },
});

export type TestSpecCustomizer = (spec: any) => any;

export function createTestSpec(...customizers: Array<TestSpecCustomizer>): any {
  return customizers.reduce<any>(
    (spec: any, customizer: TestSpecCustomizer) => customizer(spec),
    clone(InitialTestSpec),
  );
}

export function addOperation(
  spec: any,
  path: string,
  operationDict: any,
  metadata: any = { apiVersions: ["1.0.0"] },
): void {
  operationDict = { ...operationDict, ...{ "x-ms-metadata": metadata } };
  spec.paths[path] = operationDict;
}

export function addSchema(spec: any, name: string, schemaDict: any, metadata: any = { apiVersions: ["1.0.0"] }): void {
  schemaDict = { ...schemaDict, ...{ "x-ms-metadata": metadata } };
  spec.components.schemas[name] = schemaDict;
}
