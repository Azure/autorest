import fs from "fs";
import { basename, join } from "path";
import { convertOai2ToOai3, OaiToOai3FileInput } from "../../src";

const inputsFolder = `${__dirname}/inputs/`;
const expectedFolder = `${__dirname}/expected/`;

const getOAI3InputsFromTestFiles = async (
  testName: string,
  filenames: string[],
): Promise<Map<string, OaiToOai3FileInput>> => {
  const map = new Map<string, OaiToOai3FileInput>();
  for (const filename of filenames) {
    const buffer = await fs.promises.readFile(join(inputsFolder, testName, filename));

    const name = basename(filename);
    map.set(name, { name, schema: JSON.parse(buffer.toString()) });
  }
  return map;
};

const expectInputsMatchSnapshots = async (testName: string, filenames: string[]) => {
  const map = await getOAI3InputsFromTestFiles(testName, filenames);

  const results = await convertOai2ToOai3(map);
  for (const result of results) {
    const jsonResult = JSON.stringify(result.result, null, 2);
    expect(jsonResult).toMatchRawFileSnapshot(join(expectedFolder, testName, result.name));
  }
};

describe("Scenario testings", () => {
  it("Convert cross file schema references", async () => {
    await expectInputsMatchSnapshots("cross-file-schema-refs", ["swagger.json", "other.json"]);
  });

  it("Convert cross file body parameter", async () => {
    await expectInputsMatchSnapshots("cross-file-body-refs", ["swagger.json", "other.json"]);
  });
});
