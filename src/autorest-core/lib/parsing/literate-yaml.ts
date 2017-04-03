/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Descendants, Kind, CloneAst, YAMLMapping, newScalar, ParseNode } from "../ref/yaml";
import { MergeYamls, IdentitySourceMapping } from "../source-map/merging";
import { Mapping } from "../ref/source-map";
import { DataHandleRead, DataHandleWrite, DataStoreView } from "../data-store/data-store";
import { Parse as ParseLiterate } from "./literate";
import { Lines } from "./text-utility";
import { ConfigurationView } from '../autorest-core';
import { Channel, Message, SourceLocation } from '../message';

export class CodeBlock {
  info: string | null;
  data: DataHandleRead;
}

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
          break;
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

export async function Parse(config: ConfigurationView, literate: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  const hRawDoc = await ParseInternal(config, literate, hwRawDoc, docScope);
  return hRawDoc;
}

export async function ParseCodeBlocks(config: ConfigurationView | null, literate: DataHandleRead, workingScope: DataStoreView): Promise<Array<CodeBlock>> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  return await ParseCodeBlocksInternal(config, literate, hwRawDoc, docScope);
}

async function ParseInternal(config: ConfigurationView | null, hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<DataHandleRead> {
  // merge the parsed codeblocks
  const blocks = (await ParseCodeBlocksInternal(config, hLiterate, hResult, intermediateScope)).map(each => each.data);
  return await MergeYamls(blocks, hResult);
}


async function ParseCodeBlocksInternal(config: ConfigurationView | null, hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<CodeBlock[]> {
  let hsConfigFileBlocks: CodeBlock[] = [];

  const rawMarkdown = await hLiterate.ReadData();

  // try parsing as literate YAML
  if (TryMarkdown(rawMarkdown)) {
    const scopeRawCodeBlocks = intermediateScope.CreateScope("raw");
    const scopeEnlightenedCodeBlocks = intermediateScope.CreateScope("enlightened");
    const hsConfigFileBlocksWithContext = await ParseLiterate(hLiterate, scopeRawCodeBlocks);

    // resolve md documentation (ALPHA)
    let codeBlockIndex = 0;
    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      ++codeBlockIndex;

      const deferredErrors: Message[] = []; // ...because the file we wanna blame is not yet written

      const yamlAst = CloneAst(await data.ReadYamlAst());
      let mapping: Mapping[] = [];
      for (const { path, node } of Descendants(yamlAst)) {
        // RESOLVE MARKDOWN INTO THE YAML
        if ((path[path.length - 1] === "description" || path[path.length - 1] === "summary") && node.kind === Kind.SEQ) {
          // resolve documentation
          const mdPath = ParseNode<string[]>(node);
          const heading = ResolveMarkdownPath(codeBlock, mdPath);
          if (heading == null) {
            deferredErrors.push({
              Channel: Channel.Error,
              Text: `Heading at path ${mdPath} not found`,
              Source: [<SourceLocation>{ Position: { path: path }, document: hLiterate.key }]
            });
            continue;
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

      let outputKey: string;

      // detect changes. If any, remap, otherwise forward data
      if (mapping.length > 0) {
        mapping = mapping.concat([...IdentitySourceMapping(data.key, yamlAst)]);
        const hTarget = await scopeEnlightenedCodeBlocks.Write(`${codeBlockIndex}.yaml`);
        hsConfigFileBlocks.push({ info: codeBlock.info, data: await hTarget.WriteObject(ParseNode(yamlAst), mapping, [hLiterate, data]) });
        outputKey = hTarget.key;
      } else {
        hsConfigFileBlocks.push({ info: codeBlock.info, data: data });
        outputKey = data.key;
      }

      // post errors
      if (config !== null) {
        deferredErrors.forEach(err => config.Error.Dispatch(err));
      }
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [{ info: null, data: hLiterate }];
  }

  return hsConfigFileBlocks;
}