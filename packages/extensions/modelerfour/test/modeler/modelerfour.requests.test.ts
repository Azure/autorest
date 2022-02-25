/* eslint-disable jest/no-standalone-expect */
/* eslint-disable @typescript-eslint/no-non-null-assertion */

import assert from "assert";
import { CodeModel, DictionarySchema, HttpHeader, Operation, Parameter } from "@autorest/codemodel";
import { JsonType, ParameterLocation } from "@azure-tools/openapi";
import * as oai3 from "@azure-tools/openapi";
import { addOperation, createTestSpec, findByName } from "../utils";
import { runModeler, runModelerWithOperation } from "./modelerfour-utils";

describe("Modelerfour.Request", () => {
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
            name: "x-ms-req-meta",
            "x-ms-client-name": "RequestHeaderWithExtension",
            in: "header",
            schema: {
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
                schema: {
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

  describe("ignore headers with config", () => {
    it("propagates extensions to request header definitions", async () => {
      const spec = createTestSpec();
      const operationDef = {
        operationId: "headerToIgnore",
        description: "Has header to ignore",
        parameters: [
          {
            name: "foo",
            in: "header",
            schema: {
              type: "string",
            },
          },
          {
            name: "bar",
            in: "header",
            schema: {
              type: "string",
            },
          },
        ],
        responses: {
          200: {
            description: "Response with a header extension.",
          },
        },
      };
      addOperation(spec, "/headerToIgnore", {
        post: operationDef,
      });

      const model = await runModeler(spec, {
        modelerfour: {
          "ignore-headers": ["foo"],
        },
      });
      const parameters = model.operationGroups[0].operations[0].parameters;
      assert(parameters);
      expect(parameters).toHaveLength(2);
      expect(parameters[1].language.default.serializedName).toEqual("bar");
      expect(parameters[1].protocol).toEqual({ http: { in: "header" } });
    });
  });
});
