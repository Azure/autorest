import fs from "fs";
import { createDataHandle } from "@autorest/test-utils";
import { MultiAPIMerger } from "../../../src/lib/plugins/merger";

async function readData(file: string, name?: string) {
  const content = await fs.promises.readFile(`${__dirname}/inputs/${file}`);
  return createDataHandle(content.toString(), { name: name ?? `mem://${file}` });
}
async function runComponentCleaner(filenames: string[]) {
  const inputs = await Promise.all(filenames.map((x) => readData(x)));
  const merger = new MultiAPIMerger(inputs, undefined, undefined);
  return await merger.getOutput();
}

const expectScenarioToMatchSnapshot = async (scenarioName: string, filenames: string[]) => {
  const output = await runComponentCleaner(filenames);
  expect(JSON.stringify(output, null, 2)).toMatchRawFileSnapshot(`${__dirname}/expected/${scenarioName}.json`);
};

describe("MultiAPIMerger", () => {
  it("merge pet store", async () => {
    await expectScenarioToMatchSnapshot("pet-store", ["pet-store/input.json", "pet-store/input2.json"]);
  });

  it("convert oai3 discriminator mapping references", async () => {
    // Here we should expect the mapping references to have been updated to the new "schemas:{id}" name.
    await expectScenarioToMatchSnapshot("discriminator-mapping", ["discriminator-mapping/discriminator-mapping.json"]);
  });

  it("convert final-state-schema references", async () => {
    // Here we should expect the final-state-schema references to have been updated to the new "schemas:{id}" name.
    await expectScenarioToMatchSnapshot("final-state-schema", ["final-state-schema/actionGroups.json"]);
  });

  describe("resolve server relative urls", () => {
    it("relative to the spec file", async () => {
      const inputs = await Promise.all([
        readData("server-relative-url/input1.json", "https://example.com/input1.json"),
        readData("server-relative-url/input2.json", "https://other.com/input2.json"),
      ]);
      const merger = new MultiAPIMerger(inputs, undefined, undefined);
      const output = await merger.getOutput();
      expect(output.servers).toEqual([
        { url: "https://example.com/endpoint1" },
        { url: "https://other.com/endpoint2" },
      ]);
    });

    it("default to the spec file if no server are provided", async () => {
      const inputs = await Promise.all([
        readData("server-relative-url/no-server.json", "https://example.com/no-server.json"),
      ]);
      const merger = new MultiAPIMerger(inputs, undefined, undefined);
      const output = await merger.getOutput();
      expect(output.servers).toEqual([{ url: "https://example.com", description: "Default server" }]);
    });

    it("throws error if no server are provided and specs are hosted on different host", async () => {
      const inputs = await Promise.all([
        readData("server-relative-url/no-server.json", "https://example.com/no-server.json"),
        readData("server-relative-url/no-server.json", "https://other.com/no-server.json"),
      ]);
      const merger = new MultiAPIMerger(inputs, undefined, undefined);
      const errorMessage = `Couldn't resolve the server url. Spec doesn't contain a server definition and specs are hosted on different hosts:
 - https://example.com
 - https://other.com`;
      await expect(() => merger.getOutput()).rejects.toThrow(errorMessage);
    });

    it("throws error if spec is loaded locally and server url is relative", async () => {
      const inputs = await Promise.all([readData("server-relative-url/input1.json", "file://localpath/input1.json")]);
      const merger = new MultiAPIMerger(inputs, undefined, undefined);
      const errorMessage = `Server url '/endpoint1' cannot be resolved to an absolute url. Update to be an absolute url or load OpenAPI document from host to automatically resolve the url relative to it.`;
      await expect(() => merger.getOutput()).rejects.toThrow(errorMessage);
    });
  });
});
