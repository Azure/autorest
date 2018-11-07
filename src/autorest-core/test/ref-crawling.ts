import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { AutoRest } from "../lib/autorest-core";
import { LoadLiterateSwaggers } from "../lib/pipeline/swagger-loader";
import { RealFileSystem } from "@microsoft.azure/datastore";
import { CreateFolderUri, ResolveUri } from '@microsoft.azure/uri';

@suite class RefCrawling {

  @test async 'Get all referenced files from a single swagger'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/applicationGateway.json')
    ];

  }
}