import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { CreateConfiguration } from '../legacyCli';
import { AutoRest } from '../lib/autorest-core';
import { DataHandle, DataStore } from '../lib/data-store/data-store'
import { RealFileSystem } from '../lib/file-system';
import { Channel, Message } from '../lib/message';
import { CreateFolderUri, ResolveUri } from "../lib/ref/uri";
import { LoadLiterateOpenApi } from '../lib/pipeline/swagger-loader';


@suite class OpenApi3Loading {
  @test async 'external reference resolving'() {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const openApiFile = <DataHandle>await LoadLiterateOpenApi(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      'https://raw.githubusercontent.com/Azure/autorest/enable-openapi3/src/autorest-core/test/resources/openapi3-loading/petstore.yaml',
      dataStore.getDataSink());

    // check presence of Pet (imported from "./petstore-external.yaml")
    const openApiObj = openApiFile.ReadObject<any>();

    assert.strictEqual(openApiObj.components.schemas.Pet !== undefined, true);
  }
}
