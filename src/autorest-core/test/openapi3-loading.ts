import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';

import { AutoRest } from '../lib/autorest-core';
import { RealFileSystem } from '@microsoft.azure/datastore';
import { LoadLiterateOpenAPIs } from '../lib/pipeline/swagger-loader';
import { CreateFolderUri, ResolveUri } from '@microsoft.azure/uri';

@suite class OpenAPI3Loading {

  @test async 'No input files provided'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [];

    const OpenAPIFilesLoaded = await LoadLiterateOpenAPIs(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink());

    assert.strictEqual(OpenAPIFilesLoaded.length, 0);

  }

  @test async 'All input files have a 3.*.* version.'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/oa3-file1.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/oa3-file2.yaml')
    ];

    const OpenAPIFilesLoaded = await LoadLiterateOpenAPIs(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink());

    assert.strictEqual(OpenAPIFilesLoaded.length, inputFilesUris.length);

  }

  @test async 'All input files do not have a 3.*.* version.'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/non-oa3-file1.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/non-oa3-file2.yaml')
    ];

    const OpenAPIFilesLoaded = await LoadLiterateOpenAPIs(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink());

    assert.strictEqual(OpenAPIFilesLoaded.length, 0);

  }

  @test async 'Some input files have a 3.*.* version and some input files do not have a 3.*.* version.'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const nonOpenAPIFileUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/non-oa3-file1.yaml'),
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/non-oa3-file2.yaml')
    ];

    const openAPIFileUris = [
      ResolveUri(CreateFolderUri(__dirname), '../../test/resources/openapi3-loading/oa3-file2.yaml')
    ];

    const inputFilesUris = [...openAPIFileUris, ...nonOpenAPIFileUris];

    const OpenAPIFilesLoaded = await LoadLiterateOpenAPIs(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink());

    assert.strictEqual(OpenAPIFilesLoaded.length, inputFilesUris.length - nonOpenAPIFileUris.length);
  }
}
