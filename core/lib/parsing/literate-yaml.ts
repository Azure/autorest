/* eslint-disable @typescript-eslint/no-use-before-define */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, IndexToPosition, ParseNode, safeEval, StrictJsonSyntaxCheck } from '@azure-tools/datastore';
import { ConfigurationView } from '../autorest-core';
import { OperationAbortedException } from '../exception';
import { Channel, SourceLocation } from '../message';
import { MergeYamls, resolveRValue } from '../source-map/merging';
import { parse as ParseLiterate } from './literate';

export class CodeBlock {
  info!: string | null;
  data!: DataHandle;
}

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

export async function parse(config: ConfigurationView, literate: DataHandle, sink: DataSink): Promise<DataHandle> {
  return parseInternal(config, literate, sink);
}

export async function parseCodeBlocks(config: ConfigurationView, literate: DataHandle, sink: DataSink): Promise<Array<CodeBlock>> {
  return parseCodeBlocksInternal(config, literate, sink);
}

async function parseInternal(config: ConfigurationView, hLiterate: DataHandle, sink: DataSink): Promise<DataHandle> {
  // merge the parsed codeblocks
  const blocks = (await parseCodeBlocksInternal(config, hLiterate, sink)).map(each => each.data);
  return MergeYamls(config, blocks, sink);
}

async function parseCodeBlocksInternal(config: ConfigurationView, hLiterate: DataHandle, sink: DataSink): Promise<Array<CodeBlock>> {
  let hsConfigFileBlocks: Array<CodeBlock> = [];

  const rawMarkdown = await hLiterate.ReadData();

  // try parsing as literate YAML
  if (tryMarkdown(rawMarkdown)) {
    const hsConfigFileBlocksWithContext = await ParseLiterate(hLiterate, sink);

    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      // only consider YAML/JSON blocks
      if (!/^(yaml|json)/i.test(codeBlock.info || '')) {
        continue;
      }

      // super-quick JSON block syntax check.
      if (/^(json)/i.test(codeBlock.info || '')) {
        // check syntax on JSON blocks with simple check first
        const error = StrictJsonSyntaxCheck(await data.ReadData());
        if (error) {
          config.Message({
            Channel: Channel.Error,
            Text: `Syntax Error Encountered:  ${error.message}`,
            Source: [<SourceLocation>{ Position: IndexToPosition(data, error.index), document: data.key }],
          });
          throw new OperationAbortedException();
        }
      }

      let failing = false;
      const ast = await data.ReadYamlAst();

      // quick syntax check.
      ParseNode(ast, async (message, index) => {
        failing = true;
        config.Message({
          Channel: Channel.Error,
          Text: `Syntax Error Encountered:  ${message}`,
          Source: [<SourceLocation>{ Position: IndexToPosition(data, index), document: data.key }],
        });
      });

      if (failing) {
        throw new OperationAbortedException();
      }

      // fairly confident of no immediate syntax errors.

      hsConfigFileBlocks.push({ info: codeBlock.info, data });
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [{ info: null, data: hLiterate }];
  }

  return hsConfigFileBlocks;
}

export function evaluateGuard(rawFenceGuard: string, contextObject: any): boolean {
  // trim the language from the front first
  let match = /^\S*\s*(.*)/.exec(rawFenceGuard);
  const fence = match && match[1];
  if (!fence) {
    // no fence at all.
    return true;
  }

  let guardResult = false;
  let expressionFence = '';
  try {
    if (!fence.includes('$(')) {
      try {
        return safeEval<boolean>(fence);
      } catch (e) {
        return false;
      }
    }

    expressionFence = `${resolveRValue(fence, '', contextObject, null, 2)}`;
    // is there unresolved values?  May be old-style. Or the values aren't defined.

    // Let's run it only if there are no unresolved values for now.
    if (!expressionFence.includes('$(')) {
      return safeEval<boolean>(expressionFence);
    }
  } catch (E) {
    // not a legal expression?
  }

  // is this a single $( ... ) expression ?
  match = /^\$\((.*)\)$/.exec(fence.trim());

  const guardExpression = match && !match[1].includes('$(') && match[1];
  if (!guardExpression) {
    // Nope. this isn't an old style expression.
    // at best, it can be an expression that doesn't have all the values resolved.
    // let's resolve them to undefined and see what happens.

    try {
      return safeEval<boolean>(expressionFence.replace(/\$\(.*?\)/g, 'undefined'));
    } catch {
      return safeEval<boolean>(fence.replace(/\$\(.*?\)/g, 'undefined'));
    }
  }

  // fall back to original behavior, where the whole expression is in the $( ... )
  const context = { $: contextObject, ...contextObject };

  try {
    guardResult = safeEval<boolean>(guardExpression, context);
  } catch (e) {
    try {
      guardResult = safeEval<boolean>('$[\'' + guardExpression + '\']', context);
    } catch (e) {
      // at this point, it can only be an single-value expression that isn't resolved
      // which means return 'false'
    }
  }

  return guardResult;
}
