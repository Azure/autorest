/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Descendants, Kind, CloneAst, YAMLMapping, newScalar, ParseNode } from "../approved-imports/yaml";
import { MergeYamls, IdentitySourceMapping } from "../source-map/merging";
import { Mapping } from "../approved-imports/source-map";
import { DataHandleRead, DataHandleWrite, DataStoreView } from "../data-store/data-store";
import { Parse as parseLiterate } from "./literate";
import { Lines } from "./text-utility";

function TryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

const commonmarkHeadingNodeType = "heading";
const commonmarkHeadingMaxLevel = 1000;

function CommonmarkParentHeading(startNode: commonmark.Node): commonmark.Node | null {
  const currentLevel = startNode.type === commonmarkHeadingNodeType
    ? startNode.level
    : commonmarkHeadingMaxLevel;

  while (startNode != null && (startNode.type !== commonmarkHeadingNodeType || startNode.level >= currentLevel)) {
    startNode = startNode.prev || startNode.parent;
  }

  return startNode;
}

function* CommonmarkSubHeadings(startNode: commonmark.Node): Iterable<commonmark.Node> {
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

function CommonmarkHeadingText(headingNode: commonmark.Node): string {
  return headingNode.firstChild.literal;
}

function CommonmarkHeadingFollowingText(rawMarkdown: string, headingNode: commonmark.Node): [number, number] {
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
function ResolveMarkdownPathAt(startHeading: commonmark.Node, path: string[]): commonmark.Node | null {
  // unexpected node or path?
  if (startHeading.type !== commonmarkHeadingNodeType || path.length === 0 || CommonmarkHeadingText(startHeading) !== path[0]) {
    return null;
  }
  path = path.slice(1);
  // found
  if (path.length == 0) {
    return startHeading;
  }
  // traverse down
  for (const subHeading of CommonmarkSubHeadings(startHeading)) {
    const subResult = ResolveMarkdownPathAt(subHeading, path);
    if (subResult !== null) {
      return subResult;
    }
  }
  return null;
}

/**
 * Tries resolving path of headings, moving up the hierachy of headings.
 */
function ResolveMarkdownPath(startNode: commonmark.Node, path: string[]): commonmark.Node | null {
  const heading = CommonmarkParentHeading(startNode);
  if (heading == null) {
    // last chance: start with root path
    return ResolveMarkdownPathAt(startNode, path);
  }
  // try resolve from here
  const resolveResult = ResolveMarkdownPathAt(heading, [CommonmarkHeadingText(heading)].concat(path));
  if (resolveResult != null) {
    return resolveResult;
  }
  // move up hierachy
  return ResolveMarkdownPath(heading, path);
}

export async function Parse(literate: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  const hRawDoc = await ParseInternal(literate, hwRawDoc, docScope);
  return hRawDoc;
}

async function ParseInternal(hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<DataHandleRead> {
  let hsConfigFileBlocks: DataHandleRead[] = [];

  const rawMarkdown = await hLiterate.ReadData();

  // try parsing as literate YAML
  if (TryMarkdown(rawMarkdown)) {
    const scopeRawCodeBlocks = intermediateScope.CreateScope("raw");
    const scopeEnlightenedCodeBlocks = intermediateScope.CreateScope("enlightened");
    const hsConfigFileBlocksWithContext = await parseLiterate(hLiterate, scopeRawCodeBlocks);

    // resolve md documentation (ALPHA)
    let codeBlockIndex = 0;
    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      ++codeBlockIndex;
      const yamlAst = CloneAst(await data.ReadYamlAst());
      let mapping: Mapping[] = [];
      for (const { path, node } of Descendants(yamlAst)) {
        if (path[path.length - 1] === "description" && node.kind === Kind.SEQ) {
          // resolve documentation
          const mdPath = ParseNode<string[]>(node);
          const heading = ResolveMarkdownPath(codeBlock, mdPath);
          if (heading == null) {
            throw new Error(`Heading at path ${mdPath} not found`); // TODO: uniform error reporting with blaming!
          }

          // extract markdown part
          const headingTextRange = CommonmarkHeadingFollowingText(rawMarkdown, heading);
          const markdownLines = Lines(rawMarkdown).slice(headingTextRange[0] - 1, headingTextRange[1]);
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
        mapping = mapping.concat(Array.from(IdentitySourceMapping(data.key, yamlAst)));
        const hTarget = await scopeEnlightenedCodeBlocks.Write(`${codeBlockIndex}.yaml`);
        hsConfigFileBlocks.push(await hTarget.WriteObject(ParseNode(yamlAst), mapping, [hLiterate, data]));
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
  return await MergeYamls(hsConfigFileBlocks, hResult);
}