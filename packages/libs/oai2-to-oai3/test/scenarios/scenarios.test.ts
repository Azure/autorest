import fs from "fs";
import { basename, join } from "path";
import { serializeJsonPointer } from "@azure-tools/json";
import { ConverterLogger, convertOai2ToOai3, OaiToOai3FileInput } from "../../src";

const inputsFolder = `${__dirname}/inputs/`;
const expectedFolder = `${__dirname}/expected/`;

const logger: ConverterLogger = {
  trackError: jest.fn(),
  trackWarning: jest.fn(),
};

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

  const results = await convertOai2ToOai3(logger, map);
  for (const result of results) {
    const jsonResult = JSON.stringify(result.result, null, 2);
    expect(jsonResult).toMatchRawFileSnapshot(join(expectedFolder, testName, result.name));

    const mappings = result.mappings
      .map((x) => `${serializeJsonPointer(x.generated)} => ${serializeJsonPointer(x.original)}`)
      .join("\n");
    expect(mappings).toMatchRawFileSnapshot(join(expectedFolder, testName, `${result.name}.mappings.txt`));
  }
};

describe("Scenario testings", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });
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

  it("request body - copying extensions", async () => {
    await expectInputsMatchSnapshots("request-body", ["swagger.json"]);
  });

  it("response examples - ignore invalid", async () => {
    await expectInputsMatchSnapshots("responses-examples", ["swagger.json"]);
    expect(logger.trackWarning).toHaveBeenCalledTimes(2);
    expect(logger.trackWarning).toHaveBeenNthCalledWith(1, {
      code: "Oai2ToOai3/InvalidResponseExamples",
      message:
        "Response examples has mime-type 'application/xml' which is not define in the local or global produces. Example will be ignored.",
      source: [
        {
          document: "swagger.json",
          path: "/paths/~1invalid-response-examples/get/responses/200/examples/application~1xml",
        },
      ],
    });
    expect(logger.trackWarning).toHaveBeenNthCalledWith(2, {
      code: "Oai2ToOai3/InvalidResponseExamples",
      message:
        "Response examples has mime-type 'unknown' which is not define in the local or global produces. Example will be ignored.",
      source: [
        { document: "swagger.json", path: "/paths/~1invalid-response-examples/get/responses/200/examples/unknown" },
      ],
    });
  });

  it("responses using ref keep reference", async () => {
    await expectInputsMatchSnapshots("responses-ref", ["swagger.json"]);
  });

  it("final-state-schema is converted to oai3 ref", async () => {
    await expectInputsMatchSnapshots("final-state-schema", ["swagger.json"]);
  });
});
