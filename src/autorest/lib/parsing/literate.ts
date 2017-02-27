/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "commonmark";
import { Mappings } from "../source-map/sourceMap";
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

function* getSourceMapForCodeBlock(sourceFileName: string, codeBlock: commonmark.Node): Mappings {
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

function* parseCodeblocks(markdown: string): Iterable<commonmark.Node> {
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