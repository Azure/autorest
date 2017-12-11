/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from 'assert';

import { PumpMessagesToConsole } from './test-utility';
import { matches } from "../lib/ref/jsonpath";
import { MergeOverwriteOrAppend } from "../lib/source-map/merging";
import { AutoRest } from "../main";
import { RealFileSystem } from "../lib/file-system";
import { join } from "path";

@suite class Modifiers {

  private async generate(additionalConfig: any): Promise<{ [uri: string]: string }> {
    const autoRest = new AutoRest(new RealFileSystem());
    autoRest.AddConfiguration({
      "input-file": join(__dirname, "..", "..", "test", "resources", "tiny.yaml"),
      "csharp": "true",
      "output-artifact": ["swagger-document.yaml", "openapi-document.yaml"]
    });
    // for testing local changes:
    if (true) {
      PumpMessagesToConsole(autoRest);
      autoRest.AddConfiguration({ "use": "C:\\work\\oneautorest\\autorest.modeler" });
      autoRest.AddConfiguration({ "use": "C:\\work\\oneautorest\\autorest.csharp" });
    }
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
  }

  @test async "Reference"() {
    const code = await this.generate({});
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(".Get("));
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(!code["Models/SuperCowbell.cs"]);
  }

  @test async "RemoveOperation"() {
    const code = await this.generate({
      "directive": {
        "remove-operation": "Cowbell_Get"
      }
    });
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
  }

  @test async "RenameOperation"() {
    const code = await this.generate({
      "directive": {
        "rename-operation": {
          from: "Cowbell_Get",
          to: "Cowbell_Retrieve"
        }
      }
    });
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
  }

  @test async "AddOperation"() {
    const code = await this.generate({
      "components": {
        "operations": [
          {
            operationId: "Cowbell_Retrieve",
            "forward-to": "Cowbell_Get"
          }
        ]
      }
    });
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Retrieve("));
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(".Get("));
  }

  @test async "RemoveModel"() {
    const code = await this.generate({
      "directive": [
        { "remove-model": "Cowbell" },
        { "remove-operation": "Cowbell_Get" }, // ...or there will be
        { "remove-operation": "Cowbell_Add" }  // broken references
      ]
    });
    assert.ok(!code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/SuperCowbell.cs"]);
  }

  @test async "RenameModel"() {
    const code = await this.generate({
      "directive": {
        "rename-model": {
          from: "Cowbell",
          to: "SuperCowbell"
        }
      }
    });
    assert.ok(!code["Models/Cowbell.cs"]);
    assert.ok(code["Models/SuperCowbell.cs"]);
    assert.ok(code["Models/SuperCowbell.cs"].includes("string Name"));
  }

  @test async "RemoveProperty"() {
    const code = await this.generate({
      "directive": {
        "where-model": "Cowbell",
        "remove-property": "name"
      }
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/Cowbell.cs"].includes("string Name"));
  }

  @test async "RenameProperty"() {
    const code = await this.generate({
      "directive": {
        "where-model": "Cowbell",
        "rename-property": {
          from: "name",
          to: "firstName"
        }
      }
    });
    assert.ok(code["Models/Cowbell.cs"]);
    assert.ok(!code["Models/Cowbell.cs"].includes("string Name"));
    assert.ok(code["Models/Cowbell.cs"].includes("string FirstName"));
  }
}