import { AutorestLogger } from "@autorest/common";
import { createMockLogger, createDataHandle } from "@autorest/test-utils";
import { DataSink, DataStore } from "@azure-tools/datastore";
import { parseConfigFile } from "./literate-yaml";

describe("Literate yaml", () => {
  let logger: AutorestLogger;
  let sink: DataSink;

  beforeEach(() => {
    logger = createMockLogger();
    const ds = new DataStore({ autoUnloadData: false });
    sink = ds.getDataSink();
  });
  it("parse file with single yaml code block", async () => {
    const content = `
\`\`\`yaml
input-file: openapi.yaml
    `.trimStart();
    const codeBlocks = await parseConfigFile(logger, createDataHandle(content, { name: "foo.md" }), sink);
    expect(codeBlocks).toHaveLength(1);
    expect((await codeBlocks[0].data.readData()).trim()).toEqual("input-file: openapi.yaml");
  });
});
