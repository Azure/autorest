/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from 'assert';
import { PumpMessagesToConsole } from './test-utility';

import { Extension, ExtensionManager } from "@microsoft.azure/extension";
import { RealFileSystem } from "../lib/file-system";
import { AutoRest } from "../lib/autorest-core";
import { CancellationToken } from "../lib/ref/cancellation";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message, Channel } from "../lib/message";
import { AutoRestExtension } from "../lib/pipeline/plugin-endpoint";
import { DataHandle, DataStore, QuickDataSource } from '../lib/data-store/data-store';
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";
import { homedir } from "os";
import { join } from "path";

async function GetAutoRestDotNetPlugin(plugin: string): Promise<AutoRestExtension> {
  const extMgr = await ExtensionManager.Create(join(homedir(), ".autorest"));
  const name = "@microsoft.azure/" + plugin;
  const source = "*";
  const pack = await extMgr.findPackage(name, source);
  const ext = await extMgr.installPackage(pack);
  return AutoRestExtension.FromChildProcess(name, await ext.start());
}

@suite class Plugins {
  // TODO: remodel if we figure out acquisition story
  @test @skip @timeout(0) async "Validation Tools"() {
    const autoRest = new AutoRest(new RealFileSystem());
    autoRest.AddConfiguration({ "input-file": "https://github.com/olydis/azure-rest-api-specs/blob/amar-tests/arm-logic/2016-06-01/swagger/logic.json" });
    autoRest.AddConfiguration({ "model-validator": true });
    autoRest.AddConfiguration({ "semantic-validator": true });
    autoRest.AddConfiguration({ "azure-validator": true });

    const errorMessages: Message[] = [];
    autoRest.Message.Subscribe((_, m) => {
      if (m.Channel === Channel.Error) {
        errorMessages.push(m);
      }
    });
    assert.strictEqual(await autoRest.Process().finish, true);
    const expectedNumErrors = 3;
    if (errorMessages.length !== expectedNumErrors) {
      console.log(JSON.stringify(errorMessages, null, 2));
    }
    assert.strictEqual(errorMessages.length, expectedNumErrors);
  }

  @test @skip @timeout(10000) async "AutoRest.dll Modeler"() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    // load swagger
    const swagger = await LoadLiterateSwagger(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      "https://github.com/Azure/azure-rest-api-specs/blob/fa91f9109c1e9107bb92027924ec2983b067f5ec/arm-network/2016-12-01/swagger/network.json",
      dataStore.getDataSink());

    // call modeler
    const autorestPlugin = await GetAutoRestDotNetPlugin("modeler");
    const results: DataHandle[] = [];
    const result = await autorestPlugin.Process("modeler", key => { return ({ namespace: "SomeNamespace" } as any)[key]; }, new QuickDataSource([swagger]), dataStore.getDataSink(), f => results.push(f), m => null, CancellationToken.None);
    assert.strictEqual(result, true);
    if (results.length !== 1) {
      throw new Error(`Modeler plugin produced '${results.length}' items. Only expected one (the code model).`);
    }

    // check results
    const codeModel = results[0].ReadData();
    assert.notEqual(codeModel.indexOf("isConstant"), -1);
  }

  @test @skip @timeout(10000) async "AutoRest.dll Generator"() {
    const autoRest = new AutoRest(new RealFileSystem());
    autoRest.AddConfiguration({
      namespace: "SomeNamespace",
      "license-header": null,
      "payload-flattening-threshold": 0,
      "add-credentials": false,
      "package-name": "rubyrubyrubyruby"
    });
    const config = await autoRest.view;
    const dataStore = new DataStore(CancellationToken.None);

    // load swagger
    const swagger = await LoadLiterateSwagger(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      "https://github.com/Azure/azure-rest-api-specs/blob/fa91f9109c1e9107bb92027924ec2983b067f5ec/arm-network/2016-12-01/swagger/network.json",
      dataStore.getDataSink());

    // load code model
    const codeModelUri = ResolveUri(CreateFolderUri(__dirname), "../../test/resources/code-model.yaml");
    const inputScope = dataStore.GetReadThroughScope(new RealFileSystem());
    const codeModelHandle = await inputScope.ReadStrict(codeModelUri);

    // call generator
    const autorestPlugin = await GetAutoRestDotNetPlugin("csharp");
    const results: DataHandle[] = [];
    const result = await autorestPlugin.Process(
      "csharp",
      key => config.GetEntry(key as any),
      new QuickDataSource([swagger, codeModelHandle]),
      dataStore.getDataSink(),
      f => results.push(f),
      m => { if (m.Channel === Channel.Fatal) console.log(m.Text); },
      CancellationToken.None);
    assert.strictEqual(result, true);

    // check results
    assert.notEqual(results.length, 0);
    assert.notEqual(results.filter(file => file.Description.indexOf("Models/") !== -1).length, 0);
    assert.ok(results.every(file => file.Description.indexOf(".cs") !== -1));
    console.log(results);
  }

  // SKIPPING because this is using a local path for now
  @test @skip @timeout(0) async "custom plugin module"() {
    const cancellationToken = CancellationToken.None;
    const dataStore = new DataStore(cancellationToken);
    const scopeInput = dataStore.GetReadThroughScope(new RealFileSystem());

    const inputFileUri = "https://github.com/Azure/azure-rest-api-specs/blob/fa91f9109c1e9107bb92027924ec2983b067f5ec/arm-network/2016-12-01/swagger/network.json";
    await scopeInput.Read(inputFileUri);

    const validationPlugin = await AutoRestExtension.FromModule("../../../../../Users/jobader/Documents/GitHub/autorest-interactive/index");
    const pluginNames = await validationPlugin.GetPluginNames(cancellationToken);

    for (let pluginIndex = 0; pluginIndex < pluginNames.length; ++pluginIndex) {
      const result = await validationPlugin.Process(
        pluginNames[pluginIndex], _ => null,
        scopeInput,
        dataStore.getDataSink(),
        f => null,
        m => null,
        cancellationToken);
      assert.strictEqual(result, true);
    }
  }
}