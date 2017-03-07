import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { DataStore } from "../lib/data-store/data-store";
import { LoadLiterateSwagger } from "../lib/pipeline/pipeline";

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
}