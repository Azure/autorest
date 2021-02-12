import { createSandbox } from "@azure-tools/datastore";
import { resolveRValue } from "../merging";

const safeEval = createSandbox();

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
