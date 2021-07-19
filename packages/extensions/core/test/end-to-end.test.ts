import assert from "assert";

import { AutoRest } from "../src/lib/autorest-core";
import { RealFileSystem } from "@azure-tools/datastore";
import { Channel, Message } from "../src/lib/message";
import { createFolderUri, resolveUri } from "@azure-tools/uri";
import { AppRoot } from "../src/lib/constants";
import { AutorestConfiguration } from "@autorest/configuration";

describe("EndToEnd", () => {
  it("network full game", async () => {
    const autoRest = new AutoRest(new RealFileSystem());
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

    const messages: Message[] = [];
    const channels = new Set([
      Channel.Information,
      Channel.Warning,
      Channel.Error,
      Channel.Fatal,
      Channel.Debug,
      Channel.Verbose,
    ]);

    autoRest.Message.Subscribe((_, message) => {
      if (channels.has(message.Channel)) {
        messages.push(message);
      }
    });

    // TODO: generate for all, probe results

    const success = await autoRest.Process().finish;

    if (!success) {
      // eslint-disable-next-line no-console
      console.log("Messages", messages);
      throw new Error("Autorest didn't complete with success.");
    }

    expect(success).toBe(true);
  });

  it("other configuration scenario", async () => {
    const autoRest = new AutoRest(
      new RealFileSystem(),
      resolveUri(createFolderUri(AppRoot), "test/resources/literate-example/readme-complicated.md"),
    );
    // PumpMessagesToConsole(autoRest);

    const context = await autoRest.view;
    assert.strictEqual(context.config["shouldwork" as keyof AutorestConfiguration], true);
  });
});
