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
    const producedFiles = Array.from(await scopeWork.Enum());
    assert.strictEqual(producedFiles.length, 1);
    const fileHandle = await scopeWork.Read(producedFiles[0]);
    if (fileHandle === null) {
      throw new Error("Could not retrieve file.");
    }
    const message = await fileHandle.ReadObject<Message<number>>();
    assert.strictEqual(message.payload, 42);
  }
}