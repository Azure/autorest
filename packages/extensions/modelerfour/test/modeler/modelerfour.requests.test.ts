import { Parameter } from "@autorest/codemodel";
import { HttpOperation, JsonType, ParameterLocation, RequestBody } from "@azure-tools/openapi";
import { addOperation, createTestSpec } from "../utils";
import { runModeler } from "./modelerfour-utils";

describe("Modelerfour.Request", () => {
  describe("Body", () => {
    describe("Required attribute", () => {
      const runModelerWithBody = async (body: RequestBody) => {
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
              type: JsonType.Object,
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

  describe("multipart/form-data", () => {
    let parameters: Parameter[] | undefined;

    beforeEach(async () => {
      const spec = createTestSpec();
      const operation: HttpOperation = {
        requestBody: {
          content: {
            "multipart/form-data": {
              schema: {
                type: JsonType.Object,
                properties: {
                  id: {
                    type: JsonType.String,
                  },
                  address: {
                    type: JsonType.String,
                  },
                },
              },
            },
          },
        },
        parameters: [{ in: ParameterLocation.Query, name: "queryParam", schema: { type: JsonType.String } }],
        responses: { "200": { description: "Ok." } },
      };

      addOperation(spec, "/test", {
        post: operation,
      });

      const codeModel = await runModeler(spec);
      parameters = codeModel.operationGroups[0]?.operations[0]?.requests?.[0]?.parameters;
      expect(parameters).not.toBeNull();
    });

    it("mark body parameter as isInMultipart", async () => {
      const idParameter = parameters?.[0];
      const addressParameter = parameters?.[1];
      expect(idParameter?.language.default.name).toEqual("id");
      expect(idParameter?.isInMultipart).toBe(true);
      expect(addressParameter?.language.default.name).toEqual("address");
      expect(idParameter?.isInMultipart).toBe(true);
    });

    it("doesn't mark other parameter as isInMultipart", async () => {
      const queryParam = parameters?.[2];

      expect(queryParam?.language.default.name).toEqual(queryParam);
      expect(queryParam?.isInMultipart).toBeFalsy();
    });
  });
});
