/* eslint-disable @typescript-eslint/no-non-null-assertion */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { Parameter, SchemaResponse, ConstantSchema, SealedChoiceSchema } from "@autorest/codemodel";
import { addOperation, addSchema, createTestSpec, findByName, InitialTestSpec, response, responses } from "../utils";
import { runModeler } from "./modelerfour-utils";

function assertSchema(
  schemaName: string,
  schemaList: Array<any> | undefined,
  accessor: (schema: any) => any,
  expected: any,
) {
  expect(schemaList).not.toBeFalsy();

  // We've already asserted, but make the compiler happy
  if (schemaList) {
    const schema = findByName(schemaName, schemaList);
    expect(schema).not.toBeFalsy();
    expect(accessor(schema)).toEqual(expected);
  }
}

describe("Modeler", () => {
  it("preserves 'info' metadata", async () => {
    const spec = createTestSpec();
    const codeModel = await runModeler(spec);

    expect(codeModel.info.title).toEqual(InitialTestSpec.info.title);
    expect(codeModel.info.license).toEqual(InitialTestSpec.info.license);
    expect(codeModel.info.description).toEqual(InitialTestSpec.info.description);
    expect(codeModel.info.contact?.name).toEqual(InitialTestSpec.info.contact.name);
    expect(codeModel.info.contact?.url).toEqual(InitialTestSpec.info.contact.url);
    expect(codeModel.info.contact?.email).toEqual(InitialTestSpec.info.contact.email);
  });

  it("tracks schema usage", async () => {
    const testSchema = {
      type: "object",
      properties: {
        "prop-one": {
          type: "integer",
          format: "int32",
        },
      },
    };

    const spec = createTestSpec();

    addSchema(spec, "Input", {
      type: "object",
      properties: {
        arrayProperty: {
          type: "array",
          items: {
            $ref: "#/components/schemas/ElementSchema",
          },
        },
      },
    });
    addSchema(spec, "OutputItem", {
      type: "object",
      properties: {
        dictionaryProperty: {
          properties: {
            foo: {
              $ref: "#/components/schemas/ElementSchema",
            },
          },
        },
      },
    });
    addSchema(spec, "InputOutput", {
      type: "object",
      properties: {
        property: {
          $ref: "#/components/schemas/ObjectProperty",
        },
      },
    });
    addSchema(spec, "ObjectProperty", {
      type: "object",
      properties: {
        foo: {
          type: "string",
        },
      },
    });
    addSchema(spec, "ElementSchema", {
      type: "object",
      properties: {
        foo: {
          type: "string",
        },
      },
    });

    addOperation(spec, "/test", {
      get: {
        description: "An operation.",
        responses: responses(
          response(200, "application/json", {
            type: "array",
            items: {
              $ref: "#/components/schemas/OutputItem",
            },
          }),
          response(202, "application/xml", {
            $ref: "#/components/schemas/InputOutput",
          }),
        ),
      },
      post: {
        description: "Post it.",
        parameters: [
          {
            name: "inputParam",
            in: "body",
            description: "Input parameter",
            required: true,
            schema: {
              $ref: "#/components/schemas/Input",
            },
          },
          {
            name: "inputOutputParam",
            in: "body",
            description: "Input parameter",
            required: true,
            schema: {
              $ref: "#/components/schemas/InputOutput",
            },
          },
        ],
      },
    });

    const codeModel = await runModeler(spec);

    // Ensure that usage gets propagated to schemas in request parameters
    assertSchema("Input", codeModel.schemas.objects, (s) => s.usage, ["input"]);

    // Ensure that usage gets propagated to properties in response schemas
    assertSchema("OutputItem", codeModel.schemas.objects, (s) => s.usage, ["output"]);

    // Ensure that usage gets propagated to schemas used in both request and response
    assertSchema("InputOutput", codeModel.schemas.objects, (s) => s.usage.sort(), ["input", "output"]);

    // Ensure that usage gets propagated to schems on object properties
    assertSchema("ObjectProperty", codeModel.schemas.objects, (s) => s.usage.sort(), ["input", "output"]);

    // Ensure that usage gets propagated to schemas used as elements of
    // arrays and dictionary property values
    assertSchema("ElementSchema", codeModel.schemas.objects, (s) => s.usage.sort(), ["input", "output"]);
  });

  it("allows integer schemas with unexpected 'format'", async () => {
    const spec = createTestSpec();

    addSchema(spec, "Int16", {
      type: "integer",
      format: "int16",
    });

    addSchema(spec, "Goose", {
      type: "integer",
      format: "goose",
    });

    addSchema(spec, "Int64", {
      type: "integer",
      format: "int64",
    });

    const codeModel = await runModeler(spec);

    assertSchema("Int16", codeModel.schemas.numbers, (s) => s.precision, 32);
    assertSchema("Goose", codeModel.schemas.numbers, (s) => s.precision, 32);

    // Make sure a legitimate format is detected correctly
    assertSchema("Int64", codeModel.schemas.numbers, (s) => s.precision, 64);
  });

  it("modelAsString=true creates ChoiceSchema for single-value enum", async () => {
    const spec = createTestSpec();

    addSchema(spec, "ShouldBeConstant", {
      type: "string",
      enum: ["html_strip"],
    });

    addSchema(spec, "ShouldBeChoice", {
      "type": "string",
      "enum": ["html_strip"],
      "x-ms-enum": {
        modelAsString: true,
      },
    });

    const codeModel = await runModeler(spec);

    assertSchema("ShouldBeConstant", codeModel.schemas.constants, (s) => s.value.value, "html_strip");

    assertSchema("ShouldBeChoice", codeModel.schemas.choices, (s) => s.choices[0].value, "html_strip");
  });

  it("propagates 'nullable' to properties, parameters, collections, and responses", async () => {
    const spec = createTestSpec();

    addSchema(spec, "WannaBeNullable", {
      type: "object",
      nullable: true,
      properties: {
        iIsHere: {
          type: "boolean",
        },
      },
    });

    addSchema(spec, "NotNullable", {
      type: "object",
      nullable: true,
      properties: {
        iIsHere: {
          type: "boolean",
        },
      },
    });

    addSchema(spec, "NullableArrayElement", {
      type: "array",
      items: {
        nullable: true,
        $ref: "#/components/schemas/NotNullable",
      },
    });

    addSchema(spec, "NullableArrayElementSchema", {
      type: "array",
      items: {
        $ref: "#/components/schemas/WannaBeNullable",
      },
    });

    addSchema(spec, "NullableDictionaryElement", {
      additionalProperties: {
        nullable: true,
        $ref: "#/components/schemas/NotNullable",
      },
    });

    addSchema(spec, "NullableDictionaryElementSchema", {
      additionalProperties: {
        $ref: "#/components/schemas/WannaBeNullable",
      },
    });

    addSchema(spec, "NullableProperty", {
      type: "object",
      properties: {
        willBeNullable: {
          $ref: "#/components/schemas/WannaBeNullable",
        },
      },
    });

    addOperation(spec, "/test", {
      post: {
        description: "Post it.",
        parameters: [
          {
            name: "nullableParam",
            in: "body",
            description: "Input parameter",
            required: true,
            schema: {
              $ref: "#/components/schemas/WannaBeNullable",
            },
          },
        ],
        responses: {
          "200": {
            content: {
              "application/json": {
                schema: {
                  type: "string",
                  nullable: true,
                },
              },
            },
          },
        },
      },
    });

    const codeModel = await runModeler(spec);

    assertSchema("NullableArrayElement", codeModel.schemas.arrays, (s) => s.nullableItems, true);

    assertSchema("NullableArrayElementSchema", codeModel.schemas.arrays, (s) => s.nullableItems, true);

    assertSchema("NullableDictionaryElement", codeModel.schemas.dictionaries, (s) => s.nullableItems, true);

    assertSchema("NullableDictionaryElementSchema", codeModel.schemas.dictionaries, (s) => s.nullableItems, true);

    assertSchema("NullableProperty", codeModel.schemas.objects, (s) => s.properties[0].nullable, true);

    // $host param comes first then the parameter we're looking for
    const operation = codeModel.operationGroups[0].operations[0];
    const param = operation.parameters![1];

    const response: SchemaResponse = <SchemaResponse>operation.responses![0];
    expect(param.nullable).toEqual(true);
    expect(response.nullable).toEqual(true);
  });

  it("propagates clientDefaultValue from x-ms-client-default", async () => {
    const spec = createTestSpec();

    addSchema(spec, "HasClientDefault", {
      type: "object",
      nullable: true,
      properties: {
        hasDefaultValue: {
          "type": "boolean",
          "required": true,
          "x-ms-client-default": true,
        },
      },
    });

    addOperation(spec, "/test", {
      post: {
        operationId: "postIt",
        description: "Post it.",
        requestBody: {
          "in": "body",
          "description": "Input parameter",
          "required": true,
          "x-ms-client-default": "Bodied",
          "x-ms-requestBody-name": "defaultedBodyParam",
          "content": {
            "application/json": {
              schema: {
                type: "string",
              },
            },
          },
        },
        parameters: [
          {
            "name": "defaultedQueryParam",
            "in": "query",
            "description": "Input parameter",
            "x-ms-client-default": 42,
            "schema": {
              type: "number",
            },
          },
        ],
      },
    });

    addOperation(spec, "/memes", {
      post: {
        operationId: "postMeme",
        description: "Gimmie ur memes.",
        requestBody: {
          "description": "Input parameter",
          "required": true,
          "x-ms-requestBody-name": "defaultedBodyMeme",
          "x-ms-client-default": "meme.jpg",
          "content": {
            "image/jpeg": {
              schema: {
                type: "string",
                format: "binary",
              },
            },
          },
        },
      },
    });

    const codeModel = await runModeler(spec);

    assertSchema("HasClientDefault", codeModel.schemas.objects, (s) => s.properties[0].clientDefaultValue, true);

    const postIt = findByName("postIt", codeModel.operationGroups[0].operations);
    const bodyParam = findByName<Parameter>(
      "defaultedBodyParam",
      <Array<Parameter> | undefined>postIt!.requests?.[0].parameters,
    );
    expect(bodyParam?.clientDefaultValue).toEqual("Bodied");

    const queryParam = findByName("defaultedQueryParam", postIt!.parameters);
    expect(queryParam!.clientDefaultValue).toEqual(42);

    const postMeme = findByName("postMeme", codeModel.operationGroups[0].operations);
    const memeBodyParam = findByName<Parameter>(
      "defaultedBodyMeme",
      <Array<Parameter> | undefined>postMeme!.requests?.[0].parameters,
    );
    expect(memeBodyParam?.clientDefaultValue).toEqual("meme.jpg");
  });

  it("propagates parameter 'expand' value", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/test", {
      post: {
        operationId: "getIt",
        description: "Get operation.",
        parameters: [
          {
            name: "explodedParam",
            in: "query",
            style: "form",
            explode: true,
            schema: {
              type: "array",
              items: {
                type: "string",
              },
            },
          },
          {
            name: "nonExplodedParam",
            in: "query",
            style: "form",
            schema: {
              type: "array",
              items: {
                type: "string",
              },
            },
          },
        ],
      },
    });

    const codeModel = await runModeler(spec);

    const getIt = findByName("getIt", codeModel.operationGroups[0].operations);
    const explodedParam = findByName("explodedParam", getIt!.parameters);
    expect(explodedParam!.protocol.http!.explode).toBe(true);
    const nonExplodedParam = findByName("nonExplodedParam", getIt!.parameters);
    expect(nonExplodedParam!.protocol.http!.explode).toBe(undefined);
  });

  it("stores header name and description in HttpHeader language field", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/header", {
      post: {
        operationId: "namedHeaders",
        description: "Operation with named header response.",
        parameters: [],
        responses: responses(
          response(
            200,
            "application/json",
            {
              type: "string",
            },
            "Response with a named header.",
            {
              headers: {
                "x-named-header": {
                  "x-ms-client-name": "NamedHeader",
                  // No description on purpose
                  "schema": {
                    type: "string",
                  },
                },
                "x-unnamed-header": {
                  description: "Header with no client name",
                  schema: {
                    type: "string",
                  },
                },
              },
            },
          ),
        ),
      },
    });

    const codeModel = await runModeler(spec);

    const namedHeaders = findByName("namedHeaders", codeModel.operationGroups[0].operations);

    const namedHeader = namedHeaders?.responses?.[0].protocol.http!.headers[0];
    expect(namedHeader.language.default.name).toEqual("NamedHeader");
    expect(namedHeader.language.default.description).toEqual("");

    const unnamedHeader = namedHeaders?.responses?.[0].protocol.http!.headers[1];
    expect(unnamedHeader.language.default.name).toEqual("x-unnamed-header");
    expect(unnamedHeader.language.default.description).toEqual("Header with no client name");
  });

  it("x-ms-text extension in xml object will be moved to 'text' property", async () => {
    const spec = createTestSpec();

    addSchema(spec, "HasOnlyText", {
      type: "object",
      properties: {
        message: {
          type: "string",
          xml: {
            "x-ms-text": true,
          },
        },
      },
    });

    const codeModel = await runModeler(spec);

    assertSchema("HasOnlyText", codeModel.schemas.objects, (o) => o.properties[0].schema.serialization.xml.text, true);

    addSchema(spec, "HasTextAndAttribute", {
      type: "object",
      properties: {
        message: {
          type: "string",
          xml: {
            "x-ms-text": true,
            "attribute": true,
          },
        },
      },
    });

    // Should throw when both 'text' and 'attribute' are true
    await expect(() => runModeler(spec)).rejects.toThrow(
      /XML serialization for a schema cannot be in both 'text' and 'attribute'$/,
    );
  });

  it("converts multipart/form-data schema to operation parameters", async () => {
    const multiPartSchema = {
      type: "object",
      properties: {
        fileContent: {
          type: "string",
          format: "binary",
        },
        fileName: {
          type: "string",
        },
      },
      required: ["fileContent"],
    };

    const spec = createTestSpec();

    addSchema(spec, "MultiPartSchema", {
      type: "object",
      properties: {
        fileContent: {
          type: "string",
          format: "binary",
        },
        fileName: {
          type: "string",
        },
      },
      required: ["fileContent"],
    });

    addOperation(spec, "/upload-file", {
      post: {
        operationId: "uploadFile",
        description: "Upload a file.",
        requestBody: {
          description: "File details",
          required: true,
          content: {
            "multipart/form-data": {
              schema: {
                type: "object",
                properties: {
                  fileContent: {
                    type: "string",
                    format: "binary",
                  },
                  fileName: {
                    type: "string",
                  },
                },
                required: ["fileContent"],
              },
            },
          },
        },
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
        ),
      },
    });

    const codeModel = await runModeler(spec);

    const uploadFile = findByName("uploadFile", codeModel.operationGroups[0].operations);

    const fileContentParam = uploadFile?.requests?.[0].parameters?.[0];
    expect(fileContentParam?.language.default.name).toEqual("fileContent");
    expect(fileContentParam?.required).toEqual(true);
    const fileNameParam = uploadFile?.requests?.[0].parameters?.[1];
    expect(fileNameParam?.language.default.name).toEqual("fileName");
    expect(fileNameParam?.required).toEqual(undefined);
  });

  it("synthesizes accept header based on response media types", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/accept", {
      post: {
        operationId: "receivesAcceptHeader",
        description: "Receives an Accept header.",
        parameters: [],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
          response(400, "application/xml", {
            type: "string",
          }),
        ),
      },
    });

    addOperation(spec, "/hasAccept", {
      post: {
        operationId: "hasAcceptHeader",
        description: "Already has an Accept header.",
        parameters: [
          {
            name: "Accept",
            description: "Existing Accept header",
            in: "header",
            required: true,
            schema: {
              type: "string",
            },
          },
        ],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
          response(400, "application/xml", {
            type: "string",
          }),
        ),
      },
    });

    const codeModel = await runModeler(spec);

    const receivesAcceptHeader = findByName("receivesAcceptHeader", codeModel.operationGroups[0].operations);

    const acceptParam = receivesAcceptHeader?.requests?.[0].parameters?.[0];
    expect(acceptParam!.language.default.serializedName).toEqual("Accept");
    expect(acceptParam!.schema.type).toEqual("constant");
    expect(acceptParam!.origin).toEqual("modelerfour:synthesized/accept");
    expect((<ConstantSchema>acceptParam!.schema).value.value).toEqual("application/json, application/xml");

    const hasAcceptHeader = findByName("hasAcceptHeader", codeModel.operationGroups[0].operations);

    // Make sure that no Accept parameters were added to a request
    expect(hasAcceptHeader!.requests?.length).toEqual(1);
    expect(hasAcceptHeader!.requests?.[0].parameters).toEqual(undefined);

    // Make sure the original Accept parameter is there
    const existingAcceptParam = hasAcceptHeader?.parameters?.[1];
    expect(existingAcceptParam!.language.default.serializedName).toEqual("Accept");
    expect(existingAcceptParam!.origin).toEqual(undefined);
  });

  it("always-seal-x-ms-enum configuration produces SealedChoiceSchema for all x-ms-enums", async () => {
    const spec = createTestSpec();

    addSchema(spec, "ModelAsString", {
      "type": "string",
      "enum": ["Apple", "Orange"],
      "x-ms-enum": {
        modelAsString: true,
      },
    });

    addSchema(spec, "ShouldBeSealed", {
      "type": "string",
      "enum": ["Apple", "Orange"],
      "x-ms-enum": {
        modelAsString: false,
      },
    });

    addSchema(spec, "SingleValueEnum", {
      "type": "string",
      "enum": ["Apple"],
      "x-ms-enum": {
        modelAsString: false,
      },
    });

    const codeModelWithoutSetting = await runModeler(spec, {
      modelerfour: {
        "always-seal-x-ms-enums": false,
      },
    });

    assertSchema("ModelAsString", codeModelWithoutSetting.schemas.choices, (s) => s.choiceType.type, "string");

    assertSchema("ShouldBeSealed", codeModelWithoutSetting.schemas.sealedChoices, (s) => s.choiceType.type, "string");

    assertSchema("SingleValueEnum", codeModelWithoutSetting.schemas.constants, (s) => s.valueType.type, "string");

    const codeModelWithSetting = await runModeler(spec, {
      modelerfour: {
        "always-seal-x-ms-enums": true,
      },
    });

    assertSchema("ModelAsString", codeModelWithSetting.schemas.sealedChoices, (s) => s.choiceType.type, "string");

    assertSchema("ShouldBeSealed", codeModelWithSetting.schemas.sealedChoices, (s) => s.choiceType.type, "string");

    assertSchema("SingleValueEnum", codeModelWithSetting.schemas.sealedChoices, (s) => s.choiceType.type, "string");
  });

  it("allows header parameters with 'x-ms-api-version: true' to become full api-version parameters", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/api-version-header", {
      get: {
        operationId: "apiVersionHeader",
        description: "Has an api-version header.",
        parameters: [
          {
            "name": "api-version",
            "in": "header",
            "required": true,
            "x-ms-api-version": true,
            "schema": {
              type: "string",
            },
          },
        ],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
        ),
      },
    });

    addOperation(spec, "/non-api-version-header", {
      get: {
        operationId: "nonApiVersionHeader",
        description: "Is not an api-version header.",
        parameters: [
          {
            name: "api-version",
            in: "header",
            required: true,
            schema: {
              type: "string",
            },
          },
        ],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
        ),
      },
    });

    addOperation(spec, "/api-version-query", {
      get: {
        operationId: "apiVersionQuery",
        description: "Has an api-version query param.",
        parameters: [
          {
            name: "api-version",
            in: "query",
            required: true,
            schema: {
              type: "string",
            },
          },
        ],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
        ),
      },
    });

    addOperation(spec, "/non-api-version-query", {
      get: {
        operationId: "nonApiVersionQuery",
        description: "An api-version query param that is explicitly not a client api-version.",
        parameters: [
          {
            "name": "api-version",
            "in": "query",
            "required": true,
            "x-ms-api-version": false,
            "schema": {
              type: "string",
            },
          },
        ],
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
        ),
      },
    });

    const codeModel = await runModeler(spec);

    const apiVersionHeader = findByName("apiVersionHeader", codeModel.operationGroups[0].operations);

    const apiVersionHeaderParam = apiVersionHeader?.parameters?.[1];
    expect(apiVersionHeaderParam!.language.default.serializedName).toEqual("api-version");
    expect(apiVersionHeaderParam!.implementation).toEqual("Client");
    expect(apiVersionHeaderParam!.origin).toEqual("modelerfour:synthesized/api-version");

    const nonApiVersionHeader = findByName("nonApiVersionHeader", codeModel.operationGroups[0].operations);

    const nonApiVersionHeaderParam = nonApiVersionHeader?.parameters?.[1];
    expect(nonApiVersionHeaderParam!.language.default.serializedName).toEqual("api-version");
    expect(nonApiVersionHeaderParam!.implementation).toEqual("Method");
    expect(nonApiVersionHeaderParam!.origin).toEqual(undefined);

    const apiVersionQuery = findByName("apiVersionQuery", codeModel.operationGroups[0].operations);

    const apiVersionQueryParam = apiVersionQuery?.parameters?.[1];
    expect(apiVersionQueryParam!.language.default.serializedName).toEqual("api-version");
    expect(apiVersionQueryParam!.implementation).toEqual("Client");
    expect(apiVersionQueryParam!.origin).toEqual("modelerfour:synthesized/api-version");

    const nonApiVersionQuery = findByName("nonApiVersionQuery", codeModel.operationGroups[0].operations);

    const nonApiVersionQueryParam = nonApiVersionQuery?.parameters?.[1];
    expect(nonApiVersionQueryParam!.language.default.serializedName).toEqual("api-version");
    expect(nonApiVersionQueryParam!.implementation).toEqual("Method");
    expect(nonApiVersionQueryParam!.origin).toEqual(undefined);
  });

  it("allows text/plain responses when schema type is 'string'", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/text", {
      post: {
        operationId: "textBody",
        description: "Responds with a plain text string.",
        parameters: [],
        responses: responses(
          response(200, "text/plain", {
            type: "string",
          }),
          response(201, "text/plain; charset=utf-8", {
            type: "string",
          }),
        ),
      },
    });

    const codeModel = await runModeler(spec);

    const textBody = findByName("textBody", codeModel.operationGroups[0].operations);

    const responseNoCharset = textBody?.responses?.[0] as SchemaResponse;
    const responseWithCharset = textBody?.responses?.[1] as SchemaResponse;

    expect(responseNoCharset.protocol.http?.knownMediaType).toEqual("text");
    expect(responseNoCharset.schema?.type).toEqual("string");
    expect(responseWithCharset.protocol.http?.knownMediaType).toEqual("text");
    expect(responseWithCharset.schema?.type).toEqual("string");
  });

  it("ensures unique names for synthesized schemas like ContentType and Accept", async () => {
    const spec = createTestSpec();

    addOperation(spec, "/accept", {
      post: {
        operationId: "receivesAcceptHeader",
        description: "Receives an Accept header.",
        parameters: [],
        requestBody: {
          description: "File details",
          required: true,
          content: {
            "image/png": {
              schema: {
                type: "string",
                format: "binary",
              },
            },
            "image/tiff": {
              schema: {
                type: "string",
                format: "binary",
              },
            },
          },
        },
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
          response(400, "application/xml", {
            type: "string",
          }),
        ),
      },
    });

    addOperation(spec, "/accept1", {
      post: {
        operationId: "accept1",
        parameters: [],
        requestBody: {
          description: "File details",
          required: true,
          content: {
            "image/png": {
              schema: {
                type: "string",
                format: "binary",
              },
            },
            "image/bmp": {
              schema: {
                type: "string",
                format: "binary",
              },
            },
          },
        },
        responses: responses(
          response(200, "application/json", {
            type: "string",
          }),
          response(400, "text/plain", {
            type: "string",
          }),
        ),
      },
    });

    const codeModel = await runModeler(spec, {
      modelerfour: {
        "always-create-content-type-parameter": true,
        "always-create-accept-parameter": true,
      },
    });

    const acceptSchema = findByName("Accept", codeModel.schemas.constants);
    expect((<ConstantSchema>acceptSchema).value.value).toEqual("application/json, application/xml");

    const accept1Schema = findByName("Accept1", codeModel.schemas.constants);
    expect((<ConstantSchema>accept1Schema).value.value).toEqual("application/json, text/plain");

    const contentTypeSchema = findByName("ContentType", codeModel.schemas.sealedChoices);
    expect((<SealedChoiceSchema>contentTypeSchema).choices[0].value).toEqual("image/png");
    expect((<SealedChoiceSchema>contentTypeSchema).choices[1].value).toEqual("image/tiff");
    const choices = (<SealedChoiceSchema>contentTypeSchema).choices.map((c) => c.value).sort();
    expect(choices).toEqual(["image/png", "image/tiff"]);

    const contentType1Schema = findByName("ContentType1", codeModel.schemas.sealedChoices);
    const choices1 = (<SealedChoiceSchema>contentType1Schema).choices.map((c) => c.value).sort();
    expect(choices1).toEqual(["image/bmp", "image/png"]);
  });

  describe("Responses", () => {
    it("include the response description for no content response", async () => {
      const spec = createTestSpec();
      addOperation(spec, "/test", {
        get: {
          responses: {
            "204": {
              description: "Foo bar test description",
            },
          },
        },
      });

      const codeModel = await runModeler(spec);

      const value = codeModel.operationGroups[0]?.operations[0]?.responses?.[0];
      expect(value).not.toBeNull();
      expect(value?.language.default.description).toEqual("Foo bar test description");
    });

    it("include the response description for no schema response", async () => {
      const spec = createTestSpec();
      addOperation(spec, "/test", {
        get: {
          responses: {
            "200": {
              description: "Foo bar test description",
              content: {
                "application/json": { schema: { type: "object" } },
              },
            },
          },
        },
      });

      const codeModel = await runModeler(spec);

      const value = codeModel.operationGroups[0]?.operations[0]?.responses?.[0];
      expect(value).not.toBeNull();
      expect(value?.language.default.description).toEqual("Foo bar test description");
    });
  });
});
