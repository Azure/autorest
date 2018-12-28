
import * as aio from '@microsoft.azure/async-io';
import * as datastore from '@microsoft.azure/datastore';
import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { ObjectFilter } from '../lib/pipeline/plugins/version-filter';

const resources = `${__dirname}../../../test/resources/version-filter`;

@suite class VersionFiltering {

  @test async 'filter paths and schemas based on API version'() {
    const inputUri = 'mem://input1.json';
    const outputUri = 'mem://output1.json';

    const input = await aio.readFile(`${resources}/input1.json`);
    const output = await aio.readFile(`${resources}/output1.json`);

    const map = new Map<string, string>([[inputUri, input], [outputUri, output]]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = { cancel() { }, dispose() { }, token: { isCancellationRequested: false, onCancellationRequested: <any>null } };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const inputDataHandle = await scope.Read(inputUri);
    const outputDataHandle = await scope.Read(outputUri);

    assert(inputDataHandle != null);
    assert(outputDataHandle != null);

    if (inputDataHandle && outputDataHandle) {
      const outputObject = outputDataHandle.ReadObject();
      const processor = new ObjectFilter(inputDataHandle);
      const processorOutput = await processor.getOutput();
      assert.deepEqual(processorOutput, outputObject, 'Should be the same');
    }
  }
}
