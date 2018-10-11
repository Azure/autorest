import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";
import { CreateConfiguration } from "../legacyCli";
import { DataStore } from "../lib/data-store/data-store"
import { RealFileSystem } from "../lib/file-system";
import { Channel, Message } from "../lib/message";

@suite class SwaggerLoading {
  @test async "external reference resolving"() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const swaggerFile = await LoadLiterateSwagger(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/087554c4480e144f715fe92f97621ff5603cd907/specification/network/resource-manager/Microsoft.Network/2016-12-01/applicationGateway.json",
      dataStore.getDataSink());
    const swaggerObj = swaggerFile.ReadObject<any>();

    // check presence of SubResource (imported from "./network.json")
    assert.strictEqual(swaggerObj.definitions.SubResource != null, true);
  }

  @test async "composite Swagger"() {
    const dataStore = new DataStore();

    const config = await CreateConfiguration("file:///", dataStore.GetReadThroughScope(new RealFileSystem()),
      [
        "-i", "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/a2b46f557c6a17a95777a8a2f380cfecb9dac28e/arm-network/compositeNetworkClient.json",
        "-m", "CompositeSwagger",
        "-g", "None"
      ]);
    assert.strictEqual((config["input-file"] as any).length, 18);
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
