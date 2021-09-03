import { DataStore, IFileSystem, RealFileSystem } from "@azure-tools/datastore";
import { createFolderUri, resolveUri } from "@azure-tools/uri";
import { loadSwaggerFiles } from ".";
import { AppRoot } from "../../constants";
import { createMockLogger } from "@autorest/test-utils";
import { IAutorestLogger } from "@autorest/common";

describe("SwaggerLoading", () => {
  let dataStore: DataStore;
  let logger: IAutorestLogger;
  let fs: IFileSystem;

  beforeEach(() => {
    dataStore = new DataStore({ autoUnloadData: false });
    logger = createMockLogger();
    fs = new RealFileSystem();
  });

  async function loadSwagger(files: string[]) {
    const inputFilesUris = files.map((x) => {
      return resolveUri(createFolderUri(AppRoot), `test/resources/swagger-loading/${x}`);
    });

    return await loadSwaggerFiles(logger, dataStore.getReadThroughScope(fs), inputFilesUris, dataStore.getDataSink());
  }

  it("doesn't load anything if no input files provided", async () => {
    const swaggerFilesLoaded = await loadSwagger([]);

    expect(swaggerFilesLoaded).toHaveLength(0);
  });

  it("All input files have a 2.0 version.", async () => {
    const inputFilesUris = ["swagger-file1.json", "swagger-file2.json", "swagger-file3.yaml"];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);

    expect(swaggerFilesLoaded).toHaveLength(inputFilesUris.length);
  });

  it("All input files do not have a 2.0 version.", async () => {
    const inputFilesUris = ["non-swagger-file1.yaml", "non-swagger-file2.yaml"];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);

    expect(swaggerFilesLoaded).toHaveLength(0);
  });

  it("Some input files have a 2.0 version and some input files do not have a 2.0 version.", async () => {
    const nonSwaggerFileUris = ["non-swagger-file1.yaml", "non-swagger-file2.yaml"];

    const swaggerFileUris = ["swagger-file1.json", "swagger-file2.json", "swagger-file3.yaml"];

    const inputFilesUris = [...swaggerFileUris, ...nonSwaggerFileUris];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);
    expect(swaggerFilesLoaded).toHaveLength(inputFilesUris.length - nonSwaggerFileUris.length);
  });
});
