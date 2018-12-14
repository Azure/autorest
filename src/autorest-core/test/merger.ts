/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as aio from '@microsoft.azure/async-io';
import * as datastore from '@microsoft.azure/datastore';

import * as assert from 'assert';
import { only, skip, slow, suite, test, timeout } from 'mocha-typescript';

import { MultiAPIMerger } from '../lib/pipeline/plugins/merger';
import { FastStringify } from '@microsoft.azure/datastore';

require('source-map-support').install();

const resources = `${__dirname}../../../test/resources/merger`;

@suite class TestShaker {

  @test async 'Test Merger'() {

    const inputUri = 'mem://input.yaml';
    const inputUri2 = 'mem://input2.yaml';
    // const outputUri = 'mem://output.yaml';

    const input = await aio.readFile(`${resources}/input.yaml`);
    const input2 = await aio.readFile(`${resources}/input2.yaml`);
    // const output = await aio.readFile(`${resources}/output.yaml`);

    const map = new Map<string, string>([[inputUri, input]]);
    const map2 = new Map<string, string>([[inputUri2, input2]]);
    //const map = new Map<string, string>([[inputUri, input], [outputUri, output]]);
    const mfs = new datastore.MemoryFileSystem(map);
    const mfs2 = new datastore.MemoryFileSystem(map2);

    const cts: datastore.CancellationTokenSource = { cancel() { }, dispose() { }, token: { isCancellationRequested: false, onCancellationRequested: <any>null } };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const scope2 = ds.GetReadThroughScope(mfs2);
    const inputDataHandle = await scope.Read(inputUri);
    const inputDataHandle2 = await scope2.Read(inputUri2);
    // const outputDataHandle = await scope.Read(outputUri);

    assert(inputDataHandle != null);
    assert(inputDataHandle2 != null);
    // assert(outputDataHandle != null);

    // if (inputDataHandle && outputDataHandle) {
    if (inputDataHandle && inputDataHandle2) {
      // const outputObject = outputDataHandle.ReadObject();
      const processor = new MultiAPIMerger([inputDataHandle, inputDataHandle2], undefined, undefined);

      const sink = ds.getDataSink();
      const output = await processor.getOutput();

      const data = await sink.WriteObject('merged oai3 doc...', await processor.getOutput(), inputDataHandle.identity, 'merged-oai3', await processor.getSourceMappings(), [inputDataHandle, inputDataHandle2]);



      // testing: dump out the converted file
      //console.log(FastStringify(processor.output));

      // console.log(JSON.stringify(data.ReadMetadata.sourceMap.Value));

      await aio.writeFile("c:/tmp/input.yaml", input);
      await aio.writeFile("c:/tmp/output.yaml", FastStringify(await processor.getOutput()));
      await aio.writeFile("c:/tmp/output.yaml.map", JSON.stringify(data.metadata.sourceMap.Value));


      // assert.deepEqual(shaker.output, outputObject, 'Should be the same');
    }
  }
}
