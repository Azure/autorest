import { nodes } from '../lib/ref/jsonpath';
import { CreateFolderUri, ResolveUri } from '../lib/ref/uri';
import { RealFileSystem } from '../lib/file-system';
import { AutoRest } from '../lib/autorest-core';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { Node, Parser } from "../lib/ref/commonmark";
import { PlainTextVersion } from "../lib/pipeline/commonmark-documentation";

@suite class Commonmark {

  private Parse(rawCommonmark: string): Node {
    return new Parser().parse(rawCommonmark);
  }

  @test @timeout(30000) async "PlainTextVersion"() {
    const compare = (raw: string, expected: string) =>
      assert.strictEqual(PlainTextVersion(this.Parse(raw)), expected);

    compare("Hello World", "Hello World");
    compare("this\ntest\ncould\nuse\nmore\ncowbell", "this test could use more cowbell");
    compare("actual\n\nnewline", "actual\nnewline");
    compare("some **more** delicious *cowbell*", "some more delicious cowbell");
    compare("add some `code` in there", "add some code in there");
    compare("# Heading \n Body", "Heading\nBody");
    compare("Fancy <b>html</b> features", "Fancy html features");
    compare("Even <code>fancier</code> <i>html</i> tags<br> and<hr> stuff", "Even fancier html tags and stuff");
  }

  @test @timeout(10000) async "resolve markdown descriptions"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/"));
    autoRest.AddConfiguration({ "output-artifact": "swagger-document" });

    let swaggerDoc: string = "";
    autoRest.GeneratedFile.Subscribe((_, a) => { if (a.type === "swagger-document") { swaggerDoc = a.content; } });
    assert.strictEqual(await autoRest.Process().finish, true);
    assert.notEqual(swaggerDoc, "");

    const swaggerDocObj = JSON.parse(swaggerDoc);
    for (const descrNode of nodes(swaggerDocObj, "$..description")) {
      assert.strictEqual(typeof descrNode.value, "string");
    }
  }
}