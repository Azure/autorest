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
    compare(`# Heading \n Body`, "Heading\nBody");
  }
}