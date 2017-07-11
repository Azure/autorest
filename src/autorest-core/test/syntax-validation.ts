/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// polyfills for language support 
require("../lib/polyfill.min.js");

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import { DataStore } from "../lib/data-store/data-store";
import { Message, Channel } from "../lib/message";
import { AutoRest } from "../lib/autorest-core";
import { MemoryFileSystem } from "../lib/file-system";
import { Parse } from "../lib/parsing/literate-yaml";

@suite class SyntaxValidation {
  private async GetLoaderErrors(swagger: string): Promise<Message[]> {
    const dataStore = new DataStore();
    const uri = "mem:///swagger.json";
    const hw = await dataStore.Write(uri);
    const h = await hw.WriteData(swagger);

    const autoRest = new AutoRest();
    const messages: Message[] = [];

    autoRest.Message.Subscribe((_, m) => { if (m.Channel == Channel.Error) { messages.push(m) } });
    Parse(await autoRest.view, h, dataStore.CreateScope("tmp"));

    return messages;
  }

  @test async "syntax errors"() {
    // good
    assert.strictEqual((await this.GetLoaderErrors("{ a: 3 }")).length, 0);
    assert.strictEqual((await this.GetLoaderErrors("a: 3")).length, 0);
    assert.strictEqual((await this.GetLoaderErrors("a: [3]")).length, 0);

    // bad
    assert.notEqual((await this.GetLoaderErrors("{ a: 3 ")).length, 0);
    assert.notEqual((await this.GetLoaderErrors("{ a: '3 }")).length, 0);
    assert.notEqual((await this.GetLoaderErrors("\n\n [{ a: '3 }]")).length, 0);
    assert.notEqual((await this.GetLoaderErrors("{ a 3 }")).length, 0);
    assert.notEqual((await this.GetLoaderErrors("a: [3")).length, 0);

    // location
    assert.deepStrictEqual(((await this.GetLoaderErrors("{ a: 3 "))[0] as any).Source[0].Position, { line: 1, column: 8 });
    assert.deepStrictEqual(((await this.GetLoaderErrors("{ a: '3 }"))[0] as any).Source[0].Position, { line: 1, column: 10 });
    assert.deepStrictEqual(((await this.GetLoaderErrors("\n\n\n [{ a: '3 }]"))[0] as any).Source[0].Position, { line: 4, column: 13 });
    assert.deepStrictEqual(((await this.GetLoaderErrors("{ a 3 }"))[0] as any).Source[0].Position, { line: 1, column: 5 });
    assert.deepStrictEqual(((await this.GetLoaderErrors("a: [3"))[0] as any).Source[0].Position, { line: 1, column: 6 });
  }
}