// polyfills for language support
require("../lib/polyfill.min.js");

import { EnhancedPosition } from '../lib/ref/source-map';
import { PumpMessagesToConsole } from "./test-utility";
import { Artifact } from "../lib/artifact";
import { Channel, Message, SourceLocation } from '../lib/message';
import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { parse } from "../lib/ref/jsonpath";

@suite class Blaming {

  @test @timeout(0) async "end to end blaming with literate swagger"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/readme-composite.md"));
    // PumpMessagesToConsole(autoRest);
    const view = await autoRest.view;
    assert.equal(await autoRest.Process().finish, true);

    // regular description
    {
      const blameTree = await view.DataStore.Blame(
        "mem:///swagger-document/transform-immediate/output/swagger-document",
        { path: parse("$.securityDefinitions.azure_auth.description") });
      const blameInputs = [...blameTree.BlameLeafs()];
      assert.equal(blameInputs.length, 1);
    }

    // markdown description (blames both the swagger's json path and the markdown source of the description)
    {
      const blameTree = await view.DataStore.Blame(
        "mem:///swagger-document/transform-immediate/output/swagger-document",
        { path: parse("$.definitions.SearchServiceListResult.description") });
      const blameInputs = [...blameTree.BlameLeafs()];
      assert.equal(blameInputs.length, 1);
      // assert.equal(blameInputs.length, 2); // TODO: blame configuration file segments!
    }

    // path with existant node in path
    {
      let msg = {
        Text: 'Phoney message to test', Channel: Channel.Warning, Source: [<SourceLocation>
          {
            document: "mem:///compose/swagger.yaml",
            Position: <EnhancedPosition>{ path: parse('$.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}"]') }
          }]
      };
      view.Message(msg);
      assert.equal((<string[]>msg.Source[0].Position.path).length, 2);
    }

    // path node non existent
    {
      let msg = {
        Text: 'Phoney message to test', Channel: Channel.Warning, Source: [<SourceLocation>
          {
            document: "mem:///compose/swagger.yaml",
            Position: <EnhancedPosition>{ path: parse('$.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}"].get') }
          }]
      };
      view.Message(msg);
      assert.equal((<string[]>msg.Source[0].Position.path).length, 2);
    }
  }

  @test @timeout(60000) async "generate resolved swagger with source map"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/small-input/"));
    await autoRest.AddConfiguration({ "output-artifact": ["swagger-document", "swagger-document.map"] });
    const files: Artifact[] = [];
    autoRest.GeneratedFile.Subscribe((_, a) => files.push(a));
    assert.equal(await autoRest.Process().finish, true);
    assert.strictEqual(files.length, 2);

    // briefly inspect source map
    const sourceMap = files.filter(x => x.type === "swagger-document.map")[0].content;
    const sourceMapObj = JSON.parse(sourceMap);
    assert.ok(sourceMap.length > 100000);
    assert.ok(sourceMapObj.mappings.split(";").length > 1000);
  }

  @test @timeout(60000) async "large swagger performance"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/large-input/"));
    await autoRest.AddConfiguration({ "output-artifact": ["swagger-document", "swagger-document.map"] });
    const messages: Message[] = [];
    autoRest.Message.Subscribe((_, m) => messages.push(m)); // was warning.
    assert.equal(await autoRest.Process().finish, true);
    assert.notEqual(messages.length, 0);
  }
}