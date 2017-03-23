import { Configuration } from '../lib/configuration';
import { RealFileSystem } from '../lib/file-system';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { CreateFileUri, ResolveUri } from "../lib/ref/uri";
import { parse } from "../lib/ref/jsonpath";
import { DataStore } from "../lib/data-store/data-store";
import { RunPipeline } from "../lib/pipeline/pipeline";

@suite class Blaming {

  @test @timeout(10000) async "end to end blaming with literate swagger"() {
    const view = await new Configuration(new RealFileSystem(), ResolveUri(CreateFileUri(__dirname) + "/", "resources/literate-example/")).CreateView();
    const results = await RunPipeline(view);

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