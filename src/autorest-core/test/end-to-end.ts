// polyfills for language support 
require("../lib/polyfill.min.js");

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message, Channel } from "../lib/message";
import { PumpMessagesToConsole } from './test-utility';

@suite class EndToEnd {
  @test @timeout(120000) async "network full game"() {
    const autoRest = new AutoRest(new RealFileSystem());
    // PumpMessagesToConsole(autoRest);
    autoRest.AddConfiguration({
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

    autoRest.AddConfiguration({
      "override-info": {
        title: "Network"
      }
    });

    // TODO: generate for all, probe results

    const success = await autoRest.Process().finish;
    assert.strictEqual(success, true);
  }

  @test @timeout(60000) async "complicated configuration scenario"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/readme-complicated.md"));
    // PumpMessagesToConsole(autoRest);
    autoRest.AddConfiguration({
      "cmd-line-true": true,
      "cmd-line-false": false,
      "cmd-line-complex": {
        "true": true,
        "false": false
      }
    });

    const config = await autoRest.view;
    assert.strictEqual(config.AzureArm, true);
    assert.strictEqual([...config.InputFileUris].length, 1);

    const messages: Message[] = [];

    autoRest.Message.Subscribe((_, m) => { if (m.Channel == Channel.Warning) { messages.push(m) } });
    await autoRest.Process().finish;
    assert.notEqual(messages.length, 0);
  }
}