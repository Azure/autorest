/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { matches } from "../lib/ref/jsonpath";
import { MergeOverwriteOrAppend } from "../lib/source-map/merging";
import { AutoRest } from "../main";
import { RealFileSystem } from "../lib/file-system";
import { join } from "path";

@suite class Modifiers {

  private async generate(additionalConfig: any): Promise<{ [uri: string]: string }> {
    const autoRest = new AutoRest(new RealFileSystem());
    // PumpMessagesToConsole(autoRest);
    autoRest.AddConfiguration({
      "input-file": join(__dirname, "..", "..", "test", "resources", "tiny.yaml"),
      "csharp": "true"
    });
    autoRest.AddConfiguration(additionalConfig);

    const result: { [uri: string]: string } = {};

    autoRest.GeneratedFile.Subscribe((sender, args) => {
      if (args.type === "source-file-csharp") {
        result[args.uri.slice("file:///generated/".length)] = args.content;
      }
    });
    const success = await autoRest.Process().finish;
    assert.strictEqual(success, true);

    return result;
  }

  @test async "Reference"() {
    const code = await this.generate({});
    assert.ok(code["CowbellOperationsExtensions.cs"].includes(" Get("));
  }

  @test async "RemoveMethod"() {
    const code = await this.generate({
      "directive": {
        "remove-operation": "Cowbell_Get"
      }
    });
    assert.ok(!code["CowbellOperationsExtensions.cs"].includes(" Get("));
  }
}