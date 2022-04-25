/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OperationAbortedException, AutorestLogger } from "@autorest/common";
import { DataHandle, DataSink, indexToPosition } from "@azure-tools/datastore";
import { validateJson } from "@azure-tools/json";
import { getYamlNodeValue } from "@azure-tools/yaml";
import { LiterateYamlErrorCodes } from "./error-codes";
import { parseCodeBlocksFromMarkdown } from "./markdown-parser";

export interface CodeBlock {
  info: string | null;
  data: DataHandle;
}

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

/**
 * Parse an autorest config file either in markdown format(with multiple code blocks and guard) or as a yaml/json file.
 * @param logger Logger.
 * @param file File to parse.
 * @param sink Data sink
 * @returns List of parsed config blocks if markdown or a single one if a yaml/json file.
 */
export async function parseConfigFile(logger: AutorestLogger, file: DataHandle, sink: DataSink): Promise<CodeBlock[]> {
  let hsConfigFileBlocks: CodeBlock[] = [];

  // try parsing as literate YAML
  if (file.originalFullPath.toLowerCase().endsWith(".md") || tryMarkdown(await file.readData())) {
    const hsConfigFileBlocksWithContext = await parseCodeBlocksFromMarkdown(file, sink);

    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      // only consider YAML/JSON blocks
      if (!/^(yaml|json)/i.test(codeBlock.info || "")) {
        continue;
      }

      // super-quick JSON block syntax check.
      if (/^(json)/i.test(codeBlock.info || "")) {
        // check syntax on JSON blocks with simple check first
        const error = validateJson(await data.readData());
        if (error) {
          logger.trackError({
            code: LiterateYamlErrorCodes.jsonParsingError,
            message: `Syntax Error Encountered:  ${error.message}`,
            source: [{ position: await indexToPosition(data, error.position), document: data.key }],
          });
          throw new OperationAbortedException();
        }
      }

      const ast = await data.readYamlAst();

      // quick syntax check.
      const { errors } = getYamlNodeValue(ast);

      if (errors.length > 0) {
        for (const { message, position } of errors) {
          logger.trackError({
            code: LiterateYamlErrorCodes.yamlParsingError,
            message: `Syntax Error Encountered:  ${message}`,
            source: [{ position: await indexToPosition(data, position), document: data.key }],
          });
        }
        throw new OperationAbortedException();
      }

      hsConfigFileBlocks.push({ info: codeBlock.info, data });
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [{ info: null, data: file }];
  }

  return hsConfigFileBlocks;
}
