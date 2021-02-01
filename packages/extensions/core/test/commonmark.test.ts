/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { nodes } from "@azure-tools/datastore";
import { CreateFolderUri, ResolveUri } from "@azure-tools/uri";
import { RealFileSystem } from "@azure-tools/datastore";
import { AutoRest } from "../src/lib/autorest-core";
import assert from "assert";

import { Node, Parser } from "commonmark";
import { plainTextVersion } from "../src/lib/pipeline/commonmark-documentation";

const parse = (rawCommonmark: string): Node => {
  return new Parser().parse(rawCommonmark);
};

describe("CommonMark", () => {
  it("parse PlainTextVersion", async () => {
    const compare = (raw: string, expected: string) => assert.strictEqual(plainTextVersion(parse(raw)), expected);

    compare("Hello World", "Hello World");
    compare("this\ntest\ncould\nuse\nmore\ncowbell", "this test could use more cowbell");
    compare("actual\n\nnewline", "actual\nnewline");
    compare("some **more** delicious *cowbell*", "some more delicious cowbell");
    compare("add some `code` in there", "add some code in there");
    compare("# Heading \n Body", "Heading\nBody");
    compare("Fancy <b>html</b> features", "Fancy html features");
    compare("Even <code>fancier</code> <i>html</i> tags<br> and<hr> stuff", "Even fancier html tags and stuff");
  });

  // gs01/nelson : to do -- we have to come back and make sure this works.
  xit("resolve markdown descriptions", async () => {
    const autoRest = new AutoRest(
      new RealFileSystem(),
      ResolveUri(CreateFolderUri(__dirname), "../../test/resources/literate-example/"),
    );
    autoRest.AddConfiguration({ "output-artifact": "swagger-document" });

    let swaggerDoc = "";
    autoRest.GeneratedFile.Subscribe((_, a) => {
      if (a.type === "swagger-document") {
        swaggerDoc = a.content;
      }
    });
    assert.strictEqual(await autoRest.Process().finish, true);
    assert.notEqual(swaggerDoc, "");

    // check that all descriptions have been resolved
    const swaggerDocObj = JSON.parse(swaggerDoc);
    for (const descrNode of nodes(swaggerDocObj, "$..description")) {
      assert.strictEqual(typeof descrNode.value, "string");
    }

    // commented out since we don't include subheadings currently
    // // check that subheading was included
    // assert.ok(swaggerDocObj.definitions.ListQueryKeysResult.description.indexOf("content under a subheading") !== -1);
  });
});
