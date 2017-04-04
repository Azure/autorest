// polyfills for language support 
require("../lib/polyfill.min.js");

import { Delay } from '../lib/sleep';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message } from "../lib/message";

/*@suite */ class Cancellation {
  private async CreateLongRunningAutoRest(): Promise<AutoRest> {
    const autoRest = new AutoRest(new RealFileSystem());
    await autoRest.AddConfiguration({
      "input-file": [
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/applicationGateway.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/checkDnsAvailability.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/expressRouteCircuit.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/loadBalancer.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/network.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/networkInterface.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/networkSecurityGroup.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/networkWatcher.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/publicIpAddress.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/routeFilter.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/routeTable.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/serviceCommunity.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/usage.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/virtualNetwork.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/virtualNetworkGateway.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/arm-network/2017-03-01/swagger/vmssNetworkInterface.json"]
    });
    return autoRest;
  }

  private async TestCancellationAfter(delay: number): Promise<void> {
    const ar = await this.CreateLongRunningAutoRest();
    const proc = ar.Process();
    await Delay(delay);
    const ms1 = Date.now();
    proc.cancel();
    await proc.finish;
    const ms2 = Date.now();

    console.log(ms2 - ms1);
    assert.ok(ms2 - ms1 < 500);
  }

  @test @timeout(60000) async "immediate"() { await this.TestCancellationAfter(0); }
  @test @timeout(60000) async "after 100ms"() { await this.TestCancellationAfter(100); }
  @test @timeout(60000) async "after 1s"() { await this.TestCancellationAfter(1000); }
  @test @timeout(60000) async "after 2s"() { await this.TestCancellationAfter(2000); }
  @test @timeout(60000) async "after 3s"() { await this.TestCancellationAfter(3000); }
  @test @timeout(60000) async "after 5s"() { await this.TestCancellationAfter(5000); }
  @test @timeout(60000) async "after 8s"() { await this.TestCancellationAfter(8000); }
  @test @timeout(60000) async "after 10s"() { await this.TestCancellationAfter(10000); }
  @test @timeout(60000) async "after 15s"() { await this.TestCancellationAfter(15000); }
}