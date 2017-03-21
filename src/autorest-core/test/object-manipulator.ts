/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataStore } from '../lib/data-store/data-store';
import { ManipulateObject } from '../lib/pipeline/object-manipulator';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

@suite class ObjectManipulator {

  private exampleObject: string = `
host: localhost:27332
paths:
  "/api/circular":
    get:
      description: fun time
      operationId: Circular
      responses:
        '200':
          schema:
            "$ref": "#/definitions/NodeA"
definitions:
  NodeA:
    description: Description
    type: object
    properties:
      child:
        "$ref": "#/definitions/NodeA"
  NodeB:
    type: object
    properties:
      child:
        "$ref": "#/definitions/NodeB"`;

  @test async "any hit"() {
    // setup
    const dataStore = new DataStore();
    const inputWrite = await dataStore.Write("input.yaml");
    const input = await inputWrite.WriteData(this.exampleObject);

    const expectHit = async (jsonQuery: string, anyHit: boolean) => {
      const result = await ManipulateObject(input, dataStore.CreateScope(`manip${(await dataStore.Enum()).length}`), jsonQuery, x => x);
      assert.strictEqual(result.anyHit, anyHit, jsonQuery);
    };

    await expectHit("$..post", false);
    await expectHit("$..get", true);
    await expectHit("$.parameters", false);
    await expectHit("$.definitions", true);
    await expectHit("$..summary", false);
    await expectHit("$..description", true);
    await expectHit("$.definitions[?(@.summary)]", false);
    await expectHit("$.definitions[?(@.description)]", true);
    await expectHit("$.definitions[?(@.description==\"Descriptio\")]", false);
    await expectHit("$.definitions[?(@.description==\"Description\")]", true);
    await expectHit("$..[?(@.description==\"Descriptio\")]", false);
    await expectHit("$..[?(@.description==\"Description\")]", true);
  }

  @test async "removal"() {
    // setup
    const dataStore = new DataStore();
    const inputWrite = await dataStore.Write("input.yaml");
    const input = await inputWrite.WriteData(this.exampleObject);

    // remove all models that don't have a description
    const result = await ManipulateObject(input, dataStore.CreateScope(`manip1`), "$.definitions[?(!@.description)]", x => undefined);
    assert.strictEqual(result.anyHit, true);
    const resultRaw = await result.result.ReadData();
    assert.ok(resultRaw.indexOf("NodeA") !== -1);
    assert.ok(resultRaw.indexOf("NodeB") === -1);
  }

  @test async "update"() {
    // setup
    const dataStore = new DataStore();
    const inputWrite = await dataStore.Write("input.yaml");
    const input = await inputWrite.WriteData(this.exampleObject);

    {
      // override all existing model descriptions
      const bestDescriptionEver = "best description ever";
      const result = await ManipulateObject(input, dataStore.CreateScope(`manip1`), "$.definitions.*.description", x => bestDescriptionEver);
      assert.strictEqual(result.anyHit, true);
      const resultObject = await result.result.ReadObject<any>();
      assert.strictEqual(resultObject.definitions.NodeA.description, bestDescriptionEver);
    }
    {
      // override & insert all model descriptions
      const bestDescriptionEver = "best description ever";
      const result = await ManipulateObject(input, dataStore.CreateScope(`manip2`), "$.definitions.*", x => { x.description = bestDescriptionEver; return x; });
      assert.strictEqual(result.anyHit, true);
      const resultObject = await result.result.ReadObject<any>();
      assert.strictEqual(resultObject.definitions.NodeA.description, bestDescriptionEver);
      assert.strictEqual(resultObject.definitions.NodeB.description, bestDescriptionEver);
    }
    {
      // make all descriptions upper case
      const bestDescriptionEver = "best description ever";
      const result = await ManipulateObject(input, dataStore.CreateScope(`manip3`), "$..description", x => (x as string).toUpperCase());
      assert.strictEqual(result.anyHit, true);
      const resultObject = await result.result.ReadObject<any>();
      assert.strictEqual(resultObject.definitions.NodeA.description, "DESCRIPTION");
      assert.strictEqual(resultObject.paths["/api/circular"].get.description, "FUN TIME");
    }
  }
}