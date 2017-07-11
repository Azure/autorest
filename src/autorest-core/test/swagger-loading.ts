// polyfills for language support 
require("../lib/polyfill.min.js");

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";
import { CreateConfiguration } from "../legacyCli";
import { DataStore } from "../lib/data-store/data-store"
import { RealFileSystem } from "../lib/file-system";
import { Channel, Message } from "../lib/message";

@suite class SwaggerLoading {
  @test @timeout(0) async "external reference resolving"() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const swaggerFile = await LoadLiterateSwagger(
      config,
      dataStore.GetReadThroughScope(),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-network/2016-12-01/swagger/applicationGateway.json",
      dataStore.CreateScope("work"));
    const swaggerObj = swaggerFile.ReadObject<any>();

    // check presence of SubResource (imported from "./network.json")
    assert.strictEqual(swaggerObj.definitions.SubResource != null, true);
  }

  @test @timeout(0) async "composite Swagger"() {
    const dataStore = new DataStore();

    const config = await CreateConfiguration("file:///", dataStore.GetReadThroughScope(),
      [
        "-i", "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-network/compositeNetworkClient.json",
        "-m", "CompositeSwagger"
      ]);
    assert.strictEqual(config["input-file"].length, 16);
    const autoRest = new AutoRest(new RealFileSystem());
    await autoRest.AddConfiguration(config);

    const messages: Message[] = [];

    autoRest.Message.Subscribe((_, m) => { messages.push(m); });
    // PumpMessagesToConsole(autoRest);
    assert.equal(await autoRest.Process().finish, true);
    // flag any fatal errors
    assert.equal(messages.filter(m => m.Channel === Channel.Fatal).length, 0);
    assert.notEqual(messages.length, 0);
  }
}
