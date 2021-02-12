/* eslint-disable @typescript-eslint/no-use-before-define */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, Mapping } from "@azure-tools/datastore";
import * as commonmark from "commonmark";

/**
 * Retrieve all code blocks in the markdown file
 * @param hConfigFile DataHandle for the markdown config file.
 * @param sink Data sink.
 */
export async function parseCodeBlocksFromMarkdown(
  hConfigFile: DataHandle,
  sink: DataSink,
): Promise<Array<{ data: DataHandle; codeBlock: commonmark.Node }>> {
  const result: Array<{ data: DataHandle; codeBlock: commonmark.Node }> = [];
  const rawMarkdown = await hConfigFile.ReadData();
  for (const codeBlock of parseCodeblocks(rawMarkdown)) {
    const codeBlockKey = `codeBlock_${codeBlock.sourcepos[0][0]}`;

    const data = codeBlock.literal || "";
    const mappings = getSourceMapForCodeBlock(hConfigFile.key, codeBlock);

    const hCodeBlock = await sink.WriteData(codeBlockKey, data, hConfigFile.identity, undefined, mappings, [
      hConfigFile,
    ]);
    result.push({
      data: hCodeBlock,
      codeBlock,
    });
  }
  return result;
}

function getSourceMapForCodeBlock(sourceFileName: string, codeBlock: commonmark.Node): Array<Mapping> {
  const result = new Array<Mapping>();
  const numLines = codeBlock.sourcepos[1][0] - codeBlock.sourcepos[0][0] + (codeBlock.info === null ? 1 : -1);
  for (let i = 0; i < numLines; ++i) {
    result.push({
      generated: {
        line: i + 1,
        column: 0,
      },
      original: {
        line: i + codeBlock.sourcepos[0][0] + (codeBlock.info === null ? 0 : 1),
        column: codeBlock.sourcepos[0][1] - 1,
      },
      source: sourceFileName,
      name: `Codeblock line '${i + 1}'`,
    });
  }
  return result;
}

export function parseCommonmark(markdown: string): commonmark.Node {
  return new commonmark.Parser().parse(markdown);
}

function* parseCodeblocks(markdown: string): Iterable<commonmark.Node> {
  const parsed = parseCommonmark(markdown);
  const walker = parsed.walker();
  let event;
  while ((event = walker.next())) {
    const node = event.node;
    if (event.entering && node.type === "code_block") {
      yield node;
    }
  }
}

const commonmarkHeadingNodeType = "heading";
const commonmarkHeadingMaxLevel = 1000;

export function* commonmarkSubHeadings(startNode: commonmark.Node | null): Iterable<commonmark.Node> {
  if (startNode && (startNode.type === commonmarkHeadingNodeType || !startNode.prev)) {
    const currentLevel = startNode.level;
    let maxLevel = commonmarkHeadingMaxLevel;

    startNode = startNode.next;
    while (startNode != null) {
      if (startNode.type === commonmarkHeadingNodeType) {
        if (currentLevel < startNode.level) {
          if (startNode.level <= maxLevel) {
            maxLevel = startNode.level;
            yield startNode;
          }
        } else {
          break;
        }
      }
      startNode = startNode.next;
    }
  }
}

export function commonmarkHeadingText(headingNode: commonmark.Node): string {
  let text = "";
  let node = headingNode.firstChild;
  while (node) {
    text += node.literal;
    node = node.next;
  }
  return text;
}

export function commonmarkHeadingFollowingText(headingNode: commonmark.Node): [number, number] {
  let subNode = headingNode.next;
  if (subNode === null) {
    throw new Error("No node found after heading node");
  }
  const startPos = subNode.sourcepos[0];
  while (
    subNode.next &&
    subNode.next.type !== "code_block" &&
    subNode.next.type !== commonmarkHeadingNodeType /* || subNode.next.level > headingNode.level*/
  ) {
    subNode = subNode.next;
  }
  const endPos = subNode.sourcepos[1];

  return [startPos[0], endPos[0]];
}
