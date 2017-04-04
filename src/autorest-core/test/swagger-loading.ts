// polyfills for language support 
require("../lib/polyfill.min.js");

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";

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

  /*
    @test @timeout(0) async "composite Swagger"() {
      const dataStore = new DataStore();
  
      const config = await CreateConfiguration("file:///", dataStore.AsFileScopeReadThrough(),
        [
          "-i", "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-network/compositeNetworkClient.json",
          "-m", "CompositeSwagger"
        ]);
      assert.strictEqual(config["input-file"].length, 16);
  
      // load Swaggers
      const configMgr = await  Configuration.Create("file:///config.yaml",config )
      const swaggers = await LoadLiterateSwaggers(
        dataStore.AsFileScopeReadThrough(),
        configMgr.inputFileUris, dataStore.CreateScope("loader"));
  
      // compose Swaggers
      const swagger = await ComposeSwaggers({}, swaggers, dataStore.CreateScope("compose"), true);
    }
  */
}
