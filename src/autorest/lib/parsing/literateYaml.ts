/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { From } from "linq-es2015";
import { parseNode } from "../parsing/yaml";
import { descendantsWithPath, Kind, cloneAst } from "../parsing/yaml";
import { mergeYamls, identitySourceMapping } from "../source-map/merging";
import { Mapping } from "../source-map/sourceMap";
import { DataHandleRead, DataHandleWrite, DataStoreView } from "../data-store/dataStore";
import { parse as parseLiterate } from "./literate";

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
    console.log(startNode.type);
    startNode = startNode.prev || startNode.parent;
  }

  return startNode;
}

function* commonmarkSubHeadings(startNode: commonmark.Node): Iterable<commonmark.Node> {
  if (startNode.type === commonmarkHeadingNodeType) {
    const currentLevel = startNode.level;
    let minLevel = -1;

    while (startNode != null) {
      startNode = startNode.next;
      if (startNode.type === commonmarkHeadingNodeType) {
        if (minLevel <= startNode.level && startNode.level < currentLevel) {
          minLevel = startNode.level;
          yield startNode;
        } else {
          return;
        }
      }
    }
  }
}

/**
 * Resolves path of headings, starting with given heading node.
 * @param startHeading  Heading node to start from
 * @param path          List of headings to resolve starting with the `startHeading` INCLUSIVE
 * @returns Resolved heading node or null if heading was not found.
 */
function resolveMarkdownPathAt(startHeading: commonmark.Node, path: string[]): commonmark.Node | null {
  // unexpected node or path?
  if (startHeading.type !== commonmarkHeadingNodeType || path.length === 0 || startHeading.literal === path[0]) {
    return null;
  }
  // traverse down
  path = path.slice(1);
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
  const resolveResult = resolveMarkdownPathAt(heading, [heading.literal].concat(path));
  if (heading != null) {
    return resolveResult;
  }
  // move up hierachy
  return resolveMarkdownPath(heading, path);
}

export async function parse(hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<DataHandleRead> {
  let hsConfigFileBlocks: DataHandleRead[] = [];

  // try parsing as literate YAML
  if (tryMarkdown(await hLiterate.readData())) {
    const scopeRawCodeBlocks = intermediateScope.createScope("raw");
    const scopeEnlightenedCodeBlocks = intermediateScope.createScope("enlightened");
    const hsConfigFileBlocksWithContext = await parseLiterate(hLiterate, scopeRawCodeBlocks);

    // resolve md documentation (ALPHA)
    let codeBlockIndex = 0;
    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      ++codeBlockIndex;
      const yamlAst = cloneAst(await (await data.readMetadata()).yamlAst);
      let mapping: Mapping[] = [];
      for (const { path, node } of descendantsWithPath(yamlAst)) {
        if (path[path.length - 1] === "description" && node.kind === Kind.SEQ) {
          const mdPath = parseNode<string[]>(node);
          const heading = resolveMarkdownPath(codeBlock, mdPath);
        }
      }
      // detect changes. If any, remap, otherwise forward data
      if (mapping.length > 0) {
        mapping = mapping.concat(Array.from(identitySourceMapping(data.key, await data.readData())));
        const hTarget = await scopeEnlightenedCodeBlocks.write(`${codeBlockIndex}.yaml`);
        hsConfigFileBlocks.push(await hTarget.writeObject(parseNode(yamlAst), mapping));
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