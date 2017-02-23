/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "commonmark";
import * as fs from "fs";
// import { From } from "linq-es2015";
import * as path from "path";
import * as promisify from "pify";
import { SourceMapGenerator } from "source-map";
import { Mappings, compile } from "../source-map/sourceMap";
import { numberOfLines } from "./textUtility";

interface fsAsync {
  /*
   * Asynchronous readFile - Asynchronously reads the entire contents of a file.
   *
   * @param fileName
   * @param encoding
   */
  readFile(filename: string, encoding: string): Promise<string>;
  /*
   * Asynchronous readFile - Asynchronously reads the entire contents of a file.
   *
   * @param fileName
   * @param options An object with optional {encoding} and {flag} properties.  If {encoding} is specified, readFile returns a string; otherwise it returns a Buffer.
   */
  readFile(filename: string, options: { encoding: string; flag?: string; }): Promise<string>;
  /*
   * Asynchronous readFile - Asynchronously reads the entire contents of a file.
   *
   * @param fileName
   * @param options An object with optional {encoding} and {flag} properties.  If {encoding} is specified, readFile returns a string; otherwise it returns a Buffer.
   */
  readFile(filename: string, options: { flag?: string; }): Promise<Buffer>;
  /*
   * Asynchronous readFile - Asynchronously reads the entire contents of a file.
   *
   * @param fileName
   */
  readFile(filename: string): Promise<Buffer>;
}
var fsAsync: fsAsync = promisify(fs);

function ast(node: commonmark.Node): any {
  if (node.type === "text") {
    return node.literal;
  }

  let result: any = {};
  // result.info = node.info;
  // result.isContainer = node.isContainer;
  if (node.level) {
    result.level = node.level;
  }
  if (node.literal) {
    result.literal = node.literal;
  }
  // result.sourcepos = node.sourcepos;
  result.type = node.type;
  result.children = [];

  var child = node.firstChild;
  while (child != null) {
    result.children.push(ast(child));
    child = child.next;
  }
  if (result.children.length === 0) {
    delete result.children;
  }

  return result;
}

export async function test() {
  let parser = new commonmark.Parser();
  let inputFile = "C:\\Users\\jobader\\Desktop\\asd\\md\\input.js";
  let inputFileContent = await fsAsync.readFile(inputFile, "utf8");

  for (let cb of parseCodeblocks(inputFileContent)) {
    let content = cb.literal;
    let mapping = getSourceMapForCodeBlock("input.js", cb);
    let gen = new SourceMapGenerator({ file: `output${cb.sourcepos[0][0]}.js` });
    compile(mapping, gen);

    console.log();
    console.log(`output${cb.sourcepos[0][0]}.js`);
    console.log(content);
    console.log(JSON.stringify(gen.toJSON(), null, 2));
  }
}

export function* getSourceMapForCodeBlock(sourceFileName: string, codeBlock: commonmark.Node): Mappings {
  const numLines = codeBlock.sourcepos[1][0] - codeBlock.sourcepos[0][0] + (codeBlock.info === null ? 1 : -1);
  for (var i = 0; i < numLines; ++i) {
    yield {
      generated: {
        line: i + 1,
        column: 0
      },
      original: {
        line: i + codeBlock.sourcepos[0][0] + (codeBlock.info === null ? 0 : 1),
        column: codeBlock.sourcepos[0][1] - 1
      },
      source: sourceFileName,
      name: `Codeblock line '${i + 1}'`
    };
  }
}

export function* parseCodeblocks(markdown: string): Iterable<commonmark.Node> {
  const parser = new commonmark.Parser();
  const parsed = parser.parse(markdown);
  const walker = parsed.walker();
  let event: commonmark.NodeWalkingStep;
  while ((event = walker.next())) {
    var node = event.node;
    if (event.entering && node.type === "code_block") {
      yield node;
    }
  }
}