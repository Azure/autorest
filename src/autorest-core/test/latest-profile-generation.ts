
import * as aio from '@microsoft.azure/async-io';
import * as datastore from '@microsoft.azure/datastore';
import * as assert from 'assert';
import { suite, test } from 'mocha-typescript';
import { getLatestProfile } from '../lib/pipeline/plugins/profile-filter';

const resources = `${__dirname}../../../test/resources/latest-profile-generation`;

@suite class LatestProfileGeneration {

  @test async 'filter paths and schemas based on API version'() {
    const originalProfilesUri = 'mem://profiles.yaml';
    const latestProfileUri = 'mem://latest-profile.yaml';

    const input = await aio.readFile(`${resources}/profiles.yaml`);
    const output = await aio.readFile(`${resources}/latest-profile.yaml`);

    const map = new Map<string, string>([[originalProfilesUri, input], [latestProfileUri, output]]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = { cancel() { }, dispose() { }, token: { isCancellationRequested: false, onCancellationRequested: <any>null } };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const inputDataHandle = await scope.Read(originalProfilesUri);
    const outputDataHandle = await scope.Read(latestProfileUri);

    assert(inputDataHandle != null);
    assert(outputDataHandle != null);

    if (inputDataHandle && outputDataHandle) {
      const expectedOutputObject = outputDataHandle.ReadObject();
      const allProfiles = inputDataHandle.ReadObject()['profiles'];
      const actualOutputObject = getLatestProfile(allProfiles);
      assert.deepEqual(actualOutputObject, expectedOutputObject, 'Should be the same');
    }
  }
}
