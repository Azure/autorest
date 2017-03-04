import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRestPlugin } from "../lib/pipeline/plugin-server";
import { CancellationToken } from "../lib/approved-imports/cancallation";
import { DataStore } from "../lib/data-store/dataStore";

@suite class Plugins {
  @test async "plugin loading and communication"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.createScope("input");
    const scopeWork = dataStore.createScope("working");

    const dummyPlugin = await AutoRestPlugin.fromModule("./in-proc-plugins/dummy");
    const pluginNames = await dummyPlugin.GetPluginNames(cancellationToken);
    assert.equal(pluginNames, ["dummy"]);
    const result = await dummyPlugin.Process("dummy", key => key, scopeInput, scopeWork, cancellationToken);
    const producedFiles = Array.from(await scopeWork.enum());
    assert.equal(producedFiles.length, 1);
  }
}