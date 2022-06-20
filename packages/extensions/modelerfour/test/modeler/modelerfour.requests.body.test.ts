/* eslint-disable @typescript-eslint/no-non-null-asserted-optional-chain */
/* eslint-disable jest/no-standalone-expect */
/* eslint-disable @typescript-eslint/no-non-null-assertion */

import assert from "assert";
import { inspect } from "util";
import {
  BinarySchema,
  ByteArraySchema,
  ChoiceSchema,
  CodeModel,
  DateTimeSchema,
  DictionarySchema,
  DurationSchema,
  HttpHeader,
  HttpRequest,
  ObjectSchema,
  Operation,
  Parameter,
  Request,
  SealedChoiceSchema,
  StringSchema,
} from "@autorest/codemodel";
import { KnownMediaType } from "@azure-tools/codegen";
import { HttpOperation, JsonType, ParameterLocation, RequestBody, Schema } from "@azure-tools/openapi";
import * as oai3 from "@azure-tools/openapi";
import { addOperation, createTestSpec, findByName } from "../utils";
import { runModeler, runModelerWithOperation } from "./modelerfour-utils";

function getBody(request: Request) {
  const body = findByName("body", request.parameters) ?? findByName("data", request.parameters);
  assert(body);
  return body;
}

async function runModelerWithBody(body: RequestBody): Promise<Operation> {
  return runModelerWithOperation("post", "/test", {
    operationId: "test",
    requestBody: {
      ...body,
    },
    responses: {},
  });
}

describe("Modelerfour.Request.Body", () => {
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

  describe("Body content types/schema scenarios", () => {
    describe("Body schema is type: string, format: binary", () => {
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
        expect(operation.requests).toHaveLength(1);
      });

      it("has a content-type parameter listing all content types for operation", async () => {
        const param = findByName("content-type", operation.requests?.[0].parameters);
        assert(param);
        expect(param?.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/octet-stream", "image/png"]);
      });
    });

    describe("Body schema is type: string with application/json content type", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/json": {
              schema: { type: JsonType.String },
            },
          },
        });
      });

      it("only create one request", async () => {
        expect(operation.requests).toHaveLength(1);
      });

      it("known media type is json", async () => {
        expect(operation.requests![0].protocol.http!.knownMediaType).toEqual(KnownMediaType.Json);
      });
    });

    describe("Body is an object with application/json content-type", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/json": {
              schema: { type: "object", properties: { name: { type: "string" } } },
            },
          },
        });
      });

      it("only create one request", async () => {
        expect(operation.requests).toHaveLength(1);
      });

      it("has a no content-type parameter", async () => {
        const param = findByName("content-type", operation.requests?.[0].parameters);
        expect(param).toBe(undefined);
      });
    });

    // This is a scenario coming from Swagger 2.0
    // post:
    //   consumes:
    //     - "application/json"
    //     - "application/octet-stream"
    //     - "image/png"
    //     - "text/plain"
    //   parameters:
    //     - in: body
    //       name: body
    //       schema:
    //         $ref: "#/definitions/Foo"
    describe("Body is an object with application/json, text/plain, image/png and application/octet-stream content types", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/json": {
              schema: { type: "object", properties: { name: { type: "string" } } },
            },
            "text/plain": {
              schema: { type: "object", properties: { name: { type: "string" } } },
            },
            "image/png": {
              schema: { type: "object", properties: { name: { type: "string" } } },
            },
            "application/octet-stream": {
              schema: { type: "object", properties: { name: { type: "string" } } },
            },
          },
        });
      });

      it("creates 3 requests", async () => {
        expect(operation.requests).toHaveLength(3);
      });

      it("1st request should cover the application/json case", async () => {
        const request = operation.requests?.[0]!;
        const param = findByName("content-type", request.parameters);
        expect(param).toBe(undefined);
        expect(request.protocol.http!.mediaTypes).toEqual(["application/json"]);
        expect(getBody(request).schema instanceof ObjectSchema).toBe(true);
      });

      it("2nd request should cover the text/plain case", async () => {
        const request = operation.requests?.[1]!;
        const param = findByName("content-type", request.parameters);
        expect(param).toBe(undefined);
        expect(request.protocol.http!.mediaTypes).toEqual(["text/plain"]);

        expect(getBody(request).schema instanceof StringSchema).toBe(true);
      });

      it("3rd request should cover the binary case and have 2 binary content type options", async () => {
        const request = operation.requests?.[2]!;
        const param = findByName("content-type", request.parameters);
        assert(param);
        expect(param.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/octet-stream", "image/png"]);

        expect(getBody(request).schema instanceof BinarySchema).toBe(true);
      });
    });

    describe("Body is an string with application/json, text/plain, image/png and application/octet-stream content types", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "application/json": {
              schema: { type: "string" },
            },
            "text/plain": {
              schema: { type: "string" },
            },
            "image/png": {
              schema: { type: "string" },
            },
            "application/octet-stream": {
              schema: { type: "string" },
            },
          },
        });
      });

      it("creates 2 requests", async () => {
        expect(operation.requests).toHaveLength(2);
      });

      it("1st request should cover the application/json and test/plain case", async () => {
        const request = operation.requests?.[0]!;
        const param = findByName("content-type", request.parameters);
        assert(param);
        expect(param.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/json", "text/plain"]);
        expect(request.protocol.http!.mediaTypes).toEqual(["application/json", "text/plain"]);

        expect(getBody(request).schema instanceof StringSchema).toBe(true);
      });

      it("2nd request should cover the binary case and have 2 binary content type options", async () => {
        const request = operation.requests?.[1]!;
        const param = findByName("content-type", request.parameters);
        assert(param);
        expect(param.schema.type).toEqual("sealed-choice");
        const schema = param?.schema as SealedChoiceSchema;
        expect(schema.choices.map((x) => x.value)).toEqual(["application/octet-stream", "image/png"]);
        expect(request.protocol.http!.mediaTypes).toEqual(["application/octet-stream", "image/png"]);

        expect(getBody(request).schema instanceof BinarySchema).toBe(true);
      });
    });

    describe("Body is an object with multiple serialization format: application/json, application/xml, application/x-www-form-urlencoded", () => {
      let operation: Operation;

      beforeEach(async () => {
        const schema: Schema = { type: "object", properties: { name: { type: "string" } } };
        operation = await runModelerWithBody({
          content: {
            "application/json": { schema },
            "application/x-www-form-urlencoded": { schema },
            "application/xml": { schema },
          },
        });
      });

      it("creates 1 requests", async () => {
        expect(operation.requests).toHaveLength(1);
      });

      it("request should cover the application/json case and ignore the others", async () => {
        const request = operation.requests?.[0]!;
        const param = findByName("content-type", request.parameters);
        expect(param).toBe(undefined);
        expect(request.protocol.http!.mediaTypes).toEqual([
          "application/json",
          "application/x-www-form-urlencoded",
          "application/xml",
        ]);
        expect(getBody(request).schema instanceof ObjectSchema).toBe(true);
      });
    });

    describe("Body is an string and text/plain content type", () => {
      let operation: Operation;

      beforeEach(async () => {
        operation = await runModelerWithBody({
          content: {
            "text/plain": {
              schema: { type: "string" },
            },
          },
        });
      });

      it("creates 1 requests", async () => {
        expect(operation.requests).toHaveLength(1);
      });

      it("should have a string parameter with text/plain content type", async () => {
        const request = operation.requests?.[0]!;
        const param = findByName("content-type", request.parameters);
        expect(param).toBe(undefined);
        expect(request.protocol.http!.mediaTypes).toEqual(["text/plain"]);

        expect(getBody(request).schema instanceof StringSchema).toBe(true);
      });
    });

    describe("multipart/form-data", () => {
      let parameters: Parameter[] | undefined;

      beforeEach(async () => {
        const spec = createTestSpec();
        const operation: HttpOperation = {
          operationId: "test",
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

    describe("application/json, type: string, custom format types", () => {
      const scenarios = [
        [{ format: "byte" }, ByteArraySchema],
        [{ format: "date-time" }, DateTimeSchema],
        [{ format: "duration" }, DurationSchema],
        [{ enum: ["one", "two"] }, ChoiceSchema],
      ] as const;
      scenarios.forEach(([extra, type]) => {
        describe(`format:${inspect(extra)} with application/json`, () => {
          let operation: Operation;

          beforeEach(async () => {
            operation = await runModelerWithBody({
              content: {
                "application/json": {
                  schema: { type: "string", ...(extra as any) },
                },
              },
            });
          });

          it("only create one request", async () => {
            expect(operation.requests).toHaveLength(1);
          });

          it(`parameter should be of type ${type.name}`, async () => {
            const request = operation.requests?.[0]!;
            const param = findByName("content-type", request.parameters);
            expect(param).toBe(undefined);
            expect(request.protocol.http!.mediaTypes).toEqual(["application/json"]);

            expect(getBody(request).schema instanceof type).toBe(true);
          });
        });
      });
    });

    describe("Body schema is type: object with application/json and x-json-stream content type", () => {
      let operation: Operation;

      beforeEach(async () => {
        const bodyType: Schema = { type: "object", properties: { name: { type: "string" } } };
        operation = await runModelerWithBody({
          content: {
            "application/json": {
              schema: bodyType,
            },
            "x-json-stream": {
              schema: bodyType,
            },
          },
        });
      });

      it("doesn't create errors", () => {});
      it("only create one request", async () => {
        expect(operation.requests).toHaveLength(1);
      });

      it("known media type is json (ignored unknown x-json-stream)", async () => {
        expect(operation.requests![0].protocol.http!.knownMediaType).toEqual(KnownMediaType.Json);
      });
    });
  });

  it("generate unique names for ContentType enums", async () => {
    const spec = createTestSpec();

    const bodyType = { type: "string", format: "binary" };

    addOperation(spec, "/test1", {
      post: {
        operationId: "test1",
        requestBody: {
          content: {
            "application/json": {
              schema: bodyType,
            },
            "application/png": {
              schema: bodyType,
            },
          },
        },
        responses: {},
      },
    });
    addOperation(spec, "/test2", {
      post: {
        operationId: "test2",
        requestBody: {
          content: {
            "application/jpeg": {
              schema: bodyType,
            },
            "application/png": {
              schema: bodyType,
            },
          },
        },
        responses: {},
      },
    });
    addOperation(spec, "/test3", {
      post: {
        operationId: "test3",
        requestBody: {
          content: {
            "application/pdf": {
              schema: bodyType,
            },
            "application/jpeg": {
              schema: bodyType,
            },
          },
        },
        responses: {},
      },
    });

    const codeModel = await runModeler(spec);
    const contentType0 = findByName("ContentType", codeModel.schemas.sealedChoices);
    assert(contentType0);
    expect(contentType0.choices.map((x) => x.value)).toEqual(["application/json", "application/png"]);
    const contentType1 = findByName("ContentType1", codeModel.schemas.sealedChoices);
    assert(contentType1);
    expect(contentType1.choices.map((x) => x.value)).toEqual(["application/jpeg", "application/png"]);
    const contentType2 = findByName("ContentType2", codeModel.schemas.sealedChoices);
    assert(contentType2);
    expect(contentType2.choices.map((x) => x.value)).toEqual(["application/jpeg", "application/pdf"]);
  });
});
