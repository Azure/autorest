/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import {
  DataHandle,
  DataSink,
  IndexToPosition,
  ParseNode,
  createSandbox,
  StrictJsonSyntaxCheck,
} from "@azure-tools/datastore";
import { OperationAbortedException } from "../exceptions";
import { AutorestLogger } from "../logging";
import { mergeYamls, resolveRValue } from "../merging";
import { parseCodeBlocksFromMarkdown } from "./markdown-parser";

const safeEval = createSandbox();

export class CodeBlock {
  info!: string | null;
  data!: DataHandle;
}

function tryMarkdown(rawMarkdownOrYaml: string): boolean {
  return /^#/gm.test(rawMarkdownOrYaml);
}

export async function parse(logger: AutorestLogger, literate: DataHandle, sink: DataSink): Promise<DataHandle> {
  return parseInternal(logger, literate, sink);
}

export async function parseCodeBlocks(
  logger: AutorestLogger,
  literate: DataHandle,
  sink: DataSink,
): Promise<Array<CodeBlock>> {
  return parseCodeBlocksInternal(logger, literate, sink);
}

async function parseInternal(logger: AutorestLogger, hLiterate: DataHandle, sink: DataSink): Promise<DataHandle> {
  // merge the parsed codeblocks
  const blocks = (await parseCodeBlocksInternal(logger, hLiterate, sink)).map((each) => each.data);
  return mergeYamls(logger, blocks, sink);
}

async function parseCodeBlocksInternal(
  logger: AutorestLogger,
  hLiterate: DataHandle,
  sink: DataSink,
): Promise<Array<CodeBlock>> {
  let hsConfigFileBlocks: Array<CodeBlock> = [];

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
            code: "syntax_error", // TODO-TIM check this code.
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
          code: "syntax_error",
          message: `Syntax Error Encountered:  ${message}`,
          source: [{ position: IndexToPosition(data, index), document: data.key }],
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

export function evaluateGuard(rawFenceGuard: string, contextObject: any, forceAllVersionsMode = false): boolean {
  // extend the context object so that we can have some helper functions.
  contextObject = {
    ...contextObject,
    /** finds out if there is an extension being loaded already by a given name */
    isLoaded: (name: string) => {
      return (
        contextObject["used-extension"] &&
        !!contextObject["used-extension"].find((each: any) => each.startsWith(`["${name}"`))
      );
    },

    /** allows a check to see if a given extension is being requested already */
    isRequested: (name: string): boolean => {
      return contextObject["use-extension"]?.[name];
    },

    /** if they are specifying one or more profiles or api-versions, then they are   */
    enableAllVersionsMode: () => {
      return forceAllVersionsMode;
    },

    /** prints a debug message from configuration. sssshhh. don't use this.  */
    debugMessage: (text: string) => {
      // eslint-disable-next-line no-console
      console.log(text);
      return true;
    },
  };

  // trim the language from the front first
  let match = /^\S*\s*(.*)/.exec(rawFenceGuard);
  const fence = match && match[1];
  if (!fence) {
    // no fence at all.
    return true;
  }

  let guardResult = false;
  let expressionFence = "";
  try {
    if (!fence.includes("$(")) {
      try {
        return safeEval<boolean>(fence, contextObject);
      } catch (e) {
        //console.log(`1 failed to eval ${fence}`);
        return false;
      }
    }

    expressionFence = `${resolveRValue(fence, "", contextObject, null, 2)}`;
    // is there unresolved values?  May be old-style. Or the values aren't defined.

    // Let's run it only if there are no unresolved values for now.
    if (!expressionFence.includes("$(")) {
      return safeEval<boolean>(expressionFence, contextObject);
    }
  } catch (E) {
    // console.log(`2 failed to eval ${expressionFence}`);
    // not a legal expression?
  }

  // is this a single $( ... ) expression ?
  match = /^\$\((.*)\)$/.exec(fence.trim());

  const guardExpression = match && !match[1].includes("$(") && match[1];
  if (!guardExpression) {
    // Nope. this isn't an old style expression.
    // at best, it can be an expression that doesn't have all the values resolved.
    // let's resolve them to undefined and see what happens.

    try {
      return safeEval<boolean>(expressionFence.replace(/\$\(.*?\)/g, "undefined"), contextObject);
    } catch {
      // console.log(`3 failed to eval ${expressionFence.replace(/\$\(.*?\)/g, 'undefined')}`);
      try {
        return safeEval<boolean>(fence.replace(/\$\(.*?\)/g, "undefined"), contextObject);
      } catch {
        //console.log(`4 failed to eval ${fence.replace(/\$\(.*?\)/g, 'undefined')}`);
        return false;
      }
    }
  }

  // fall back to original behavior, where the whole expression is in the $( ... )
  const context = { $: contextObject, ...contextObject };

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
