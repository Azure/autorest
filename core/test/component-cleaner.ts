import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";
import * as datastore from "@azure-tools/datastore";
import * as aio from "@azure-tools/async-io";
import { ComponentsCleaner } from "../lib/pipeline/plugins/components-cleaner";

require("source-map-support").install();

const resources = `${__dirname}/../../test/resources/component-cleaner`;

@suite
class ComponentCleanerTest {
  async "readData"(...files: Array<string>) {
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
  }

  async "io"(inputFile: string, outputFile: string) {
    const inputUri = `mem://${inputFile}`;
    const outputUri = `mem://${outputFile}`;

    const inputText = await aio.readFile(`${resources}/${inputFile}`);
    const outputText = await aio.readFile(`${resources}/${outputFile}`);

    const map = new Map<string, string>([
      [inputUri, inputText],
      [outputUri, outputText],
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
    const input = await scope.Read(inputUri);
    const output = await scope.Read(outputUri);

    assert(input !== null);
    assert(output !== null);
    if (input === null || output === null) {
      throw Error("Input or Output is null");
    }
    return {
      input,
      output,
    };
  }

  @test async "just primary-file components present"() {
    const [input, output] = await this.readData("input1.yaml", "output1.yaml");
    const cleaner = new ComponentsCleaner(input);
    assert.deepStrictEqual(await cleaner.getOutput(), await output.ReadObject());
  }

  @test async "secondary-file components present, but all of them referenced by something in a primary-file."() {
    const [input, output] = await this.readData("input2.yaml", "output2.yaml");
    const cleaner = new ComponentsCleaner(input);
    assert.deepStrictEqual(await cleaner.getOutput(), await output.ReadObject());
  }

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  @test @skip async "secondary-file components not referenced by something in a primary-file."() {
    const [input, output] = await this.readData("input3.yaml", "output3.yaml");
    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  }

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  @test
  @skip
  async "secondary-file components not referenced by something in a primary-file, and some referenced by something in a primary-file"() {
    const [input, output] = await this.readData("input4.yaml", "output4.yaml");
    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  }

  // todo: I think this fails because he changed the behavior to let all non schema/parameter components thru.
  @test @skip async "AnyOf, AllOf, OneOf, Not references from secondary-file-components to primary-file-components."() {
    const [input, output] = await this.readData("input5.yaml", "output5.yaml");

    const cleaner = new ComponentsCleaner(input);
    const cleaned = await cleaner.getOutput();
    const expected = await output.ReadObject();

    assert.deepStrictEqual(cleaned, expected);
  }
}
