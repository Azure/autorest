/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import assert from "assert";
import { join } from "path";
import { AutorestTestLogger } from "@autorest/test-utils";
import { RealFileSystem } from "@azure-tools/datastore";
import oai3 from "@azure-tools/openapi";
import { AutoRest } from "../src/exports";
import { AppRoot } from "../src/lib/constants";

const generate = async (additionalConfig: any): Promise<oai3.Model> => {
  const logger = new AutorestTestLogger();
  const autoRest = new AutoRest(logger, new RealFileSystem());
  autoRest.AddConfiguration({
    "input-file": join(AppRoot, "test", "resources", "final-state-schema", "networkcloud.json"),
    "use-extension": { "@autorest/modelerfour": join(AppRoot, "../modelerfour") },
    verbose: true,
    debug: true,
    "output-artifact": ["openapi-document"],
  });
  autoRest.AddConfiguration(additionalConfig);

  let resolvedDocument: oai3.Model | undefined;

  autoRest.GeneratedFile.Subscribe((sender, args) => {
    if (args.type === "openapi-document") {
      resolvedDocument = JSON.parse(args.content);
    }
  });

  const success = await autoRest.Process().finish;

  if (!success) {
    // eslint-disable-next-line no-console
    console.log("Messages", logger.logs.all);
    throw new Error("Autorest didn't complete with success.");
  }

  assert(resolvedDocument);
  return resolvedDocument;
};

const findModel = (spec: oai3.Model, name: string): oai3.Schema | undefined => {
  return Object.values(spec.components?.schemas ?? [])
    .filter((x) => !("$ref" in x))
    .find((schema: oai3.Schema) => schema["x-ms-metadata"].name === name);
};

const findOperation = (spec: oai3.Model, name: string): oai3.HttpOperation | undefined => {
  for (const pathItem of Object.values(spec.paths)) {
    for (const operation of Object.values(pathItem)) {
      if (operation.operationId === name) {
        return operation;
      }
    }
  }

  for (const pathItem of Object.values(spec["x-ms-paths"] ?? [])) {
    for (const operation of Object.values(pathItem as object)) {
      if (operation.operationId === name) {
        return operation;
      }
    }
  }
  return undefined;
};

const findParameter = (spec: oai3.Model, name: string): oai3.Parameter | undefined => {
  return Object.values((spec.components?.parameters as Record<string, oai3.Parameter>) ?? [])
    .filter((x) => !("$ref" in x))
    .find((parameter: oai3.Parameter) => parameter.name === name);
};

describe("final-state-schema", () => {
  it("Correctly processes final-state-schema with external ref", async () => {
    const code = await generate({});

    const operation = findOperation(code, "BareMetalMachines_Cordon");
    expect(operation).toBeDefined();

    const finalStateSchema = operation?.["x-ms-long-running-operation-options"]?.["final-state-schema"];
    expect(finalStateSchema).toBeDefined();

    const schemaName = finalStateSchema?.split("/").pop();
    expect(code.components?.schemas?.[schemaName]).toBeDefined();
  });
});
