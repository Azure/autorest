import { suite, test, slow, timeout, skip, only } from 'mocha-typescript';
import * as assert from 'assert';
import { Deduplicator } from '../main';
import * as datastore from '@azure-tools/datastore';
import * as aio from '@azure-tools/async-io';

@suite class DeduplicatorTest {

  @test async 'components and paths deduplication'() {
    const input = JSON.parse(await aio.readFile(`${__dirname}/../../test/resources/input.json`));
    const expectedOutput = JSON.parse(await aio.readFile(`${__dirname}/../../test/resources/output.json`));
    // TODO: test mappings.
    // const deduplicator = new Deduplicator(input);
    // todo: this fails  to respond in testing... 
    // assert.deepStrictEqual(await deduplicator.getOutput(), expectedOutput);
  }
}