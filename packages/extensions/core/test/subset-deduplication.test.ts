import * as aio from "@azure-tools/async-io";
import * as datastore from "@azure-tools/datastore";
import assert from "assert";
import {
  getSubsetRelation,
  getSubsetSchema,
  getSupersetSchema,
  SubsetSchemaDeduplicator,
} from "../src/lib/plugins/subset-schemas-deduplicator";

const resources = `${__dirname}../../../test/resources/subset-deduplication`;

// validation specific keys such as readOnly and required are ignored
const skipList = ["description", "enum", "readOnly", "required"];
const expandableFieldsList = ["properties", "allOf"];

describe("SubsetDeduplication", () => {
  it.skip("subset check function", async () => {
    const input = JSON.parse(await aio.readFile(`${resources}/schema1.json`));
    const input2 = JSON.parse(await aio.readFile(`${resources}/schema2.json`));
    const input3 = JSON.parse(await aio.readFile(`${resources}/schema3.json`));
    const expected1 = JSON.parse(await aio.readFile(`${resources}/expected-check-result1.json`));
    const expected2 = JSON.parse(await aio.readFile(`${resources}/expected-check-result2.json`));

    const result1 = getSubsetRelation(input, input2, expandableFieldsList, skipList);
    assert.deepStrictEqual(result1, expected1);

    const result2 = getSubsetRelation(input2, input3, expandableFieldsList, skipList);
    assert.deepStrictEqual(result2, expected2);
  });

  it.skip("superset schema construction", async () => {
    const input = JSON.parse(await aio.readFile(`${resources}/schema1.json`));
    const input2 = JSON.parse(await aio.readFile(`${resources}/schema2.json`));
    const checkResult1 = JSON.parse(await aio.readFile(`${resources}/expected-check-result1.json`));
    const updatedSchema2 = JSON.parse(await aio.readFile(`${resources}/updated-schema2.json`));

    const result1 = getSupersetSchema(input, input2, expandableFieldsList, checkResult1, "#/definitions/subset");
    assert.deepStrictEqual(result1, updatedSchema2);
  });

  it.skip("subset schema construction", async () => {
    const input = JSON.parse(await aio.readFile(`${resources}/schema1.json`));
    const input2 = JSON.parse(await aio.readFile(`${resources}/schema2.json`));
    const checkResult1 = JSON.parse(await aio.readFile(`${resources}/expected-check-result1.json`));
    const updatedSchema2 = JSON.parse(await aio.readFile(`${resources}/updated-schema1.json`));

    const result1 = getSubsetSchema(input, checkResult1);
    assert.deepStrictEqual(result1, updatedSchema2);
  });

  it.skip("subset deduplication in spec", async () => {
    const inputUri = "mem://input1.json";
    const outputUri = "mem://output1.json";

    const input = await aio.readFile(`${resources}/input1.json`);
    const output = await aio.readFile(`${resources}/output1.json`);

    const map = new Map<string, string>([
      [inputUri, input],
      [outputUri, output],
    ]);
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
    const inputDataHandle = await scope.Read(inputUri);
    const outputDataHandle = await scope.Read(outputUri);

    assert(inputDataHandle != null);
    assert(outputDataHandle != null);

    if (inputDataHandle && outputDataHandle) {
      const outputObject = await outputDataHandle.ReadObject();
      const processor = new SubsetSchemaDeduplicator(inputDataHandle);
      const processorOutput = await processor.getOutput();
      assert.deepEqual(processorOutput, outputObject, "Should be the same");
    }
  });
});
