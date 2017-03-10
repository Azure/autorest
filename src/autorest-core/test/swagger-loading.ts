import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { DataStore } from "../lib/data-store/data-store";
import { RunPipeline } from "../lib/pipeline/pipeline";
import { LoadLiterateSwagger } from "../lib/pipeline/swagger-loader";
import { CreateConfiguration } from "../legacyCli";
import { Stringify } from "../lib/approved-imports/yaml";
import { MultiPromiseUtility } from "../lib/approved-imports/multi-promise";

@suite class SwaggerLoading {
  @test @timeout(0) async "external reference resolving"() {
    const dataStore = new DataStore();
    const swaggerFile = await LoadLiterateSwagger(
      dataStore.CreateScope("input").AsFileScopeReadThrough(),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-network/2016-12-01/swagger/applicationGateway.json",
      dataStore.CreateScope("work"));
    const swaggerObj = await swaggerFile.ReadObject<any>();

    // check presence of SubResource (imported from "./network.json")
    assert.strictEqual(swaggerObj.definitions.SubResource != null, true);
  }

  @test @timeout(0) async "composite Swagger"() {
    const dataStore = new DataStore();

    const config = await CreateConfiguration(dataStore.CreateScope("input").AsFileScopeReadThrough(),
      [
        "-i", "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-network/compositeNetworkClient.json",
        "-m", "CompositeSwagger"
      ]);
    assert.strictEqual(config["input-file"].length, 16);

    const configFileUri = "file:///config.yaml";

    // input
    const inputView = dataStore.CreateScope("input").AsFileScope();
    const hwConfig = await inputView.Write(configFileUri);
    await hwConfig.WriteData(Stringify(config));

    const outputData = await RunPipeline(configFileUri, dataStore);
    const file = MultiPromiseUtility.getSingle(outputData["swagger"]);


  }
}