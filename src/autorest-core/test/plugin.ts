import { AutoRest } from '../lib/autorest-core';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { CancellationToken } from "../lib/ref/cancallation";
import { CreateFileUri, ResolveUri } from "../lib/ref/uri";
import { Message } from "../lib/message";
import { AutoRestDotNetPlugin } from "../lib/pipeline/plugins/autorest-dotnet";
import { AutoRestPlugin } from "../lib/pipeline/plugin-endpoint";
import { DataStore } from "../lib/data-store/data-store";
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";

@suite class Plugins {
  @test async "plugin loading and communication"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.CreateScope("input");
    const scopeWork = dataStore.CreateScope("working");

    const dummyPlugin = await AutoRestPlugin.FromModule(`${__dirname}/../lib/pipeline/plugins/dummy`);
    const pluginNames = await dummyPlugin.GetPluginNames(cancellationToken);
    assert.deepStrictEqual(pluginNames, ["dummy"]);
    const messages: Message[] = [];
    const result = await dummyPlugin.Process(
      "dummy",
      key => key,
      scopeInput,
      scopeWork,
      m => messages.push(m),
      cancellationToken);
    assert.strictEqual(result, true);
    assert.strictEqual(messages.length, 1);
    const message = messages[0];
    assert.strictEqual(message.Details, 42);
  }

  // SKIPPING because Amar's tool is resolved hacky right now (waiting for "getting plugin bits to disk part")
  @skip @test @timeout(10000) async "openapi-validation-tools"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.CreateScope("input").AsFileScopeReadThrough();

    const inputFileUri = "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2016-12-01/swagger/network.json";
    await scopeInput.Read(inputFileUri);

    const validationPlugin = await AutoRestPlugin.FromModule("./lib/pipeline/plugins/openapi-validation-tools");
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);
    assert.deepStrictEqual(pluginNames.length, 2);

    for (let pluginIndex = 0; pluginIndex < pluginNames.length; ++pluginIndex) {
      const scopeWork = dataStore.CreateScope(`working_${pluginIndex}`);
      const messages: Message[] = [];
      const result = await validationPlugin.Process(
        pluginNames[pluginIndex], _ => null,
        scopeInput,
        scopeWork.CreateScope("output"),
        m => messages.push(m),
        cancellationToken);
      assert.strictEqual(result, true);
      assert.strictEqual(messages.length, (await scopeInput.Enum()).length);
      const message = messages[0];
    }
  }

  @test @timeout(10000) async "AutoRest.dll AzureValidator"() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    // load swagger
    const swagger = await LoadLiterateSwagger(
      config,
      dataStore.CreateScope("input").AsFileScopeReadThrough(),
      "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2016-12-01/swagger/network.json",
      dataStore.CreateScope("loader"));

    // call validator
    const autorestPlugin = AutoRestDotNetPlugin.Get();
    const pluginScope = dataStore.CreateScope("plugin");
    const messages: Message[] = [];
    const resultScope = await autorestPlugin.Validate(swagger, pluginScope, m => messages.push(m));

    // check results
    assert.notEqual(messages.length, 0);
    for (const message of messages) {
      assert.ok(message);
      assert.ok(message.Details.code);
      assert.ok(message.Text);
      assert.ok(message.Details.jsonref);
      assert.ok(message.Details["json-path"]);
      assert.ok(message.Details.validationCategory);
      assert.strictEqual(message.Plugin, "AzureValidator");
    }
  }

  @test @timeout(10000) async "AutoRest.dll Modeler"() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    // load swagger
    const swagger = await LoadLiterateSwagger(
      config,
      dataStore.CreateScope("input").AsFileScopeReadThrough(),
      "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2016-12-01/swagger/network.json",
      dataStore.CreateScope("loader"));

    // call modeler
    const autorestPlugin = AutoRestDotNetPlugin.Get();
    const pluginScope = dataStore.CreateScope("plugin");
    const codeModelHandle = await autorestPlugin.Model(swagger, pluginScope, { namespace: "SomeNamespace" }, m => null);

    // check results
    const codeModel = await codeModelHandle.ReadData();
    assert.notEqual(codeModel.indexOf("isPolymorphicDiscriminator"), -1);
  }

  @test @timeout(10000) async "AutoRest.dll Generator"() {
    const dataStore = new DataStore(CancellationToken.None);

    // load code model
    const codeModelUri = ResolveUri(CreateFileUri(__dirname) + "/", "resources/code-model.yaml");
    const inputScope = dataStore.CreateScope("input").AsFileScopeReadThrough(uri => uri === codeModelUri);
    const codeModelHandle = await inputScope.ReadStrict(codeModelUri);

    // call generator
    const autorestPlugin = AutoRestDotNetPlugin.Get();
    const pluginScope = dataStore.CreateScope("plugin");
    const resultScope = await autorestPlugin.GenerateCode(
      codeModelHandle,
      pluginScope,
      {
        codeGenerator: "Azure.CSharp",
        namespace: "SomeNamespace",
        header: null,
        payloadFlatteningThreshold: 0,
        internalConstructors: false,
        syncMethods: "essential",
        useDateTimeOffset: false,
        addCredentials: false,
        rubyPackageName: "rubyrubyrubyruby"
      },
      m => null);

    // check results
    const results = await resultScope.Enum();
    assert.notEqual(results.length, 0);
    assert.notEqual(results.map(path => path.startsWith("Models")).length, 0);
    assert.ok(results.every(path => path.endsWith(".cs")));
    console.log(results);
  }

  // SKIPPING because this is using a local path for now
  @test @skip @timeout(0) async "custom plugin module"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.CreateScope("input").AsFileScopeReadThrough();

    const inputFileUri = "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2016-12-01/swagger/network.json";
    await scopeInput.Read(inputFileUri);

    const validationPlugin = await AutoRestPlugin.FromModule("../../../../../Users/jobader/Documents/GitHub/autorest-interactive/index");
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);

    for (let pluginIndex = 0; pluginIndex < pluginNames.length; ++pluginIndex) {
      const scopeWork = dataStore.CreateScope(`working_${pluginIndex}`);
      const result = await validationPlugin.Process(
        pluginNames[pluginIndex], _ => null,
        scopeInput,
        scopeWork.CreateScope("output"),
        m => null,
        cancellationToken);
      assert.strictEqual(result, true);
    }
  }
}