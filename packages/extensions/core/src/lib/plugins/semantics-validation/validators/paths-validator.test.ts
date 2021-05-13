import oai3, { ParameterLocation } from "@azure-tools/openapi";
import { SemanticErrorCodes } from "../types";
import { validatePaths } from "./paths-validator";

const baseModel: oai3.Model = {
  info: {
    title: "Semantic Validation Unit Tests",
    version: "1.0",
  },
  openApi: "3.0.0",
  paths: {},
};

const OkResponse = {
  200: {
    description: "Ok.",
  },
};

describe("Semantic Validation > Paths", () => {
  it("resolve error if path parameter is empty", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{}/empty/param": {},
      },
    });

    expect(errors).toEqual([
      {
        level: "error",
        code: SemanticErrorCodes.PathParameterEmtpy,
        message: "A path parameter in uri /my/{}/empty/param is empty.",
        params: { uri: "/my/{}/empty/param" },
        path: ["paths", "/my/{}/empty/param"],
      },
    ]);
  });

  it("resolve error if path parameter is not defined in parameters", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{myMissingParam}/foo": {
          get: {
            responses: OkResponse,
          },
        },
      },
    });

    expect(errors).toEqual([
      {
        level: "error",
        code: SemanticErrorCodes.PathParameterMissingDefinition,
        message:
          "Path parameter 'myMissingParam' referenced in path '/my/{myMissingParam}/foo' needs to be defined in every operation at either the path or operation level. (Missing in 'get')",
        params: { methods: ["get"], paramName: "myMissingParam", uri: "/my/{myMissingParam}/foo" },
        path: ["paths", "/my/{myMissingParam}/foo"],
      },
    ]);
  });

  it("resolve error if path parameter is missing in certain methods", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{myMissingParam}/foo": {
          get: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Path, name: "myMissingParam" }],
          },
          post: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Query, name: "myMissingParam" }],
          },
          put: {
            responses: OkResponse,
          },
        },
      },
    });

    expect(errors).toEqual([
      {
        level: "error",
        code: SemanticErrorCodes.PathParameterMissingDefinition,
        message:
          "Path parameter 'myMissingParam' referenced in path '/my/{myMissingParam}/foo' needs to be defined in every operation at either the path or operation level. (Missing in 'post', 'put')",
        params: { methods: ["post", "put"], paramName: "myMissingParam", uri: "/my/{myMissingParam}/foo" },
        path: ["paths", "/my/{myMissingParam}/foo"],
      },
    ]);
  });

  it("succeeed if path parameter is present at the path level", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{myMissingParam}/foo": {
          parameters: [{ in: ParameterLocation.Path, name: "myMissingParam" }],
          get: {
            responses: OkResponse,
          },
          post: {
            responses: OkResponse,
          },
        },
      },
    });

    expect(errors).toHaveLength(0);
  });

  it("succeeed if path parameter is present in all methods", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{myMissingParam}/foo": {
          get: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Path, name: "myMissingParam" }],
          },
          post: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Path, name: "myMissingParam" }],
          },
        },
      },
    });

    expect(errors).toHaveLength(0);
  });

  it("succeeed if path parameter when using mixed global and per method paarams", () => {
    const errors = validatePaths({
      ...baseModel,
      paths: {
        "/my/{myMissingParam}/foo/{otherMissingParam}": {
          parameters: [{ in: ParameterLocation.Path, name: "myMissingParam" }],
          get: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Path, name: "otherMissingParam" }],
          },
          post: {
            responses: OkResponse,
            parameters: [{ in: ParameterLocation.Path, name: "otherMissingParam" }],
          },
        },
      },
    });

    expect(errors).toHaveLength(0);
  });
});
