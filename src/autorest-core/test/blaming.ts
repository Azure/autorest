import { AutoRest } from '../lib/autorest-core';
import { Configuration } from '../lib/configuration';
import { RealFileSystem } from '../lib/file-system';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { parse } from "../lib/ref/jsonpath";

@suite class Blaming {

  @test @timeout(30000) async "end to end blaming with literate swagger"() {
    const autoRest = new AutoRest(new RealFileSystem(), ResolveUri(CreateFolderUri(__dirname), "resources/literate-example/readme-composite.md"));
    const view = await autoRest.view;
    await autoRest.Process().finish;

    // regular description
    {
      const blameTree = await view.DataStore.Blame(
        "compose/swagger.yaml",
        { path: parse("$.securityDefinitions.azure_auth.description") });
      const blameInputs = [...blameTree.BlameInputs()];
      assert.equal(blameInputs.length, 1);
    }

    // markdown description (blames both the swagger's json path and the markdown source of the description)
    {
      const blameTree = await view.DataStore.Blame(
        "compose/swagger.yaml",
        { path: parse("$.definitions.SearchServiceListResult.description") });
      const blameInputs = [...blameTree.BlameInputs()];
      assert.equal(blameInputs.length, 2);
    }
  }
}