import assert from "assert";
import fs from "fs";
import { DataStore, MemoryFileSystem } from "@azure-tools/datastore";
import { ComponentsCleaner } from "../../../src/lib/plugins/components-cleaner";

const readData = async (file: string) => {
  const map = new Map<string, string>();

  const inputUri = `mem://${file}`;
  const inputText = await fs.promises.readFile(`${__dirname}/inputs/${file}`);
  map.set(inputUri, inputText.toString());

  const mfs = new MemoryFileSystem(map);
  const ds = new DataStore({ autoUnloadData: false });
  const scope = ds.getReadThroughScope(mfs);
  return await scope.read(inputUri);
};

const runComponentCleaner = async (scenarioName: string) => {
  const input = await readData(`${scenarioName}.json`);
  assert(input);
  const cleaner = new ComponentsCleaner(input);
  return {
    input: await input?.readObject(),
    output: await cleaner.getOutput(),
  };
};

const expectScenarioToMatchSnapshot = async (scenarioName: string) => {
  const { output } = await runComponentCleaner(scenarioName);
  expect(JSON.stringify(output, null, 2)).toMatchRawFileSnapshot(`${__dirname}/expected/${scenarioName}.json`);
};

describe("ComponentCleaner", () => {
  it("doesn't remove anything when there isn't any secondary file components", async () => {
    const { input, output } = await runComponentCleaner("no-secondary-file-components");
    expect(output).toEqual(input);
  });

  it("doesn't remove anything when all secondary components are referenced from primary file.", async () => {
    const { input, output } = await runComponentCleaner("all-secondary-components-referenced");
    expect(output).toEqual(input);
  });

  it("secondary-file components not referenced by something in a primary-file.", async () => {
    await expectScenarioToMatchSnapshot("some-unused-secondary-components");
  });

  it("ignores schema properties called $ref", async () => {
    const { input, output } = await runComponentCleaner("schema-with-$ref-property");
    expect(output).toEqual(input);
  });

  it("ignores x- properties under components", async () => {
    const { input, output } = await runComponentCleaner("components-extensions");
    expect(output).toEqual(input);
  });

  it("doesn't remove polymorhique types", async () => {
    await expectScenarioToMatchSnapshot("polymorphism");
  });
});
