/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import {
  DataHandle,
  DataSink,
  IndexToPosition,
  ParseNode,
  StrictJsonSyntaxCheck,
  Parse,
  Mapping,
} from "@azure-tools/datastore";
import { OperationAbortedException } from "../exceptions";
import { AutorestLogger } from "../logging";
import { identitySourceMapping, strictMerge } from "../merging";
import { LiterateYamlErrorCodes } from "./error-codes";
import { parseCodeBlocksFromMarkdown } from "./markdown-parser";

export interface CodeBlock {
  info: string | null;
  data: DataHandle;
}

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

export async function parse(logger: AutorestLogger, literate: DataHandle, sink: DataSink): Promise<DataHandle> {
  return parseInternal(logger, literate, sink);
}

async function parseInternal(logger: AutorestLogger, hLiterate: DataHandle, sink: DataSink): Promise<DataHandle> {
  // merge the parsed codeblocks
  const blocks = (await parseCodeBlocks(logger, hLiterate, sink)).map((each) => each.data);
  return mergeYamls(logger, blocks, sink);
}

export async function parseCodeBlocks(
  logger: AutorestLogger,
  hLiterate: DataHandle,
  sink: DataSink,
): Promise<CodeBlock[]> {
  let hsConfigFileBlocks: CodeBlock[] = [];

  const rawMarkdown = await hLiterate.ReadData();

  // try parsing as literate YAML
  if (tryMarkdown(rawMarkdown)) {
    const hsConfigFileBlocksWithContext = await parseCodeBlocksFromMarkdown(hLiterate, sink);

    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      // only consider YAML/JSON blocks
      if (!/^(yaml|json)/i.test(codeBlock.info || "")) {
        continue;
      }

      // super-quick JSON block syntax check.
      if (/^(json)/i.test(codeBlock.info || "")) {
        // check syntax on JSON blocks with simple check first
        const error = StrictJsonSyntaxCheck(await data.ReadData());
        if (error) {
          logger.trackError({
            code: LiterateYamlErrorCodes.jsonParsingError,
            message: `Syntax Error Encountered:  ${error.message}`,
            source: [{ position: IndexToPosition(data, error.index), document: data.key }],
          });
          throw new OperationAbortedException();
        }
      }

      let failing = false;
      const ast = await data.ReadYamlAst();

      // quick syntax check.
      ParseNode(ast, async (message, index) => {
        failing = true;
        logger.trackError({
          code: LiterateYamlErrorCodes.yamlParsingError,
          message: `Syntax Error Encountered:  ${message}`,
          source: [{ position: IndexToPosition(data, index), document: data.key }],
        });
      });

      if (failing) {
        throw new OperationAbortedException();
      }

      hsConfigFileBlocks.push({ info: codeBlock.info, data });
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [{ info: null, data: hLiterate }];
  }

  return hsConfigFileBlocks;
}

/**
 * Merge a set of yaml code blocks.
 * @param logger
 * @param yamlInputHandles
 * @param sink
 */
export async function mergeYamls(
  logger: AutorestLogger,
  yamlInputHandles: DataHandle[],
  sink: DataSink,
): Promise<DataHandle> {
  let mergedGraph: any = {};
  const mappings: Mapping[] = [];
  const cancel = false;
  let failed = false;

  //  ([] as string[]).concat(...x.map()) as an alternative for flatMap which is not availalbe on node 10.
  const newIdentity = ([] as string[]).concat(...yamlInputHandles.map((x) => x.identity));

  for (const yamlInputHandle of yamlInputHandles) {
    const rawYaml = await yamlInputHandle.ReadData();
    const inputGraph: any =
      Parse(rawYaml, (message, index) => {
        failed = true;
        if (logger) {
          logger.trackError({
            code: "yaml_parsing",
            message: message,
            source: [{ document: yamlInputHandle.key, position: IndexToPosition(yamlInputHandle, index) }],
          });
        }
      }) || {};

    mergedGraph = strictMerge(mergedGraph, inputGraph);
    const yaml = await yamlInputHandle.ReadYamlAst();
    for (const mapping of identitySourceMapping(yamlInputHandle.key, yaml)) {
      mappings.push(mapping);
    }
  }

  if (failed) {
    throw new Error("Syntax errors encountered.");
  }

  if (cancel) {
    throw new OperationAbortedException();
  }

  return sink.WriteObject("merged YAMLs", mergedGraph, newIdentity, undefined, mappings, yamlInputHandles);
}
