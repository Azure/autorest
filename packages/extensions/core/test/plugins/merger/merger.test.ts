import { MultiAPIMerger } from "../../../src/lib/plugins/merger";
import fs from "fs";
import { createDataHandle } from "@autorest/test-utils";

async function readData(file: string) {
  const content = await fs.promises.readFile(`${__dirname}/inputs/${file}`);
  return createDataHandle(content.toString(), { name: file });
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
});
