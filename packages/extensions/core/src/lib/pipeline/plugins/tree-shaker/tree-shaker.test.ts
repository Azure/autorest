import { Source } from "@azure-tools/datastore";
import { JsonType, Model } from "@azure-tools/openapi";
import { create } from "domain";
import { OAI3Shaker } from "./tree-shaker";

const createTestModel = (model: any): Model => {
  return {
    openApi: "3.0.0",
    paths: {},
    info: {
      title: "Test spec",
      version: "1.0.0",
    },
    servers: {},
    security: {},
    components: {},
    tags: {},
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
  it("when using x-ms-client-name on property with inline model definition it removes it from the shaked model", async () => {
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

    expect(Object.keys(result.components.schemas).length).toBe(3);
    console.log("result.components.schemas", result.components.schemas);
    expect(result.components.schemas.Foo.properties.bar["x-ms-client-name"]).toEqual("barClient");
    expect(result.components.schemas["Foo-bar"]["x-ms-client-name"]).toBeUndefined();
  });
});
