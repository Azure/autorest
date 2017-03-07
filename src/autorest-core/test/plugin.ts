import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { Message } from "../lib/pipeline/plugin-api";
import { AutoRestPlugin } from "../lib/pipeline/plugin-server";
import { CancellationToken } from "../lib/approved-imports/cancallation";
import { DataStore } from "../lib/data-store/data-store";

@suite class Plugins {
  @test async "plugin loading and communication"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.CreateScope("input");
    const scopeWork = dataStore.CreateScope("working");

    const dummyPlugin = await AutoRestPlugin.FromModule("./lib/pipeline/plugins/dummy");
    const pluginNames = await dummyPlugin.GetPluginNames(cancellationToken);
    assert.deepStrictEqual(pluginNames, ["dummy"]);
    const result = await dummyPlugin.Process("dummy", key => key, scopeInput, scopeWork, cancellationToken);
    assert.strictEqual(result, true);
    const producedFiles = await scopeWork.Enum();
    assert.strictEqual(producedFiles.length, 1);
    const fileHandle = await scopeWork.Read(producedFiles[0]);
    if (fileHandle === null) {
      throw new Error("Could not retrieve file.");
    }
    const message = await fileHandle.ReadObject<Message<number>>();
    assert.strictEqual(message.payload, 42);
  }

  @test @timeout(10000) async "validation"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.CreateScope("input").AsFileScopeReadThrough();
    const scopeWork1 = dataStore.CreateScope("working1");
    const scopeWork2 = dataStore.CreateScope("working2");

    const inputFileUri = "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2016-12-01/swagger/network.json";
    await scopeInput.Read(inputFileUri);

    const validationPlugin = await AutoRestPlugin.FromModule("./lib/pipeline/plugins/openapi-validation-tools");
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);
    assert.deepStrictEqual(pluginNames.length, 2);
    {
      const result = await validationPlugin.Process(pluginNames[0], _ => null, scopeInput, scopeWork1, cancellationToken);
      assert.strictEqual(result, true);
      const producedFiles = await scopeWork1.Enum();
      assert.strictEqual(producedFiles.length, (await scopeInput.Enum()).length);
    }
    {
      const result = await validationPlugin.Process(pluginNames[1], _ => null, scopeInput, scopeWork2, cancellationToken);
      assert.strictEqual(result, true);
      const producedFiles = await scopeWork2.Enum();
      assert.strictEqual(producedFiles.length, (await scopeInput.Enum()).length);
    }
  }
}