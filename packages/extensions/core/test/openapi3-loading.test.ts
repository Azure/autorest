import assert from "assert";
import { AutoRest } from "../src/lib/autorest-core";
import { RealFileSystem } from "@azure-tools/datastore";
import { createMockLogger } from "@autorest/test-utils";
import { loadOpenAPIFiles } from "../src/lib/plugins/loaders";
import { createFolderUri, resolveUri } from "@azure-tools/uri";
import { AppRoot } from "../src/lib/constants";

describe("OpenAPI3Loading", () => {
  it("No input files provided", async () => {
    const autoRest = new AutoRest(createMockLogger());
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris: string[] = [];

    const OpenAPIFilesLoaded = await loadOpenAPIFiles(
      config,
      dataStore.getReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(OpenAPIFilesLoaded.length, 0);
  });

  it("All input files have a 3.*.* version.", async () => {
    const autoRest = new AutoRest(createMockLogger());
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/oa3-file1.yaml"),
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/oa3-file2.yaml"),
    ];

    const OpenAPIFilesLoaded = await loadOpenAPIFiles(
      config,
      dataStore.getReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(OpenAPIFilesLoaded.length, inputFilesUris.length);
  });

  it("All input files do not have a 3.*.* version.", async () => {
    const autoRest = new AutoRest(createMockLogger());
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/non-oa3-file1.yaml"),
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/non-oa3-file2.yaml"),
    ];

    const OpenAPIFilesLoaded = await loadOpenAPIFiles(
      config,
      dataStore.getReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(OpenAPIFilesLoaded.length, 0);
  });

  it("Some input files have a 3.*.* version and some input files do not have a 3.*.* version.", async () => {
    const autoRest = new AutoRest(createMockLogger());
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const nonOpenAPIFileUris = [
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/non-oa3-file1.yaml"),
      resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/non-oa3-file2.yaml"),
    ];

    const openAPIFileUris = [resolveUri(createFolderUri(AppRoot), "test/resources/openapi3-loading/oa3-file2.yaml")];

    const inputFilesUris = [...openAPIFileUris, ...nonOpenAPIFileUris];

    const OpenAPIFilesLoaded = await loadOpenAPIFiles(
      config,
      dataStore.getReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(OpenAPIFilesLoaded.length, inputFilesUris.length - nonOpenAPIFileUris.length);
  });
});
