import { createTestSessionFromModel } from "../../test/utils";
import { SecurityProcessor } from "./security-processor";
import oai3, { ParameterLocation, SecurityType } from "@azure-tools/openapi";
import { Interpretations } from "./interpretations";
import { AADTokenSecurityScheme, AzureKeySecurityScheme } from "@autorest/codemodel";

const baseOpenapiSpec = {
  openApi: "3.0.0",
  info: {
    title: "Base spec",
    version: "1.0",
  },
  paths: {},
};

const AADTokenSecuritySchemeDef: oai3.SecurityScheme = {
  "x-ms-metadata": {
    name: "AADToken",
  },
  "type": SecurityType.OAuth2,
  "flows": {
    authorizationCode: {
      authorizationUrl: "https://login.microsoftonline.com/common/v2.0/oauth2/authorize",
      tokenUrl: "https://login.microsoftonline.com/common/v2.0/oauth2/token",
    },
  },
};

const AzureKeySecuritySchemeDef: oai3.SecurityScheme = {
  "x-ms-metadata": {
    name: "AzureKey",
  },
  "type": SecurityType.ApiKey,
  "in": ParameterLocation.Header,
  "name": "my-header-name",
};

async function runSecurity(spec: oai3.Model, config: any = {}) {
  const { session } = await createTestSessionFromModel<oai3.Model>(config, spec);
  const securityProcessor = await new SecurityProcessor(session, new Interpretations(session)).init();

  return securityProcessor.process(spec);
}

describe("Security Processor", () => {
  describe("when no security is defined", () => {
    it("should mark authentication required as false", async () => {
      const security = await runSecurity(baseOpenapiSpec);
      expect(security.authenticationRequired).toBe(false);
    });
  });

  describe("when defined in OpenAPI Spec", () => {
    it("configure AAD token security", async () => {
      const security = await runSecurity({
        ...baseOpenapiSpec,
        components: {
          securitySchemes: {
            AADToken: AADTokenSecuritySchemeDef,
          },
        },
        security: [{ AADToken: ["https://myresource.com/.default"] }],
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] })]);
    });

    it("configure Azure Key security", async () => {
      const security = await runSecurity({
        ...baseOpenapiSpec,
        components: {
          securitySchemes: {
            AzureKey: AzureKeySecuritySchemeDef,
          },
        },
        security: [{ AzureKey: [] }],
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([new AzureKeySecurityScheme({ headerName: "my-header-name" })]);
    });

    it("configure multiple security", async () => {
      const security = await runSecurity({
        ...baseOpenapiSpec,
        components: {
          securitySchemes: {
            AADToken: AADTokenSecuritySchemeDef,
            AzureKey: AzureKeySecuritySchemeDef,
          },
        },
        security: [{ AADToken: ["https://myresource.com/.default"] }, { AzureKey: [] }],
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([
        new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] }),
        new AzureKeySecurityScheme({ headerName: "my-header-name" }),
      ]);
    });

    it("configure anymous security with other security", async () => {
      const security = await runSecurity({
        ...baseOpenapiSpec,
        components: {
          securitySchemes: {
            AADToken: AADTokenSecuritySchemeDef,
          },
        },
        security: [{ AADToken: ["https://myresource.com/.default"] }, {}],
      });

      expect(security.authenticationRequired).toBe(false);
      expect(security.schemes).toEqual([new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] })]);
    });

    it("raise an error if referencing undefined security scheme", async () => {
      await expect(() =>
        runSecurity({
          ...baseOpenapiSpec,
          components: {
            securitySchemes: {
              AADToken: AADTokenSecuritySchemeDef,
            },
          },
          security: [{ ThisIsNotDefined: ["https://myresource.com/.default"] }, {}],
        }),
      ).rejects.toThrowError("Couldn't find a scheme defined in the securitySchemes with name: ThisIsNotDefined");
    });
  });

  describe("when defined in autorest configuration", () => {
    it("configure AAD token security", async () => {
      const security = await runSecurity(baseOpenapiSpec, {
        "security": ["AADToken"],
        "security-scopes": ["https://myresource.com/.default"],
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] })]);
    });

    it("configure Azure Key security", async () => {
      const security = await runSecurity(baseOpenapiSpec, {
        "security": ["AzureKey"],
        "security-header-name": "my-header-name",
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([new AzureKeySecurityScheme({ headerName: "my-header-name" })]);
    });

    it("configure multiple security", async () => {
      const security = await runSecurity(baseOpenapiSpec, {
        "security": ["AADToken", "AzureKey"],
        "security-scopes": ["https://myresource.com/.default"],
        "security-header-name": "my-header-name",
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([
        new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] }),
        new AzureKeySecurityScheme({ headerName: "my-header-name" }),
      ]);
    });

    it("configure anymous security with other security", async () => {
      const security = await runSecurity(baseOpenapiSpec, {
        "security": ["AADToken", "Anonymous"],
        "security-scopes": ["https://myresource.com/.default"],
      });

      expect(security.authenticationRequired).toBe(false);
      expect(security.schemes).toEqual([new AADTokenSecurityScheme({ scopes: ["https://myresource.com/.default"] })]);
    });

    it("raise an error if passing unknown security scheme", async () => {
      await expect(() =>
        runSecurity(baseOpenapiSpec, {
          security: ["this-is-unknown"],
        }),
      ).rejects.toThrowError(
        "Unexpected security scheme 'this-is-unknown'. Only known schemes are AADToken,AzureKey,Anonymous",
      );
    });
  });

  describe("when using --azure-arm flag", () => {
    it("configure AAD token security", async () => {
      const security = await runSecurity(baseOpenapiSpec, {
        "azure-arm": true,
      });

      expect(security.authenticationRequired).toBe(true);
      expect(security.schemes).toEqual([
        new AADTokenSecurityScheme({ scopes: ["https://management.azure.com/.default"] }),
      ]);
    });
  });
});
