import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { CreateConfiguration } from '../legacyCli';
import { AutoRest } from '../lib/autorest-core';
import { DataHandle, DataStore } from '../lib/data-store/data-store'
import { RealFileSystem } from '../lib/file-system';
import { Channel, Message } from '../lib/message';
import { LoadLiterateOpenApi } from '../lib/pipeline/swagger-loader';
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";

@suite class OpenApi3Loading {
  @test async 'external reference resolving from another OpenAPI file'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const openApiFile = <DataHandle>await LoadLiterateOpenApi(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      'https://raw.githubusercontent.com/Azure/autorest/enable-openapi3/src/autorest-core/test/resources/openapi3-loading/petstore.yaml',
      dataStore.getDataSink());

    const openApiObj = openApiFile.ReadObject<any>();

    assert.strictEqual(openApiObj.components.schemas.Error !== undefined, true);
  }

  @test async 'external reference resolving from another yaml or json file'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const openApiFile = <DataHandle>await LoadLiterateOpenApi(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      'https://raw.githubusercontent.com/Azure/autorest/enable-openapi3/src/autorest-core/test/resources/openapi3-loading/petstore.yaml',
      dataStore.getDataSink());

    const openApiObj = openApiFile.ReadObject<any>();

    assert.strictEqual(openApiObj.components.schemas.Pet.properties !== undefined, true);
  }
}
