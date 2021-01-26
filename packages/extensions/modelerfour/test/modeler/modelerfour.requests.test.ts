import { addOperation, createTestSpec } from "../utils";
import { runModeler } from "./modelerfour-utils";

describe("Modelerfour.Request", () => {
  describe("Body", () => {
    describe("Required attribute", () => {
      const runModelerWithBody = async (body: any) => {
        const spec = createTestSpec();

        addOperation(spec, "/test", {
          post: {
            requestBody: {
              ...body,
            },
          },
        });

        const codeModel = await runModeler(spec);
        const parameter = codeModel.operationGroups[0]?.operations[0]?.requests?.[0]?.parameters?.[0];

        expect(parameter).not.toBeNull();
        return parameter;
      };

      const defaultBody = {
        content: {
          "application/octet-stream": {
            schema: {
              type: "object",
              format: "file",
            },
          },
        },
      };

      it("mark body as required if required: true", async () => {
        const parameter = await runModelerWithBody({ ...defaultBody, required: true });
        expect(parameter?.required).toBe(true);
      });

      it("mark body as not required if required: false", async () => {
        const parameter = await runModelerWithBody({ ...defaultBody, required: true });
        expect(parameter?.required).toBe(true);
      });

      it("mark body as not required by default", async () => {
        const parameter = await runModelerWithBody(defaultBody);
        expect(parameter?.required).toBe(undefined);
      });
    });
  });
});
