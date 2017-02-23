/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "commonmark";
// import { From } from "linq-es2015";
import { Mappings, compile } from "../source-map/sourceMap";
import { numberOfLines } from "./textUtility";
import { DataHandleRead, DataHandleWrite } from "../data-store/dataStore";

export async function parse(hConfigFile: DataHandleRead, intermediateHandles: (key: string) => Promise<DataHandleWrite>): Promise<DataHandleRead[]> {
  const hsCodeBlock: DataHandleRead[] = [];
  const rawMarkdown = await hConfigFile.readData();
  for (const codeBlock of parseCodeblocks(rawMarkdown)) {
    const mappings = getSourceMapForCodeBlock(hConfigFile.key, codeBlock);

    const codeBlockKey = `${hConfigFile.key}_codeBlock_${codeBlock.sourcepos[0][0]}`;
    const hwCodeBlock = await intermediateHandles(codeBlockKey);
    const hCodeBlock = await hwCodeBlock.writeData(codeBlock.literal, mappings);
    hsCodeBlock.push(hCodeBlock);
  }
  return hsCodeBlock;
}

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