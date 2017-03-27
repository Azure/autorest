import { Stringify } from '../lib/ref/yaml';
import { AutoRest } from '../lib/autorest-core';
import { Configuration } from '../lib/configuration';
import { RealFileSystem } from '../lib/file-system';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { parse } from "../lib/ref/jsonpath";
import { Message } from "../lib/message";

@suite class Directive {

  @test @timeout(30000) async "suppression"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/"));
    autoRest.Fatal.Subscribe((_, m) => console.error(m.Text));

    // reference run
    autoRest.ResetConfiguration();
    autoRest.AddConfiguration({ "azure-arm": true });
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
    autoRest.ResetConfiguration();
    autoRest.AddConfiguration({ "azure-arm": true });
    autoRest.AddConfiguration({ directive: { suppress: ["AvoidNestedProperties", "ModelTypeIncomplete"] } });
    let numWarningsMuted: number;
    {
      const messages: Message[] = [];
      const dispose = autoRest.Warning.Subscribe((_, m) => messages.push(m));

      await autoRest.Process().finish;
      if (messages.length > 0) {
        console.log(Stringify(messages));
      }
      assert.strictEqual(messages.length, 0);

      dispose();
    }

    // makes sure that neither all nor nothing was returned
    const pickyRun = async (directive: any) => {
      autoRest.ResetConfiguration();
      autoRest.AddConfiguration({ "azure-arm": true });
      autoRest.AddConfiguration({ directive: directive });
      {
        const messages: Message[] = [];
        const dispose = autoRest.Warning.Subscribe((_, m) => messages.push(m));

        await autoRest.Process().finish;
        //if (messages.length === 0 || messages.length === numWarningsRef) {
        console.log(JSON.stringify(messages, null, 2));
        //}
        assert.notEqual(messages.length, 0);
        assert.notEqual(messages.length, numWarningsRef);

        dispose();
      }
    };

    // not all types
    await pickyRun({ suppress: ["AvoidNestedProperties"] });
    await pickyRun({ suppress: ["AvoidNestedProperties", "ModelTypeIncomplete"] });
  }
}