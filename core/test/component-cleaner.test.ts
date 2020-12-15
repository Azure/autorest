import * as assert from "assert";
import * as datastore from "@azure-tools/datastore";
import * as aio from "@azure-tools/async-io";
import { ComponentsCleaner } from "../lib/pipeline/plugins/components-cleaner";
import { AppRoot } from "../lib/constants";

require("source-map-support").install();

const resources = `${AppRoot}/test/resources/component-cleaner`;

const readData = async (...files: Array<string>) => {
  const results = new Array<datastore.DataHandle>();
  const map = new Map<string, string>();

  for (const inputFile of files) {
    const inputUri = `mem://${inputFile}`;
    const inputText = await aio.readFile(`${resources}/${inputFile}`);
    map.set(inputUri, inputText);
  }

  const mfs = new datastore.MemoryFileSystem(map);
  const cts: datastore.CancellationTokenSource = {
    cancel() {
      /* unused */
    },
    dispose() {
      /* unused */
    },
    token: { isCancellationRequested: false, onCancellationRequested: <any>null },
  };
  const ds = new datastore.DataStore(cts.token);
  const scope = ds.GetReadThroughScope(mfs);

  for (const inputUri of map.keys()) {
    const data = await scope.Read(inputUri);
    if (data === null) {
      throw new Error(`missing data file ${inputUri}`);
    }
    results.push(data);
  }
  return results;
};

describe("ComponentCleaner", () => {
  it("just primary-file components present", async () => {
    const [input, output] = await readData("input1.yaml", "output1.yaml");
    const cleaner = new ComponentsCleaner(input);
    assert.deepStrictEqual(await cleaner.getOutput(), await output.ReadObject());
  });

  it("secondary-file components present, but all of them referenced by something in a primary-file.", async () => {
    const [input, output] = await readData("input2.yaml", "output2.yaml");
    const cleaner = new ComponentsCleaner(input);
    assert.deepStrictEqual(await cleaner.getOutput(), await output.ReadObject());
  });

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  xit("secondary-file components not referenced by something in a primary-file.", async () => {
    const [input, output] = await readData("input3.yaml", "output3.yaml");
    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  });

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  xit("secondary-file components not referenced by something in a primary-file, and some referenced by something in a primary-file", async () => {
    const [input, output] = await readData("input4.yaml", "output4.yaml");
    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  });

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  xit("AnyOf, AllOf, OneOf, Not references from secondary-file-components to primary-file-components.", async () => {
    const [input, output] = await readData("input5.yaml", "output5.yaml");

    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  });
});
