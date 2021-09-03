import { DataStore, IFileSystem, RealFileSystem } from "@azure-tools/datastore";
import { createFolderUri, resolveUri } from "@azure-tools/uri";
import { AppRoot } from "../../constants";
import { createMockLogger } from "@autorest/test-utils";
import { IAutorestLogger } from "@autorest/common";
import { loadOpenAPIFiles } from "./openapi-loader";

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
      return resolveUri(createFolderUri(AppRoot), `test/resources/openapi3-loading/${x}`);
    });

    return await loadOpenAPIFiles(logger, dataStore.getReadThroughScope(fs), inputFilesUris, dataStore.getDataSink());
  }

  it("doesn't load anything if no input files provided", async () => {
    const swaggerFilesLoaded = await loadSwagger([]);

    expect(swaggerFilesLoaded).toHaveLength(0);
  });

  it("All input files have a 3.*.* version.", async () => {
    const inputFilesUris = ["oa3-file1.yaml", "oa3-file2.yaml"];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);

    expect(swaggerFilesLoaded).toHaveLength(inputFilesUris.length);
  });

  it("All input files do not have a 3.*.* version.", async () => {
    const inputFilesUris = ["non-oa3-file1.yaml", "non-oa3-file2.yaml"];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);

    expect(swaggerFilesLoaded).toHaveLength(0);
  });

  it("Some input files have a 3.*.* version and some input files do not have a 3.*.* version.", async () => {
    const nonSwaggerFileUris = ["non-oa3-file1.yaml", "non-oa3-file2.yaml"];

    const swaggerFileUris = ["oa3-file2.yaml"];

    const inputFilesUris = [...swaggerFileUris, ...nonSwaggerFileUris];

    const swaggerFilesLoaded = await loadSwagger(inputFilesUris);
    expect(swaggerFilesLoaded).toHaveLength(inputFilesUris.length - nonSwaggerFileUris.length);
  });
});
