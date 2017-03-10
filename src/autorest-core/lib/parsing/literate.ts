/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "../approved-imports/commonmark";
import { Mappings } from "../approved-imports/source-map";
import { DataHandleRead, DataStoreView } from "../data-store/data-store";

export async function Parse(hConfigFile: DataHandleRead, intermediateScope: DataStoreView): Promise<{ data: DataHandleRead, codeBlock: commonmark.Node }[]> {
  const result: { data: DataHandleRead, codeBlock: commonmark.Node }[] = [];
  const rawMarkdown = await hConfigFile.ReadData();
  for (const codeBlock of ParseCodeblocks(rawMarkdown)) {
    const codeBlockKey = `${hConfigFile.key}_codeBlock_${codeBlock.sourcepos[0][0]}`;

    const data = codeBlock.literal;
    const mappings = GetSourceMapForCodeBlock(hConfigFile.key, codeBlock);

    const hwCodeBlock = await intermediateScope.Write(codeBlockKey);
    const hCodeBlock = await hwCodeBlock.WriteData(data, mappings, [hConfigFile]);
    result.push({
      data: hCodeBlock,
      codeBlock: codeBlock
    });
  }
  return result;
}

function* GetSourceMapForCodeBlock(sourceFileName: string, codeBlock: commonmark.Node): Mappings {
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

function* ParseCodeblocks(markdown: string): Iterable<commonmark.Node> {
  const parser = new commonmark.Parser();
  const parsed = parser.parse(markdown);
  const walker = parsed.walker();
  let event;
  while ((event = walker.next())) {
    var node = event.node;
    if (event.entering && node.type === "code_block") {
      yield node;
    }
  }
}