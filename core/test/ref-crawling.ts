import { RealFileSystem } from '@azure-tools/datastore';
import { CreateFolderUri, ResolveUri } from '@azure-tools/uri';
import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { AutoRest } from '../lib/autorest-core';
import { crawlReferences } from '../lib/pipeline/plugins/ref-crawling';

@suite class RefCrawling {

  @test async 'Crawl files referenced, update references and mark secondary files.'() {

    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;
    const sink = dataStore.getDataSink();
    const scope = dataStore.GetReadThroughScope(new RealFileSystem());
    const file1DataHandle = await scope.ReadStrict('https://raw.githubusercontent.com/Azure/autorest/b39cc11e2577662c97a47511a08665fa6e4d712d/src/autorest-core/test/resources/ref-crawling/original-files/input-file1.yaml');
    const file2DataHandle = await scope.ReadStrict('https://raw.githubusercontent.com/Azure/autorest/b39cc11e2577662c97a47511a08665fa6e4d712d/src/autorest-core/test/resources/ref-crawling/original-files/input-file2.yaml');
    const files = [file1DataHandle, file2DataHandle];

    const result = await crawlReferences(config, scope, files, sink);

    const expectedFilesUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/input-file1.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/input-file2.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/petstore.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/examples/file-a.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/examples/file-b.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/ref-crawling/expected-modified-copies/examples/file-c.yaml'),
    ];

    assert.strictEqual(result.length, expectedFilesUris.length);

    for (const resultFile of result) {
      const resultFileName = resultFile.identity[0].split('/').pop();
      assert(resultFileName);
      const expectedFileUri = expectedFilesUris.find((element) => {
        return element.endsWith(resultFileName || '');
      });
      const expectedFileHandle = await scope.ReadStrict(expectedFileUri || '');
      assert.deepStrictEqual(await resultFile.ReadObject(), await expectedFileHandle.ReadObject());
    }
  }
}
