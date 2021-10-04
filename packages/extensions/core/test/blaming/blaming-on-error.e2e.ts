/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { join } from "path";
import { inspect } from "util";
import { LogInfo } from "@autorest/common";
import { AutorestRawConfiguration } from "@autorest/configuration";
import { AutorestTestLogger } from "@autorest/test-utils";
import { RealFileSystem } from "@azure-tools/datastore";
import { createFileUri } from "@azure-tools/uri";
import { AutoRest } from "../../src/exports";
import { AutorestContextLoader } from "../../src/lib/context";

function getResource(name: string) {
  return join(__dirname, "resources", name);
}

async function generate(config: AutorestRawConfiguration): Promise<{ errors: LogInfo[] }> {
  const logger = new AutorestTestLogger();

  const autoRest = new AutoRest(logger, new RealFileSystem());
  autoRest.AddConfiguration({
    verbose: true,
    // debug: true,
    "output-artifact": ["openapi-document"],
    ...config,
  });

  const success = await autoRest.Process().finish;
  await AutorestContextLoader.shutdown();

  if (success === true) {
    // eslint-disable-next-line no-console
    console.log("Messages", logger.logs.all);
    throw new Error("Autorest complete with success but should have failed.");
  }
  const errors = logger.logs.error;
  if (errors.length === 0) {
    // eslint-disable-next-line no-console
    console.log("Messages", logger.logs.all);
    throw new Error("Autorest should have logged errors");
  }
  return { errors };
}

describe("Blaming (e2e)", () => {
  describe("When working in configs", () => {
    it("find original position of duplicate key error in config", async () => {
      const file = getResource("error-in-config/duplicate-key-yaml.md");
      const { errors } = await generate({ require: [file] });
      expect(errors).toHaveLength(2);

      expect(errors[0].message).toEqual("Syntax Error Encountered:  Syntax error: duplicate key");
      expect(errors[0].source).toEqual([
        {
          position: { column: 1, line: 10 },
          document: createFileUri(file),
        },
      ]);
    });

    it("find original position of invalid yaml indent error in config", async () => {
      const file = getResource("error-in-config/invalid-indent-yaml.md");
      const { errors } = await generate({ require: [file] });
      expect(errors).toHaveLength(3);
      expect(errors[0].message).toEqual("Syntax Error Encountered:  Syntax error: bad indentation of a mapping entry");
      expect(errors[0].source).toEqual([
        {
          position: { column: 1, line: 11 },
          document: createFileUri(file),
        },
      ]);
    });
  });

  describe("specs errors", () => {
    it("find original position when error in Swagger 2.0 schema", async () => {
      const file = getResource("error-in-spec/swagger-schema-error.json");
      const { errors } = await generate({ "input-file": [file] });
      expect(errors).toHaveLength(1);

      expect(errors[0].message).toEqual(
        [
          "Schema violation: must NOT have additional properties (definitions > MyDefinitionWithError)",
          "  additionalProperty: unknownProperty",
        ].join("\n"),
      );
      expect(errors[0].source).toEqual([
        {
          position: { column: 5, line: 12 },
          document: createFileUri(file),
        },
      ]);
    });

    it("find original position when error in OpenAPI 3.0 schema", async () => {
      const file = getResource("error-in-spec/openapi-schema-error.json");
      const { errors } = await generate({ "input-file": [file] });
      expect(errors).toHaveLength(1);

      expect(errors[0].message).toEqual(
        [
          "Schema violation: must NOT have additional properties (components > schemas > MySchemaWithError)",
          "  additionalProperty: unknownProperty",
        ].join("\n"),
      );
      expect(errors[0].source).toEqual([
        {
          position: { column: 7, line: 11 },
          document: createFileUri(file),
        },
      ]);
    });

    it("find original position when error in Swagger 2.0 semantic(after converting to OAI3)", async () => {
      const file = getResource("error-in-spec/swagger-semantic-error.json");
      const { errors } = await generate({ "input-file": [file] });
      expect(errors).toHaveLength(1);

      expect(errors[0].message).toEqual(
        [
          "Semantic violation: Path parameter 'missingParam' referenced in path '/test/{missingParam}' needs to be defined in every operation at either the path or operation level. (Missing in 'get') (paths > /test/{missingParam})",
          `  **paramName**: ${inspect("missingParam", { colors: true })}`,
          `  **uri**: ${inspect("/test/{missingParam}", { colors: true })}`,
          `  **methods**: ${inspect(["get"], { colors: true })}`,
        ].join("\n"),
      );
      expect(errors[0].source).toEqual([
        {
          position: { line: 11, column: 5 },
          document: createFileUri(file),
        },
      ]);
    });
  });
});
