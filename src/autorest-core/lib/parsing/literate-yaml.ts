/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OperationAbortedException } from "../exception";
import { ParseNode } from "../ref/yaml";
import { MergeYamls, resolveRValue } from "../source-map/merging";
import { DataHandleRead, DataHandleWrite, DataStoreView } from "../data-store/data-store";
import { Parse as ParseLiterate } from "./literate";
import { IndexToPosition } from "./text-utility";
import { ConfigurationView } from "../autorest-core";
import { Channel, SourceLocation } from "../message";
import { safeEval } from "../ref/safe-eval";

export class CodeBlock {
  info: string | null;
  data: DataHandleRead;
}

function TryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

export async function Parse(config: ConfigurationView, literate: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  const hRawDoc = await ParseInternal(config, literate, hwRawDoc, docScope);
  return hRawDoc;
}

export async function ParseCodeBlocks(config: ConfigurationView, literate: DataHandleRead, workingScope: DataStoreView): Promise<Array<CodeBlock>> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  return await ParseCodeBlocksInternal(config, literate, hwRawDoc, docScope);
}

async function ParseInternal(config: ConfigurationView, hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<DataHandleRead> {
  // merge the parsed codeblocks
  const blocks = (await ParseCodeBlocksInternal(config, hLiterate, hResult, intermediateScope)).map(each => each.data);
  return await MergeYamls(config, blocks, hResult);
}

async function ParseCodeBlocksInternal(config: ConfigurationView, hLiterate: DataHandleRead, hResult: DataHandleWrite, intermediateScope: DataStoreView): Promise<CodeBlock[]> {
  let hsConfigFileBlocks: CodeBlock[] = [];

  const rawMarkdown = hLiterate.ReadData();

  // try parsing as literate YAML
  if (TryMarkdown(rawMarkdown)) {
    const hsConfigFileBlocksWithContext = await ParseLiterate(hLiterate, intermediateScope);

    for (const { data, codeBlock } of hsConfigFileBlocksWithContext) {
      // only consider YAML/JSON blocks
      if (!/^(yaml|json)/i.test(codeBlock.info || "")) {
        continue;
      }

      // super-quick JSON block syntax check.
      if (/^(json)/i.test(codeBlock.info || "")) {
        // check syntax on JSON blocks with simple check first
        try {
          // quick check on data.
          JSON.parse(data.ReadData());
        } catch (e) {
          const index = parseInt(e.message.substring(e.message.lastIndexOf(" ")).trim());
          config.Message({
            Channel: Channel.Error,
            Text: "Syntax Error Encountered: " + e.message.substring(0, e.message.lastIndexOf("at")).trim(),
            Source: [<SourceLocation>{ Position: IndexToPosition(data, index), document: data.key }],
          });
          throw new OperationAbortedException();
        }
      }

      let failing = false;
      const ast = data.ReadYamlAst();

      // quick syntax check.
      ParseNode(ast, async (message, index) => {
        failing = true;
        config.Message({
          Channel: Channel.Error,
          Text: "Syntax Error Encountered: " + message,
          Source: [<SourceLocation>{ Position: IndexToPosition(data, index), document: data.key }],
        });
      });

      if (failing) {
        throw new OperationAbortedException();
      }

      // fairly confident of no immediate syntax errors.

      hsConfigFileBlocks.push({ info: codeBlock.info, data: data });
    }
  }

  // fall back to raw YAML
  if (hsConfigFileBlocks.length === 0) {
    hsConfigFileBlocks = [{ info: null, data: hLiterate }];
  }

  return hsConfigFileBlocks;
}

export function EvaluateGuard(rawFenceGuard: string, contextObject: any): boolean {
  // trim the language from the front first
  let match = /^\S*\s*(.*)/.exec(rawFenceGuard);
  let fence = match && match[1];
  if (!fence) {
    // no fence at all.
    return true;
  }

  let guardResult = false;
  let expressionFence: string = '';
  try {
    expressionFence = `${resolveRValue(fence, "", contextObject, null, 2)}`;
    // is there unresolved values?  May be old-style. Or the values aren't defined. 

    // Let's run it only if there are no unresolved values for now. 
    if (expressionFence.indexOf("$(") == -1) {
      return safeEval<boolean>(expressionFence);
    }
  } catch (E) {
    // not a legal expression?
  }

  // is this a single $( ... ) expression ?
  match = /^\$\((.*)\)$/.exec(fence.trim());

  const guardExpression = match && match[1].indexOf("$(") == -1 && match[1];
  if (!guardExpression) {
    // Nope. this isn't an old style expression.
    // at best, it can be an expression that doesn't have all the values resolved.
    // let's resolve them to undefined and see what happens.
    return safeEval<boolean>(fence.replace(/\$\(.*?\)/g, 'undefined'));
  }

  // fall back to original behavior, where the whole expression is in the $( ... )
  const context = Object.assign({ $: contextObject }, contextObject);

  try {
    guardResult = safeEval<boolean>(guardExpression, context);
  } catch (e) {
    try {
      guardResult = safeEval<boolean>("$['" + guardExpression + "']", context);
    } catch (e) {
      // at this point, it can only be an single-value expression that isn't resolved
      // which means return 'false'
    }
  }

  return guardResult;
}