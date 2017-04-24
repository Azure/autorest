// polyfills for language support 
require("../lib/polyfill.min.js");

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message, Channel } from "../lib/message";

@suite class Directive {

  @test @timeout(60000) async "suppression"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/"));
    autoRest.Message.Subscribe((_, m) => m.Channel === Channel.Fatal ? console.error(m.Text) : "");

    // reference run
    await autoRest.ResetConfiguration();
    await autoRest.AddConfiguration({ "azure-arm": true });
    let numWarningsRef: number;
    {
      const messages: Message[] = [];
      const dispose = autoRest.Message.Subscribe((_, m) => { if (m.Channel == Channel.Warning) { messages.push(m) } });

      await autoRest.Process().finish;
      numWarningsRef = messages.length;

      dispose();
    }
    assert.notEqual(numWarningsRef, 0);

    // muted run
    await autoRest.ResetConfiguration();
    await autoRest.AddConfiguration({ "azure-arm": true });
    await autoRest.AddConfiguration({ directive: { suppress: ["AvoidNestedProperties", "ModelTypeIncomplete", "DescriptionMissing", "PutRequestResponseValidation"] } });
    {
      const messages: Message[] = [];
      const dispose = autoRest.Message.Subscribe((_, m) => { if (m.Channel == Channel.Warning) { messages.push(m) } });

      await autoRest.Process().finish;
      if (messages.length > 0) {
        console.log("Should have been muted but found:");
        console.log(JSON.stringify(messages, null, 2));
      }
      assert.strictEqual(messages.length, 0);

      dispose();
    }

    // makes sure that neither all nor nothing was returned
    const pickyRun = async (directive: any) => {
      await autoRest.ResetConfiguration();
      await autoRest.AddConfiguration({ "azure-arm": true });
      await autoRest.AddConfiguration({ directive: directive });
      {
        const messages: Message[] = [];
        const dispose = autoRest.Message.Subscribe((_, m) => { if (m.Channel == Channel.Warning) { messages.push(m) } });

        await autoRest.Process().finish;
        if (messages.length === 0 || messages.length === numWarningsRef) {
          console.log(JSON.stringify(messages, null, 2));
        }
        assert.notEqual(messages.length, 0);
        assert.notEqual(messages.length, numWarningsRef);

        // console.log(directive, messages.length);

        dispose();
      }
    };

    // not all types
    await pickyRun({ suppress: ["AvoidNestedProperties"] });
    // certain paths
    await pickyRun({ suppress: ["AvoidNestedProperties", "ModelTypeIncomplete", "DescriptionMissing"], where: "$..properties" });
    await pickyRun({ suppress: ["AvoidNestedProperties"], where: "$..properties.properties" });
    // multiple directives
    await pickyRun([{ suppress: ["AvoidNestedProperties"], where: "$..properties.properties" }]);
    await pickyRun([
      { suppress: ["AvoidNestedProperties"] },
      { suppress: ["ModelTypeIncomplete"] }
    ]);
    await pickyRun([
      { suppress: ["DescriptionMissing"] },
      { suppress: ["ModelTypeIncomplete"] }
    ]);
    // document
    await pickyRun({ suppress: ["AvoidNestedProperties"], where: "$..properties.properties", from: "swagger.md" });
  }

  @test @timeout(60000) async "set descriptions on different levels"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/"));

    const GenerateCodeModel = async (config: any) => {
      await autoRest.ResetConfiguration();
      autoRest.AddConfiguration({ "output-artifact": "code-model-v1" });
      autoRest.AddConfiguration(config);

      let resolve: (content: string) => void;
      const result = new Promise<string>(res => resolve = res);

      const dispose = autoRest.GeneratedFile.Subscribe((_, a) => { resolve(a.content); dispose(); });
      await autoRest.Process().finish;

      return result;
    };

    // reference run
    const codeModelRef = await GenerateCodeModel({});

    // set descriptions in resolved swagger
    const codeModelSetDescr1 = await GenerateCodeModel({ directive: { from: "swagger-document", where: "$..description", set: "cowbell" } });

    // set descriptions in code model
    const codeModelSetDescr2 = await GenerateCodeModel({ directive: { from: "code-model-v1", where: ["$..description", "$..documentation", "$..['#documentation']"], set: "cowbell" } });

    // transform descriptions in resolved swagger
    const codeModelSetDescr3 = await GenerateCodeModel({ directive: { from: "swagger-document", where: "$..description", transform: "return 'cowbell'" } });

    assert.ok(codeModelRef.indexOf("description: cowbell") === -1 && codeModelRef.indexOf("\"description\": \"cowbell\"") === -1);
    assert.ok(codeModelSetDescr1.indexOf("description: cowbell") !== -1 || codeModelSetDescr1.indexOf("\"description\": \"cowbell\"") !== -1);
    assert.strictEqual(codeModelSetDescr1, codeModelSetDescr2);
    assert.strictEqual(codeModelSetDescr1, codeModelSetDescr3);

    // transform descriptions in resolved swagger to uppercase
    const codeModelSetDescr4 = await GenerateCodeModel({ directive: { from: "swagger-document", where: "$..description", transform: "return $.toUpperCase()" } });
    assert.notEqual(codeModelRef, codeModelSetDescr4);
    assert.strictEqual(codeModelRef.toLowerCase(), codeModelSetDescr4.toLowerCase());
  }
}