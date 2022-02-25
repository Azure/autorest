import assert from "assert";

import { AutorestConfiguration } from "@autorest/configuration";
import { AutorestTestLogger, createMockLogger } from "@autorest/test-utils";
import { RealFileSystem } from "@azure-tools/datastore";
import { createFolderUri, resolveUri } from "@azure-tools/uri";
import { AutoRest } from "../src/lib/autorest-core";
import { AppRoot } from "../src/lib/constants";

describe("EndToEnd", () => {
  it("network full game", async () => {
    const logger = new AutorestTestLogger();
    const autoRest = new AutoRest(logger, new RealFileSystem());
    // PumpMessagesToConsole(autoRest);
    autoRest.AddConfiguration({
      "input-file": [
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
        "https://github.com/Azure/azure-rest-api-specs/blob/master/specification/network/resource-manager/Microsoft.Network/stable/2017-03-01/vmssNetworkInterface.json",
      ],
    });

    autoRest.AddConfiguration({
      "override-info": {
        title: "Network",
      },
    });

    // TODO: generate for all, probe results

    const success = await autoRest.Process().finish;

    if (success !== true) {
      // eslint-disable-next-line no-console
      console.log("Messages", logger.logs.all);
      throw new Error("Autorest didn't complete with success.");
    }

    expect(success).toBe(true);
  });

  it("other configuration scenario", async () => {
    const autoRest = new AutoRest(
      createMockLogger(),
      new RealFileSystem(),
      resolveUri(createFolderUri(AppRoot), "test/resources/literate-example/readme-complicated.md"),
    );
    // PumpMessagesToConsole(autoRest);

    const context = await autoRest.view;
    assert.strictEqual(context.config["shouldwork" as keyof AutorestConfiguration], true);
  });
});
