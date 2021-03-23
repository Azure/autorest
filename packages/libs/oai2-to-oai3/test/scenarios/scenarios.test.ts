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
    // The expected result is for the body parameter to be copied over but not the schema.
    await expectInputsMatchSnapshots("cross-file-schema-refs", ["swagger.json", "other.json"]);
  });

  it("Convert cross file regular parameters", async () => {
    // The expected result is the ref just change from /parameters -> /components/parameters.
    await expectInputsMatchSnapshots("cross-file-parameters-refs", ["swagger.json", "other.json"]);
  });

  it("Convert cross file body parameter", async () => {
    // The expected result is the ref just change from /defnitions -> /components/schemas.
    await expectInputsMatchSnapshots("cross-file-body-refs", ["swagger.json", "other.json"]);
  });

  it("Convert cross file parameterized host", async () => {
    // The expected result is the parmaeter to be included/expanded in the OpenAPI3 server property.
    await expectInputsMatchSnapshots("cross-file-parameterized-host-refs", ["swagger.json", "other.json"]);
  });

  it("Convert parameterized host parameters to server variables", async () => {
    // The expected result is the parmaeter to be included/expanded in the OpenAPI3 server property.
    await expectInputsMatchSnapshots("parameterized-host-parameters", ["swagger.json"]);
  });

  it("Convert enums using $ref object as values", async () => {
    // The expected result is the $ref in `enum` has been updated to the openapi 3 format.
    await expectInputsMatchSnapshots("enums", ["swagger.json"]);
  });
});
