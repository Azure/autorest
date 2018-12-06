import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";
import * as datastore from '@microsoft.azure/datastore';
import * as aio from "@microsoft.azure/async-io";
import { ComponentCleaner } from "../lib/pipeline/plugins/component-cleaner";


const resources = `${__dirname}../../../test/resources/component-cleaner`;

@suite class ComponentCleanerTest {

  @test async "just primary-file components present"() {

    const input = JSON.parse(await aio.readFile(`${resources}/input1.yaml`));
    const output = JSON.parse(await aio.readFile(`${resources}/output1.yaml`));

    // TODO: test mappings.
    const cleaner = new ComponentCleaner(input);
    assert.deepStrictEqual(cleaner.output, output);
  }

  @test async "secondary-file components present, but all of them referenced by something in a primary-file."() {

    const input = JSON.parse(await aio.readFile(`${resources}/input2.yaml`));
    const output = JSON.parse(await aio.readFile(`${resources}/output2.yaml`));

    // TODO: test mappings.
    const cleaner = new ComponentCleaner(input);
    assert.deepStrictEqual(cleaner.output, output);
  }

  @test async "secondary-file components not referenced by something in a primary-file."() {

    const input = JSON.parse(await aio.readFile(`${resources}/input3.yaml`));
    const output = JSON.parse(await aio.readFile(`${resources}/output3.yaml`));

    // TODO: test mappings.
    const cleaner = new ComponentCleaner(input);
    assert.deepStrictEqual(cleaner.output, output);
  }

  @test async "secondary-file components not referenced by something in a primary-file, and some referenced by something in a primary-file"() {

    const input = JSON.parse(await aio.readFile(`${resources}/input4.yaml`));
    const output = JSON.parse(await aio.readFile(`${resources}/output4.yaml`));

    // TODO: test mappings.
    const cleaner = new ComponentCleaner(input);
    assert.deepStrictEqual(cleaner.output, output);
  }

  @test async "AnyOf, AllOf, OneOf, Not references from secondary-file-components to primary-file-components."() {

    const input = JSON.parse(await aio.readFile(`${resources}/input5.yaml`));
    const output = JSON.parse(await aio.readFile(`${resources}/output5.yaml`));

    // TODO: test mappings.
    const cleaner = new ComponentCleaner(input);
    assert.deepStrictEqual(cleaner.output, output);
  }
}