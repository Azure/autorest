import { Source } from "@azure-tools/datastore";
import { JsonType, OpenAPI3Document } from "@azure-tools/openapi";
import { OAI3Shaker } from "./tree-shaker";

const createTestModel = (model: Partial<OpenAPI3Document>): OpenAPI3Document => {
  return {
    openapi: "3.0.0",
    paths: {},
    info: {
      title: "Test spec",
      version: "1.0.0",
    },
    servers: [],
    security: [],
    components: {},
    tags: [],
    ...model,
  };
};

const shake = async (model: Partial<OpenAPI3Document>) => {
  const source: Source = {
    ReadObject: () => Promise.resolve<any>(createTestModel(model)),
    key: "test",
  };
  const shaker = new OAI3Shaker(source, false);
  return shaker.getOutput();
};

describe("Tree shaker", () => {
  describe("when using x-ms-client-name", () => {
    it("keeps x-ms-client-name when used on a schema", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              type: "object",
              "x-ms-client-name": "FooClient",
            },
          },
        },
      });

      expect(result.components.schemas.Foo["x-ms-client-name"]).toEqual("FooClient");
    });

    it("keeps x-ms-client-name when used on a parameter", async () => {
      const result = await shake({
        paths: {
          "/mypath": {
            get: {
              parameters: [{ in: "query", name: "some-param", "x-ms-client-name": "SomeParamClient" }],
              responses: {},
            },
          },
        },
      });

      const param = Object.values<any>(result.components.parameters)[0];
      expect(param["x-ms-client-name"]).toEqual("SomeParamClient");
    });

    it("keeps x-ms-client-name on the extraced type when used in items of an array", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              type: "array",
              items: {
                "x-ms-client-name": "CustomFooClientItem",
                type: "object",
                properties: {
                  name: { type: "string" },
                },
              },
            },
          },
        },
      });

      expect(result.components.schemas["FooItem"]["x-ms-client-name"]).toEqual("CustomFooClientItem");
    });

    it("remove x-ms-client-name on the extraced type on inline array type", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              properties: {
                prop: {
                  type: "array",
                  "x-ms-client-name": "CustomFooClientItem",
                  items: {
                    type: "object",
                    properties: {
                      name: { type: "string" },
                    },
                  },
                },
              },
            },
          },
        },
      });
      expect(result.components.schemas["Foo-prop"]["x-ms-client-name"]).toBeUndefined();
    });

    it("removes x-ms-client-name on shaked model when used on property with inline model definition", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              type: "object",
              properties: {
                bar: {
                  "x-ms-client-name": "barClient",
                  type: "object",
                  properties: {
                    name: { type: JsonType.String },
                  },
                },
              },
            },
          },
        },
      });

      expect(result.components.schemas.Foo.properties.bar["x-ms-client-name"]).toEqual("barClient");
      expect(result.components.schemas["Foo-bar"]["x-ms-client-name"]).toBeUndefined();
    });

    it("removes x-ms-client-name on shaked model when used on property with inline enum definition", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              type: "object",
              properties: {
                bar: {
                  "x-ms-client-name": "barClient",
                  type: "string",
                  enum: ["one", "two"],
                },
              },
            },
          },
        },
      });

      expect(result.components.schemas.Foo.properties.bar["x-ms-client-name"]).toEqual("barClient");
      expect(result.components.schemas["Foo-bar"]["x-ms-client-name"]).toBeUndefined();
    });
  });

  it("tree shake parameters", async () => {
    const result = await shake({
      paths: {
        "/mypath": {
          get: {
            parameters: [{ in: "query", name: "some-param" }],
            responses: {},
          },
        },
      },
    });

    const operationParameters = result.paths["/mypath"].get.parameters;
    expect(operationParameters).toHaveLength(1);
    expect(operationParameters[0].$ref).toBeDefined();
    const id = operationParameters[0].$ref.split("/").pop();
    const parameter = result.components.parameters[id];
    expect(parameter).toEqual({ in: "query", name: "some-param", "x-ms-parameter-location": "method" });
  });
});
