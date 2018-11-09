import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";
import * as aio from "@microsoft.azure/async-io"
import { AutoRest } from "../lib/autorest-core";
import { LoadLiterateSwaggers } from "../lib/pipeline/swagger-loader";
import * as datastore from '@microsoft.azure/datastore';
import { CreateFolderUri, ResolveUri } from '@microsoft.azure/uri';
import { readFile } from "fs";
import { RealFileSystem, DataHandle } from "@microsoft.azure/datastore";
import { crawlReferences } from "../lib/pipeline/ref-crawling";

@suite class RefCrawling {

  @test async 'crawl all the files referenced'() {

    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;
    const sink = dataStore.getDataSink();
    const scope = dataStore.GetReadThroughScope(new RealFileSystem());
    const file1DataHandle = await scope.ReadStrict(`https://raw.githubusercontent.com/Azure/autorest/b01c27166a390771260166221545ce3af8c92c84/src/autorest-core/test/resources/ref-crawling/original-files/input-file1.yaml`);
    const file2DataHandle = await scope.ReadStrict(`https://raw.githubusercontent.com/Azure/autorest/b01c27166a390771260166221545ce3af8c92c84/src/autorest-core/test/resources/ref-crawling/original-files/input-file2.yaml`);
    const files = [file1DataHandle, file2DataHandle];

    const result = await crawlReferences(scope, files, sink);

    assert(result);
  }
}