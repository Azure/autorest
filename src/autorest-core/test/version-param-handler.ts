
import * as aio from '@microsoft.azure/async-io';
import * as datastore from '@microsoft.azure/datastore';
import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { ApiVersionParameterHandler } from '../lib/pipeline/plugins/version-param-handler';

const resources = `${__dirname}../../../test/resources/version-param-handler`;

@suite class ApiVersionParameterHandling {

  @test async 'Remove api-version global parameter, remove references to said parameter and add metadata.'() {

    const inputUri = 'mem://input.json';
    const outputUri = 'mem://output.json';

    const input = await aio.readFile(`${resources}/input.json`);
    const output = await aio.readFile(`${resources}/output.json`);

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
      // if (inputDataHandle) {
      const outputObject = outputDataHandle.ReadObject();
      const paramHandler = new ApiVersionParameterHandler(inputDataHandle);

      assert.deepEqual(paramHandler.getOutput(), outputObject, 'Should be the same');
    }
  }
}
