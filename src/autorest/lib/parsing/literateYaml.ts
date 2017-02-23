/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import { SourceMapGenerator } from "source-map";
import * as yaml from "./yaml";
import * as yamlast from "./yamlAst";
import { mergeYamls } from "../source-map/merging";
import { Mapping, compile } from "../source-map/sourceMap";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";
import { parse as parseLiterate } from "./literate";

export async function parse(hConfigFile: DataHandleRead, hConfig: DataHandleWrite, intermediateHandles: (key: string) => Promise<DataHandleWrite>): Promise<DataHandleRead> {
  const hsConfigFileBlocks = await parseLiterate(hConfigFile, intermediateHandles);
  return await mergeYamls(hsConfigFileBlocks, hConfig);
}

// export function test(): void {
//   //     const input1 = `
//   // &ref_0
//   // a:  3
//   // b: "4"
//   // c:    *ref_0
//   // d: &ref_1
//   //   x: 1
//   //   y: 2
//   // e: *ref_1`;
//   //     const input2 = `
//   // asd:  "asd"
//   // e:
//   //   f: "asd"
//   // d:
//   //   z: 3`;
//   const input1 = `
// a:  3
// b: "4"
// c: ["asd", 'qwe', 3.4]
// d:
//   x: 1
//   y: 2
// e:
//   x: 1
//   y: 2`;
//   const input2 = `
// asd:  "asd"
// c: [3.1, "asd"]
// e:
//   f: "asd"
// d:
//   z: 3`;
//   let files: { [fileName: string]: string } = { "in1.js": input1, "in2.js": input2 };
//   let output = mergeWithSourceMappings(files);
//   files = JSON.parse(JSON.stringify(files));
//   let outputFileName = "out.js";
//   files[outputFileName] = yaml.stringify(output[0]);
//   let gen = new SourceMapGenerator({ file: outputFileName });
//   compile(output[1], gen, files);

//   console.log(files[outputFileName]);
//   console.log(JSON.stringify(gen.toJSON(), null, 2));
// }