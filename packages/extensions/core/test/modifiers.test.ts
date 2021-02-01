/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import * as assert from "assert";

import { AutoRest } from "../src/exports";
import { RealFileSystem } from "@azure-tools/datastore";
import { join } from "path";
import { AppRoot } from "../src/lib/constants";

const generate = async (additionalConfig: any): Promise<{ [uri: string]: string }> => {
  const autoRest = new AutoRest(new RealFileSystem());
  autoRest.AddConfiguration({
    "input-file": join(AppRoot, "test", "resources", "tiny.yaml"),
    "csharp": "true",
    "output-artifact": ["swagger-document.yaml", "openapi-document.yaml"],
  });
  // for testing local changes:
  /* if (false as any) {
      PumpMessagesToConsole(autoRest);
      autoRest.AddConfiguration({ 'use': 'C:\\work\\oneautorest\\autorest.modeler' });
      autoRest.AddConfiguration({ 'use': 'C:\\work\\oneautorest\\autorest.csharp' });
    } */

  autoRest.AddConfiguration(additionalConfig);

  const result: { [uri: string]: string } = {};

  autoRest.GeneratedFile.Subscribe((sender, args) => {
    if (args.type === "source-file-csharp") {
      result[args.uri.slice("file:///generated/".length)] = args.content;
    }
    if (args.type === "swagger-document.yaml" || args.type === "openapi-document.yaml") {
      // console.warn(args.content);
    }
  });
  const success = await autoRest.Process().finish;
  assert.strictEqual(success, true);

  return result;
};

describe("Modifiers", () => {
  it("Reference", async () => {
    const code = await generate({});
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
    assert.ok(!code["CowbellOperations.cs"].includes(".GetWith"));
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(!code["Models/Cowbell.cs"].includes("string FirstName"));
    assert.ok(code["Models/Cowbell.cs"].includes("JsonProperty"));
    assert.ok(!code["Models/Cowbell.cs"].includes("JsonIgnore"));
    assert.ok(!code["Models/SuperCowbell.cs"]);
  });

  it("RemoveOperation", async () => {
    const code = await generate({
      directive: {
        "remove-operation": "Cowbell_Get",
      },
    });
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
  });

  it("RenameOperation", async () => {
    const code = await generate({
      directive: {
        "rename-operation": {
          from: "Cowbell_Get",
          to: "Cowbell_Retrieve",
        },
      },
    });
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
  });

  it("AddOperationForward", async () => {
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
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
    assert.ok(code["CowbellOperations.cs"].includes(".GetWith"));
  });

  it("AddOperationImpl", async () => {
    const implementation = "// implement me " + Math.random();
    const code = await generate({
      components: {
        operations: [
          {
            operationId: "Cowbell_Retrieve",
            implementation: implementation,
          },
        ],
      },
    });
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
    assert.ok(!code["CowbellOperations.cs"].includes(".GetWith"));
    assert.ok(code["CowbellOperations.cs"].includes(implementation));
  });

  it("RemoveModel", async () => {
    const code = await generate({
      directive: [
        { "remove-model": "Cowbell" },
        { "remove-operation": "Cowbell_Get" }, // ...or there will be
        { "remove-operation": "Cowbell_Add" }, // broken references
      ],
    });
    assert.ok(!code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/SuperCowbell.cs"]);
  });

  it("RenameModel", async () => {
    const code = await generate({
      directive: {
        "rename-model": {
          from: "Cowbell",
          to: "SuperCowbell",
        },
      },
    });
    assert.ok(!code["Models/Cowbell.cs"]);
    assert.ok(code["Models/SuperCowbell.cs"]);
    assert.ok(code["Models/SuperCowbell.cs"].includes("string Name"));
  });

  it("RemoveProperty", async () => {
    const code = await generate({
      directive: {
        "where-model": "Cowbell",
        "remove-property": "name",
      },
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/Cowbell.cs"].includes("string Name"));
  });

  it("RenameProperty", async () => {
    const code = await generate({
      directive: {
        "where-model": "Cowbell",
        "rename-property": {
          from: "name",
          to: "firstName",
        },
      },
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(code["Models/Cowbell.cs"].includes("string FirstName"));
  });

  // GS01 / Nelson -- this fails because the deduplicator assumes that we have xms metadata on paths
  xit("AddPropertyForward", async () => {
    const code = await generate({
      components: {
        schemas: {
          Cowbell: {
            properties: {
              firstName: {
                "type": "string",
                "forward-to": "name",
              },
            },
          },
        },
      },
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(code["Models/Cowbell.cs"].includes("string FirstName"));
    assert.ok(code["Models/Cowbell.cs"].includes("= value;"));
    assert.ok(code["Models/Cowbell.cs"].includes("JsonProperty"));
    assert.ok(code["Models/Cowbell.cs"].includes("JsonIgnore"));
  });

  // GS01 / Nelson -- this fails because the deduplicator assumes that we have xms metadata on paths
  xit("AddPropertyImpl", async () => {
    const implementation = "get; set; // implement me " + Math.random();
    const code = await generate({
      components: {
        schemas: {
          Cowbell: {
            properties: {
              firstName: {
                type: "string",
                implementation: implementation,
              },
            },
          },
        },
      },
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(code["Models/Cowbell.cs"].includes("string FirstName"));
    assert.ok(code["Models/Cowbell.cs"].includes(implementation));
    assert.ok(code["Models/Cowbell.cs"].includes("JsonProperty"));
    assert.ok(code["Models/Cowbell.cs"].includes("JsonIgnore"));
  });
});
