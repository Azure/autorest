/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as aio from '@azure-tools/async-io';
import * as datastore from '@azure-tools/datastore';

import * as assert from 'assert';
import { only, skip, slow, suite, test, timeout } from 'mocha-typescript';

import { OAI3Shaker } from '../lib/pipeline/plugins/tree-shaker';
import { FastStringify } from '@azure-tools/datastore';

try {
  require('source-map-support').install();
} catch {
  /* unused */
}

const resources = `${__dirname}../../../test/resources/shaker`;

@suite class TestShaker {

  @test async 'Test Shaker'() {

    const inputUri = 'mem://input.yaml';
    const outputUri = 'mem://output.yaml';

    const input = await aio.readFile(`${resources}/input.yaml`);
    const output = await aio.readFile(`${resources}/output.yaml`);

    const map = new Map<string, string>([[inputUri, input], [outputUri, output]]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = { cancel() {/* unused */ }, dispose() {/* unused */ }, token: { isCancellationRequested: false, onCancellationRequested: <any>null } };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const inputDataHandle = await scope.Read(inputUri);
    const outputDataHandle = await scope.Read(outputUri);

    assert(inputDataHandle != null);
    assert(outputDataHandle != null);

    if (inputDataHandle && outputDataHandle) {
      // if (inputDataHandle) {
      const outputObject = await outputDataHandle.ReadObject();
      const shaker = new OAI3Shaker(inputDataHandle, false);

      // testing: dump out the converted file
      // console.log(FastStringify(shaken));

      assert.deepEqual(await shaker.getOutput(), outputObject, 'Should be the same');
    }
  }
}
