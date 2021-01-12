/* eslint-disable @typescript-eslint/consistent-type-assertions */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as assert from "assert";
import { CancellationToken } from "vscode-jsonrpc";
import { DataStore } from "@azure-tools/datastore";
import { Message, Channel } from "../lib/message";
import { AutoRest } from "../lib/autorest-core";

import { parse } from "../lib/parsing/literate-yaml";
import { ConfigurationLoader } from "../lib/configuration";

const getLoaderErrors = async (swagger: string): Promise<Array<Message>> =>  {
    const dataStore = new DataStore(CancellationToken.None);
    const uri = "mem:///swagger.json";
    const h = await dataStore.WriteData(uri, swagger, "input-file", [uri]);

    const autoRest = new AutoRest();
    const messages: Array<Message> = [];

    autoRest.Message.Subscribe((_, m) => {
      if (m.Channel == Channel.Error) {
        messages.push(m);
      }
    });
    try {
      await parse(await autoRest.view, h, dataStore.getDataSink());
    } catch (e) {
      // it'll also throw, but detailed messages are emitted first
    }

    return messages;
  };

describe("SyntaxValidation", () => {
  afterAll(async () => {
    await ConfigurationLoader.shutdown();
  });

  xit("syntax errors", async () => {
    // good
    assert.strictEqual((await getLoaderErrors("{ a: 3 }")).length, 0);
    assert.strictEqual((await getLoaderErrors("a: 3")).length, 0);
    assert.strictEqual((await getLoaderErrors("a: [3]")).length, 0);

    // bad
    assert.notEqual((await getLoaderErrors("{ a: 3 ")).length, 0);
    assert.notEqual((await getLoaderErrors("{ a: '3 }")).length, 0);
    assert.notEqual((await getLoaderErrors("\n\n [{ a: '3 }]")).length, 0);
    assert.notEqual((await getLoaderErrors("{ a 3 }")).length, 0);
    assert.notEqual((await getLoaderErrors("a: [3")).length, 0);

    // location
    assert.deepStrictEqual(((await getLoaderErrors("{ a: 3 "))[0] as any).Source[0].Position, {
      line: 1,
      column: 8,
    });
    assert.deepStrictEqual(((await getLoaderErrors("{ a: '3 }"))[0] as any).Source[0].Position, {
      line: 1,
      column: 10,
    });
    assert.deepStrictEqual(((await getLoaderErrors("\n\n\n [{ a: '3 }]"))[0] as any).Source[0].Position, {
      line: 4,
      column: 13,
    });
    assert.deepStrictEqual(((await getLoaderErrors("{ a 3 }"))[0] as any).Source[0].Position, {
      line: 1,
      column: 5,
    });
    assert.deepStrictEqual(((await getLoaderErrors("a: [3"))[0] as any).Source[0].Position, {
      line: 1,
      column: 6,
    });
  });
});
