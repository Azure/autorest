/* eslint-disable @typescript-eslint/no-non-null-assertion */

import { CodeModel, DictionarySchema, Operation, Parameter } from "@autorest/codemodel";
import { HttpOperation, JsonType, ParameterLocation, RequestBody } from "@azure-tools/openapi";
import { addOperation, createTestSpec, findByName } from "../utils";
import { runModeler } from "./modelerfour-utils";
import * as oai3 from "@azure-tools/openapi";

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
      expect(idParameter?.isPartialBody).toBe(true);
      expect(addressParameter?.language.default.name).toEqual("address");
      expect(idParameter?.isPartialBody).toBe(true);
    });

    it("doesn't mark other parameter as isInMultipart", async () => {
      const queryParam = parameters?.[2];

      expect(queryParam?.language.default.name).toEqual(queryParam);
      expect(queryParam?.isPartialBody).toBeFalsy();
    });
  });

  describe("x-ms-header-collection-prefix headers", () => {
    let spec: oai3.Model;

    let operation: Operation;
    let codeModel: CodeModel;

    beforeEach(async () => {
      spec = createTestSpec();

      addOperation(spec, "/headerWithExtension", <oai3.PathItem>{
        post: {
          operationId: "hasHeaderWithExtension",
          description: "Has x-ms-header-collection-prefix on header",
          parameters: [
            {
              "name": "x-ms-req-meta",
              "x-ms-client-name": "RequestHeaderWithExtension",
              "in": "header",
              "schema": {
                type: "string",
              },
              "x-ms-parameter-location": "method",
              "x-ms-header-collection-prefix": "x-ms-req-meta",
            },
          ],
          responses: {
            200: {
              description: "Response with a header extension.",
              content: {
                "application/json": {
                  schema: {
                    type: "string",
                  },
                },
              },
              headers: {
                "x-named-header": {
                  "x-ms-client-name": "HeaderWithExtension",
                  "x-ms-header-collection-prefix": "x-ms-res-meta",
                  "schema": {
                    type: "string",
                  },
                },
              },
            },
          },
        },
      });
      codeModel = await runModeler(spec);
      operation = findByName("hasHeaderWithExtension", codeModel.operationGroups[0].operations)!;
      expect(operation).not.toBeNull();
    });

    describe("response header", () => {
      it("propagates extensions to response header definitions", async () => {
        const headerWithExtension = operation.responses?.[0].protocol.http!.headers[0];
        expect(headerWithExtension.language.default.name).toEqual("HeaderWithExtension");
        expect(headerWithExtension.extensions["x-ms-header-collection-prefix"]).toEqual("x-ms-res-meta");
      });

      it("changes the type of the response header to be Dictionary<originalType>", async () => {
        const headerWithExtension = operation.responses?.[0].protocol.http!.headers[0];
        expect(headerWithExtension.schema.type).toEqual("dictionary");
        expect(headerWithExtension.schema.elementType.type).toEqual("string");
      });

      it("added the ressponse header schemas to the shared list of schemas", async () => {
        const headerWithExtension = operation.responses?.[0].protocol.http!.headers[0];
        expect(codeModel.schemas.dictionaries).toContain(headerWithExtension.schema);
      });
    });

    describe("request header", () => {
      it("propagates extensions to request header definitions", async () => {
        const headerWithExtension = operation.parameters?.[1];
        expect(headerWithExtension?.language.default.name).toEqual("RequestHeaderWithExtension");
        expect(headerWithExtension?.extensions?.["x-ms-header-collection-prefix"]).toEqual("x-ms-req-meta");
      });

      it("changes the type of the request header to be Dictionary<originalType>", async () => {
        const headerWithExtension = operation.parameters?.[1];
        expect(headerWithExtension?.schema.type).toEqual("dictionary");
        expect((headerWithExtension?.schema as DictionarySchema).elementType.type).toEqual("string");
      });

      it("added the ressponse header schemas to the shared list of schemas", async () => {
        const headerWithExtension = operation.parameters?.[1];
        expect(codeModel.schemas.dictionaries).toContain(headerWithExtension!.schema);
      });
    });
  });
});
