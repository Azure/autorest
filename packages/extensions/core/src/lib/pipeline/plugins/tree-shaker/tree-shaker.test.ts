import { Source } from "@azure-tools/datastore";
import { JsonType, Model } from "@azure-tools/openapi";
import { OAI3Shaker } from "./tree-shaker";

const createTestModel = (model: Partial<Model>): Model => {
  return {
    openApi: "3.0.0",
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

const shake = async (model: any) => {
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
              "type": JsonType.Object,
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
              parameters: [{ "in": "query", "name": "some-param", "x-ms-client-name": "SomeParamClient" }],
            },
          },
        },
      });

      const param = Object.values<any>(result.components.parameters)[0];
      expect(param["x-ms-client-name"]).toEqual("SomeParamClient");
    });

    it("removes x-ms-client-name on shaked model when used on property with inline model definition", async () => {
      const result = await shake({
        components: {
          schemas: {
            Foo: {
              type: JsonType.Object,
              properties: {
                bar: {
                  "x-ms-client-name": "barClient",
                  "type": JsonType.Object,
                  "properties": {
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
  });
});
