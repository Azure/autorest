import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { RealFileSystem } from "../lib/file-system";
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { Message } from "../lib/message";

@suite class Directive {

  @test @timeout(60000) async "suppression"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/"));
    autoRest.Fatal.Subscribe((_, m) => console.error(m.Text));

    // reference run
    await autoRest.ResetConfiguration();
    await autoRest.AddConfiguration({ "azure-arm": true });
    let numWarningsRef: number;
    {
      const messages: Message[] = [];
      const dispose = autoRest.Warning.Subscribe((_, m) => messages.push(m));

      await autoRest.Process().finish;
      numWarningsRef = messages.length;

      dispose();
    }
    assert.notEqual(numWarningsRef, 0);

    // muted run
    await autoRest.ResetConfiguration();
    await autoRest.AddConfiguration({ "azure-arm": true });
    await autoRest.AddConfiguration({ directive: { suppress: ["AvoidNestedProperties", "ModelTypeIncomplete", "DescriptionMissing"] } });
    {
      const messages: Message[] = [];
      const dispose = autoRest.Warning.Subscribe((_, m) => messages.push(m));

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
        const dispose = autoRest.Warning.Subscribe((_, m) => messages.push(m));

        await autoRest.Process().finish;
        if (messages.length === 0 || messages.length === numWarningsRef) {
          console.log(JSON.stringify(messages, null, 2));
        }
        assert.notEqual(messages.length, 0);
        assert.notEqual(messages.length, numWarningsRef);

        dispose();
      }
    };

    // not all types
    await pickyRun({ suppress: ["AvoidNestedProperties"] });
    // certain paths
    await pickyRun({ suppress: ["AvoidNestedProperties", "ModelTypeIncomplete", "DescriptionMissing"], where: "$..properties" });
    await pickyRun({ suppress: ["AvoidNestedProperties"], where: "$..properties.properties" });
    // // document
    await pickyRun({ suppress: ["AvoidNestedProperties"], where: "$..properties.properties", from: "swagger.md" });
  }
}