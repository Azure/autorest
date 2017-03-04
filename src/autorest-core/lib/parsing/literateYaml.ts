/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { descendants, Kind, cloneAst, YAMLMapping, newScalar, parseNode } from "../approved-imports/yaml";
import { mergeYamls, identitySourceMapping } from "../source-map/merging";
import { Mapping } from "../approved-imports/source-map";
import { DataHandleRead, DataHandleWrite, DataStoreView } from "../data-store/data-store";
import { parse as parseLiterate } from "./literate";
import { lines } from "./textUtility";

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

const commonmarkHeadingNodeType = "heading";
const commonmarkHeadingMaxLevel = 1000;

function commonmarkParentHeading(startNode: commonmark.Node): commonmark.Node | null {
  const currentLevel = startNode.type === commonmarkHeadingNodeType
    ? startNode.level
    : commonmarkHeadingMaxLevel;

  while (startNode != null && (startNode.type !== commonmarkHeadingNodeType || startNode.level >= currentLevel)) {
    startNode = startNode.prev || startNode.parent;
  }

  return startNode;
}

function* commonmarkSubHeadings(startNode: commonmark.Node): Iterable<commonmark.Node> {
  if (startNode.type === commonmarkHeadingNodeType) {
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
          return;
        }
      }
      startNode = startNode.next;
    }
  }
}

function commonmarkHeadingText(headingNode: commonmark.Node): string {
  return headingNode.firstChild.literal;
}

function commonmarkHeadingFollowingText(rawMarkdown: string, headingNode: commonmark.Node): [number, number] {
  let subNode = headingNode.next;
  const startPos = subNode.sourcepos[0];
  while (subNode.next && subNode.next.type !== "code_block" && subNode.next.type !== commonmarkHeadingNodeType) {
    subNode = subNode.next;
  }
  const endPos = subNode.sourcepos[1];

  return [startPos[0], endPos[0]];
}

/**
 * Resolves path of headings, starting with given heading node.
 * @param startHeading  Heading node to start from
 * @param path          List of headings to resolve starting with the `startHeading` INCLUSIVE
 * @returns Resolved heading node or null if heading was not found.
 */
function resolveMarkdownPathAt(startHeading: commonmark.Node, path: string[]): commonmark.Node | null {
  // unexpected node or path?
  if (startHeading.type !== commonmarkHeadingNodeType || path.length === 0 || commonmarkHeadingText(startHeading) !== path[0]) {
    return null;
  }
  path = path.slice(1);
  // found
  if (path.length == 0) {
    return startHeading;
  }
  // traverse down
  for (const subHeading of commonmarkSubHeadings(startHeading)) {
    const subResult = resolveMarkdownPathAt(subHeading, path);
    if (subResult !== null) {
      return subResult;
    }
  }
  return null;
}

/**
 * Tries resolving path of headings, moving up the hierachy of headings.
 */
function resolveMarkdownPath(startNode: commonmark.Node, path: string[]): commonmark.Node | null {
  const heading = commonmarkParentHeading(startNode);
  if (heading == null) {
    // last chance: start with root path
    return resolveMarkdownPathAt(startNode, path);
  }
  // try resolve from here
  const resolveResult = resolveMarkdownPathAt(heading, [commonmarkHeadingText(heading)].concat(path));
  if (resolveResult != null) {
    return resolveResult;
  }
  // move up hierachy
  return resolveMarkdownPath(heading, path);
}

export async function parse(hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<DataHandleRead> {
  let hsConfigFileBlocks: DataHandleRead[] = [];

  const rawMarkdown = await hLiterate.ReadData();

  // try parsing as literate YAML
  if (tryMarkdown(rawMarkdown)) {
    const scopeRawCodeBlocks = intermediateScope.CreateScope("raw");
    const scopeEnlightenedCodeBlocks = intermediateScope.CreateScope("enlightened");
    const hsConfigFileBlocksWithContext = await parseLiterate(hLiterate, scopeRawCodeBlocks);

    // resolve md documentation (ALPHA)
    let codeBlockIndex = 0;
    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      ++codeBlockIndex;
      const yamlAst = cloneAst(await (await data.ReadMetadata()).yamlAst);
      let mapping: Mapping[] = [];
      for (const { path, node } of descendants(yamlAst)) {
        if (path[path.length - 1] === "description" && node.kind === Kind.SEQ) {
          // resolve documentation
          const mdPath = parseNode<string[]>(node);
          const heading = resolveMarkdownPath(codeBlock, mdPath);
          if (heading == null) {
            throw new Error(`Heading at path ${mdPath} not found`); // TODO: uniform error reporting with blaming!
          }

          // extract markdown part
          const headingTextRange = commonmarkHeadingFollowingText(rawMarkdown, heading);
          const markdownLines = lines(rawMarkdown).slice(headingTextRange[0] - 1, headingTextRange[1]);
          const headingText = markdownLines.join("\n");

          // inject documentation
          (node.parent as YAMLMapping).value = newScalar(headingText);
          mapping.push({
            source: hLiterate.key,
            name: `literate ref ${JSON.stringify(mdPath)}`,
            generated: { path: path },
            original: <sourceMap.Position>{
              column: 0,
              line: headingTextRange[0]
            }
          });
        }
      }
      // detect changes. If any, remap, otherwise forward data
      if (mapping.length > 0) {
        mapping = mapping.concat(Array.from(identitySourceMapping(data.key, yamlAst)));
        const hTarget = await scopeEnlightenedCodeBlocks.Write(`${codeBlockIndex}.yaml`);
        hsConfigFileBlocks.push(await hTarget.WriteObject(parseNode(yamlAst), mapping, [hLiterate, data]));
      } else {
        hsConfigFileBlocks.push(data);
      }
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [hLiterate];
  }

  // merge
  return await mergeYamls(hsConfigFileBlocks, hResult);
}