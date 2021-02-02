import { addOperation, addSchema, createTestSpec } from "../utils";
import { runModeler } from "./modelerfour-utils";

describe("Modelerfour.Schemas", () => {
  describe("additionalProperties", () => {
    it("support reference to itself(circular dependency", async () => {
      const spec = createTestSpec();

      addSchema(spec, "SelfRefSchema", {
        additionalProperties: {
          $ref: "#/components/schemas/SelfRefSchema",
        },
      });

      const codeModel = await runModeler(spec);

      const schema = codeModel.schemas.dictionaries?.[0];
      expect(schema).not.toBeNull();
      expect(schema?.language.default.name).toEqual("SelfRefSchema");
      expect(schema?.elementType).toEqual(schema);
    });
  });
});
