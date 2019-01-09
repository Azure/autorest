
import * as aio from '@microsoft.azure/async-io';
import * as datastore from '@microsoft.azure/datastore';
import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { ProfileFilter } from '../lib/pipeline/plugins/profile-filter';

const resources = `${__dirname}../../../test/resources/profile-filter`;

@suite class ProfileFiltering {

  @test async 'filter paths and schemas based on API version'() {
    const inputUri = 'mem://input1.json';
    const outputUri = 'mem://output1.json';
    const profilesUri = 'mem://profiles.yaml';
    const profilesToUse = ['2017-03-09-profile'];

    const input = await aio.readFile(`${resources}/input1.json`);
    const output = await aio.readFile(`${resources}/output1.json`);
    const profiles = await aio.readFile(`${resources}/profiles.yaml`);

    const map = new Map<string, string>([[inputUri, input], [outputUri, output], [profilesUri, profiles]]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = { cancel() { }, dispose() { }, token: { isCancellationRequested: false, onCancellationRequested: <any>null } };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const inputDataHandle = await scope.Read(inputUri);
    const outputDataHandle = await scope.Read(outputUri);
    const profilesDataHandle = await scope.Read(profilesUri);

    assert(inputDataHandle != null);
    assert(outputDataHandle != null);
    assert(profilesDataHandle != null);

    if (inputDataHandle && outputDataHandle && profilesDataHandle) {
      const outputObject = outputDataHandle.ReadObject();
      const processor = new ProfileFilter(inputDataHandle, profilesDataHandle.ReadObject(), profilesToUse);
      const processorOutput = await processor.getOutput();
      assert.deepEqual(processorOutput, outputObject, 'Should be the same');
    }
  }
}
