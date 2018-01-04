import { Delay } from '../lib/sleep';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message } from "../lib/message";
import { Configuration } from "../lib/configuration";

/*@suite */ class Cancellation {
  private async CreateLongRunningAutoRest(): Promise<AutoRest> {
    const autoRest = new AutoRest(new RealFileSystem());
    await autoRest.AddConfiguration({
      "input-file": [
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/applicationGateway.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/applicationGateway.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/checkDnsAvailability.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/expressRouteCircuit.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/loadBalancer.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/network.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/networkInterface.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/networkSecurityGroup.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/networkWatcher.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/publicIpAddress.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/routeFilter.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/routeTable.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/serviceCommunity.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/usage.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/virtualNetwork.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/virtualNetworkGateway.json",
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/vmssNetworkInterface.json"]
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

  @test async "immediate"() { await this.TestCancellationAfter(0); }
  @test async "after 100ms"() { await this.TestCancellationAfter(100); }
  @test async "after 1s"() { await this.TestCancellationAfter(1000); }
  @test async "after 2s"() { await this.TestCancellationAfter(2000); }
  @test async "after 3s"() { await this.TestCancellationAfter(3000); }
  @test async "after 5s"() { await this.TestCancellationAfter(5000); }
  @test async "after 8s"() { await this.TestCancellationAfter(8000); }
  @test async "after 10s"() { await this.TestCancellationAfter(10000); }
  @test async "after 15s"() { await this.TestCancellationAfter(15000); }

  static after() {
    Configuration.shutdown()
  }
}