/* eslint-disable jest/no-standalone-expect */
/* eslint-disable @typescript-eslint/no-non-null-assertion */

import { CodeModel, DictionarySchema, HttpHeader, Operation, Parameter, SealedChoiceSchema } from "@autorest/codemodel";
import { HttpOperation, JsonType, ParameterLocation, RequestBody } from "@azure-tools/openapi";
import { addOperation, createTestSpec, findByName } from "../utils";
import { runModeler } from "./modelerfour-utils";
import * as oai3 from "@azure-tools/openapi";
import assert from "assert";

async function runModelerWithOperation(
  method: string,
  path: string,
  operation: oai3.HttpOperation,
): Promise<Operation> {
  const spec = createTestSpec();

  addOperation(spec, path, {
    [method]: operation,
  });

  const codeModel = await runModeler(spec);
  const m4Operation = codeModel.operationGroups[0]?.operations[0];
  assert(m4Operation);
  return m4Operation;
}

describe("Modelerfour.Request", () => {
  describe("Body", () => {
    const runModelerWithBody = async (body: RequestBody): Promise<Operation> => {
      return runModelerWithOperation("post", "/test", {
        requestBody: {
          ...body,
        },
        responses: {},
      });
    };

    describe("Required attribute", () => {
      const runModelerWithBodyAndGetParam = async (body: RequestBody) => {
        const operation = await runModelerWithBody(body);
        const parameter = operation.requests?.[0]?.parameters?.[0];

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
        const parameter = await runModelerWithBodyAndGetParam({ ...defaultBody, required: true });
        expect(parameter?.required).toBe(true);
      });

      it("mark body as not required if required: false", async () => {
        const parameter = await runModelerWithBodyAndGetParam({ ...defaultBody, required: true });
        expect(parameter?.required).toBe(true);
      });

      it("mark body as not required by default", async () => {
        const parameter = await runModelerWithBodyAndGetParam(defaultBody);
        expect(parameter?.required).toBe(undefined);
      });
    });

    describe("multiple binary content-types", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/octet-stream": {
              schema: { type: JsonType.String, format: "binary" },
            },
            "image/png": {
              schema: { type: JsonType.String, format: "binary" },
            },
          },
        });
      });

      it("only create one request", async () => {
        expect(operation.requests?.length).toEqual(1);
      });

      it("operation has a content-type parameter", async () => {
        const param = findByName("content-type", operation.requests?.[0].parameters);
        assert(param);
        expect(param?.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/octet-stream", "image/png"]);
      });
    });

    describe("has binary content type and application/json with binary schema", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/octet-stream": {
              schema: { type: JsonType.String, format: "binary" },
            },
            "application/json": {
              schema: { type: JsonType.String, format: "binary" },
            },
          },
        });
      });

      it("only create one request", async () => {
        expect(operation.requests?.length).toEqual(1);
      });

      it("operation has a content-type parameter", async () => {
        const param = findByName("content-type", operation.requests?.[0].parameters);
        assert(param);
        expect(param?.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/json", "application/octet-stream"]);
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
      assert(parameters);
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
    let operation2: Operation;
    let codeModel: CodeModel;

    beforeEach(async () => {
      spec = createTestSpec();

      const operationDef = {
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
      };
      addOperation(spec, "/headerWithExtension", {
        post: operationDef,
        put: { ...operationDef, operationId: "hasHeaderWithExtension2" },
      });

      codeModel = await runModeler(spec);
      operation = findByName("hasHeaderWithExtension", codeModel.operationGroups[0].operations)!;
      operation2 = findByName("hasHeaderWithExtension2", codeModel.operationGroups[0].operations)!;
      assert(operation);
    });

    describe("response header", () => {
      let header: HttpHeader;
      beforeEach(() => {
        header = findByName<HttpHeader>("HeaderWithExtension", operation.responses?.[0].protocol.http!.headers)!;
        assert(header);
      });

      it("propagates extensions to response header definitions", async () => {
        expect(header.language.default.name).toEqual("HeaderWithExtension");
        expect(header.extensions?.["x-ms-header-collection-prefix"]).toEqual("x-ms-res-meta");
      });

      it("changes the type of the response header to be Dictionary<originalType>", async () => {
        expect(header.schema.type).toEqual("dictionary");
        expect((header.schema as any).elementType.type).toEqual("string");
      });

      it("added the response header schemas to the shared list of schemas", async () => {
        expect(codeModel.schemas.dictionaries).toContain(header.schema);
      });

      it("share the same header if it is the exact same across operations", async () => {
        const header2 = findByName<HttpHeader>(
          "HeaderWithExtension",
          operation2.responses?.[0].protocol.http!.headers,
        )!;
        expect(header2).toBeDefined();

        expect(codeModel.schemas.dictionaries).toContain(header2.schema);

        // It should be the exact same object
        expect(header.schema).toBe(header2.schema);
      });
    });

    describe("request header", () => {
      let parameter: Parameter;
      beforeEach(() => {
        parameter = findByName("RequestHeaderWithExtension", operation.parameters)!;
        assert(parameter);
      });

      it("propagates extensions to request header definitions", async () => {
        expect(parameter.language.default.name).toEqual("RequestHeaderWithExtension");
        expect(parameter.extensions?.["x-ms-header-collection-prefix"]).toEqual("x-ms-req-meta");
      });

      it("changes the type of the request header to be Dictionary<originalType>", async () => {
        expect(parameter.schema.type).toEqual("dictionary");
        expect((parameter.schema as DictionarySchema).elementType.type).toEqual("string");
      });

      it("added the ressponse header schemas to the shared list of schemas", async () => {
        const headerWithExtension = operation.parameters?.[1];
        expect(codeModel.schemas.dictionaries).toContain(headerWithExtension!.schema);
      });

      it("share the same header if it is the exact same across operations", async () => {
        const parameter2 = findByName("RequestHeaderWithExtension", operation.parameters)!;

        expect(parameter2).toBeDefined();

        expect(codeModel.schemas.dictionaries).toContain(parameter2.schema);

        // It should be the exact same object
        expect(parameter.schema).toBe(parameter2.schema);
      });
    });
  });

  describe("deprecation", () => {
    it("doesn't set deprecated property by default", async () => {
      const operation = await runModelerWithOperation("get", "/depreacted", {
        responses: {},
      });

      expect(operation.deprecated).toEqual(undefined);
    });

    it("mark request as deprecated if deprecated: true", async () => {
      const operation = await runModelerWithOperation("get", "/depreacted", {
        deprecated: true,
        responses: {},
      });

      expect(operation.deprecated).toEqual({});
    });

    it("mark query parameter as deprecated", async () => {
      const operation = await runModelerWithOperation("get", "/depreacted", {
        responses: {},
        parameters: [
          {
            name: "deprecatedQueryParam",
            in: ParameterLocation.Query,
            schema: { type: JsonType.String },
            deprecated: true,
          },
        ],
      });

      const parameter = findByName("deprecatedQueryParam", operation.parameters);
      expect(parameter?.deprecated).toEqual({});
    });

    it("mark header parameter as deprecated", async () => {
      const operation = await runModelerWithOperation("get", "/depreacted", {
        responses: {},
        parameters: [
          {
            name: "deprecatedHeaderParam",
            in: ParameterLocation.Header,
            schema: { type: JsonType.String },
            deprecated: true,
          },
        ],
      });

      const parameter = findByName("deprecatedHeaderParam", operation.parameters);
      expect(parameter?.deprecated).toEqual({});
    });
  });
});
