/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import assert from "assert";
import { AutoRest, Channel, Message } from "../src/exports";
import { RealFileSystem } from "@azure-tools/datastore";
import { join } from "path";
import { AppRoot } from "../src/lib/constants";
import oai3 from "@azure-tools/openapi";

const generate = async (additionalConfig: any): Promise<oai3.Model> => {
  const autoRest = new AutoRest(new RealFileSystem());
  autoRest.AddConfiguration({
    "input-file": join(AppRoot, "test", "resources", "tiny.yaml"),
    "use-extension": { "@autorest/modelerfour": join(AppRoot, "../modelerfour") },
    "verbose": true,
    "debug": true,
    "output-artifact": ["openapi-document"],
  });
  autoRest.AddConfiguration(additionalConfig);

  let resolvedDocument: oai3.Model | undefined;

  autoRest.GeneratedFile.Subscribe((sender, args) => {
    if (args.type === "openapi-document") {
      resolvedDocument = JSON.parse(args.content);
    }
  });

  const messages: Message[] = [];
  const channels = new Set([
    Channel.Information,
    Channel.Warning,
    Channel.Error,
    Channel.Fatal,
    Channel.Debug,
    Channel.Verbose,
  ]);

  autoRest.Message.Subscribe((_, message) => {
    if (channels.has(message.Channel)) {
      messages.push(message);
    }
  });

  const success = await autoRest.Process().finish;

  if (!success) {
    // eslint-disable-next-line no-console
    console.log("Messages", messages);
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

describe("Modifiers", () => {
  it("Doesn't modify the input if no directives are passed", async () => {
    const code = await generate({});

    expect(findOperation(code, "Cowbell_Get")).toBeDefined();
    expect(findOperation(code, "Cowbell_Retrieve")).toBe(undefined);

    const model = findModel(code, "Cowbell");
    expect(model).toBeDefined();
    expect(model?.properties?.name).toBeDefined();

    expect(findModel(code, "SuperCowbell")).toBe(undefined);
  });

  it("remove an operation", async () => {
    const code = await generate({
      directive: {
        "remove-operation": "Cowbell_Get",
      },
    });

    expect(findOperation(code, "Cowbell_Get")).toBe(undefined);
  });

  it("rename an operation", async () => {
    const code = await generate({
      directive: {
        "rename-operation": {
          from: "Cowbell_Get",
          to: "Cowbell_Retrieve",
        },
      },
    });

    expect(findOperation(code, "Cowbell_Get")).toBe(undefined);
    expect(findOperation(code, "Cowbell_Retrieve")).toBeDefined();
  });

  it("add operation forward", async () => {
    const code = await generate({
      components: {
        operations: [
          {
            "operationId": "Cowbell_Retrieve",
            "forward-to": "Cowbell_Get",
          },
        ],
      },
    });
    expect(findOperation(code, "Cowbell_Get")).toBeDefined();
    const retrieveOperation = findOperation(code, "Cowbell_Retrieve");
    expect(retrieveOperation).toBeDefined();
    expect(retrieveOperation?.["x-ms-forward-to"]).toEqual("Cowbell_Get");
  });

  it("remove a model", async () => {
    const code = await generate({
      directive: [
        { "remove-model": "Cowbell" },
        { "remove-operation": "Cowbell_Get" }, // ...or there will be
        { "remove-operation": "Cowbell_Add" }, // broken references
      ],
    });
    expect(findModel(code, "Cowbell")).toBe(undefined);
  });

  it("rename a model", async () => {
    const code = await generate({
      directive: {
        "rename-model": {
          from: "Cowbell",
          to: "SuperCowbell",
        },
      },
    });

    expect(findModel(code, "Cowbell")).toBe(undefined);
    expect(findModel(code, "SuperCowbell")).toBeDefined();
  });

  it("remove a property", async () => {
    const code = await generate({
      directive: {
        "where-model": "Cowbell",
        "remove-property": "name",
      },
    });

    const model = findModel(code, "Cowbell");
    expect(model?.properties?.name).toBe(undefined);
  });

  it("rename a property", async () => {
    const code = await generate({
      directive: {
        "where-model": "Cowbell",
        "rename-property": {
          from: "name",
          to: "firstName",
        },
      },
    });

    const model = findModel(code, "Cowbell");
    expect(model?.properties?.name).toBe(undefined);
    expect(model?.properties?.firstName).toBeDefined();
  });

  it("remove a header parameter", async () => {
    const code = await generate({
      directive: {
        "where-operation": "Cowbell_Get",
        "remove-parameter": {
          in: "header",
          name: "myHeader",
        },
      },
    });
    expect(findParameter(code, "myHeader")).toEqual(undefined);
    expect(findParameter(code, "id")).toBeDefined();
  });

  it("remove a query parameter", async () => {
    const code = await generate({
      directive: {
        "where": "$.paths..*",
        "remove-parameter": {
          in: "query",
          name: "id",
        },
      },
    });
    expect(findParameter(code, "id")).toEqual(undefined);
    expect(findParameter(code, "myHeader")).toBeDefined();
  });
});
