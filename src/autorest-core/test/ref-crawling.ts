import * as assert from 'assert';
import { only, skip, slow, suite, test, timeout } from 'mocha-typescript';

import { RealFileSystem } from '@microsoft.azure/datastore';
import { CreateFolderUri, ResolveUri } from '@microsoft.azure/uri';
import { AutoRest } from '../lib/autorest-core';
import { LoadLiterateSwaggers } from '../lib/pipeline/plugins/loaders';

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
