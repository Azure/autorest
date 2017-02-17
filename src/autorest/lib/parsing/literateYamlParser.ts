/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { getYamlSourceMap } from "./yamlParser";

interface TestObject {
    a: number;
    b: string;
    c: TestObject;
    d: { x: number, y: number };
    e: { x: number, y: number };
}

export function test(): void {
    var x = getYamlSourceMap<TestObject>(`
&ref_0
a:  3
b: "4"
c:    *ref_0
d: &ref_1
  x: 1
  y: 2
e: *ref_1`);
    console.log(JSON.stringify(x, null, 2));
}