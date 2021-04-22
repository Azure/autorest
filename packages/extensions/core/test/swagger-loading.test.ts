import assert from "assert";

import { RealFileSystem } from "@azure-tools/datastore";
import { CreateFolderUri, ResolveUri } from "@azure-tools/uri";
import { AutoRest } from "../src/lib/autorest-core";
import { LoadLiterateSwaggers } from "../src/lib/plugins/loaders";
import { AppRoot } from "../src/lib/constants";

describe("SwaggerLoading", () => {
  it("No input files provided", async () => {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris: string[] = [];

    const swaggerFilesLoaded = await LoadLiterateSwaggers(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(swaggerFilesLoaded.length, 0);
  });

  it("All input files have a 2.0 version.", async () => {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file1.json"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file2.json"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file3.yaml"),
    ];

    const swaggerFilesLoaded = await LoadLiterateSwaggers(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(swaggerFilesLoaded.length, inputFilesUris.length);
  });

  it("All input files do not have a 2.0 version.", async () => {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const inputFilesUris = [
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/non-swagger-file1.yaml"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/non-swagger-file2.yaml"),
    ];

    const swaggerFilesLoaded = await LoadLiterateSwaggers(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(swaggerFilesLoaded.length, 0);
  });

  it("Some input files have a 2.0 version and some input files do not have a 2.0 version.", async () => {
    const autoRest = new AutoRest();
    const config = await autoRest.view;
    const dataStore = config.DataStore;

    const nonSwaggerFileUris = [
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/non-swagger-file1.yaml"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/non-swagger-file2.yaml"),
    ];

    const swaggerFileUris = [
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file1.json"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file2.json"),
      ResolveUri(CreateFolderUri(AppRoot), "test/resources/swagger-loading/swagger-file3.yaml"),
    ];

    const inputFilesUris = [...swaggerFileUris, ...nonSwaggerFileUris];

    const swaggerFilesLoaded = await LoadLiterateSwaggers(
      config,
      dataStore.GetReadThroughScope(new RealFileSystem()),
      inputFilesUris,
      dataStore.getDataSink(),
    );

    assert.strictEqual(swaggerFilesLoaded.length, inputFilesUris.length - nonSwaggerFileUris.length);
  });

  // TODO: Uncomment when OpenAPI 3 support is ready.
  // it(""composite Swagger", async () => {
  //   const dataStore = new DataStore();

  //   const config = await CreateConfiguration("file:///", dataStore.GetReadThroughScope(new RealFileSystem()),
  //     [
  //       "-i", "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/a2b46f557c6a17a95777a8a2f380cfecb9dac28e/arm-network/compositeNetworkClient.json",
  //       "-m", "CompositeSwagger",
  //       "-g", "None"
  //     ]);
  //   assert.strictEqual((config["input-file"] as any).length, 18);
  //   const autoRest = new AutoRest(new RealFileSystem());
  //   await autoRest.AddConfiguration(config);

  //   const messages: Message[] = [];

  //   autoRest.Message.Subscribe((_, m) => { messages.push(m); });
  //   // PumpMessagesToConsole(autoRest);
  //   assert.equal(await autoRest.Process().finish, true);
  //   // flag any fatal errors
  //   assert.equal(messages.filter(m => m.Channel === Channel.Fatal).length, 0);
  //   assert.notEqual(messages.length, 0);
  // }
});
