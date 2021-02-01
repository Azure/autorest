/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ParseNode, ParseToAst, Stringify, StringifyAst, ToAst } from "@azure-tools/datastore";
import { ConvertJsonx2Yaml, ConvertYaml2Jsonx } from "@azure-tools/datastore";
import assert from "assert";

describe("ObjectRepresentation", () => {
  it("round trip", () => {
    const o: any = {};
    o.a = 3;
    o.b = [1, "a"];
    o.c = o;
    o.d = { x: [o] };
    o.e = o.d;

    const yaml1 = Stringify(o);
    const yamlAst1 = ParseToAst(yaml1);
    const yamlAstJson1 = ConvertYaml2Jsonx(yamlAst1);
    const yamlAstJson2 = ToAst(JSON.parse(JSON.stringify(ParseNode(yamlAstJson1))));
    const yamlAst2 = ConvertJsonx2Yaml(yamlAstJson2);
    const yaml2 = StringifyAst(yamlAst2);

    assert.equal(yaml2, yaml1);
  });
});
