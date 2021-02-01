/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import * as vm from "vm";

/**
 * A sandboxed eval function
 *
 * @deprecated consumers should create a local sandbox to reuse. (@see createSandbox )
 *  */
export const safeEval: <T>(code: string, context?: any) => T = createSandbox();

/**
 * Creates a reusable safe-eval sandbox to execute code in.
 */
export function createSandbox(): <T>(code: string, context?: any) => T {
  const sandbox = vm.createContext({});
  return (code: string, context?: any) => {
    const response = "SAFE_EVAL_" + Math.floor(Math.random() * 1000000);
    sandbox[response] = {};
    if (context) {
      for (const key of Object.keys(context)) {
        sandbox[key] = context[key];
      }
      vm.runInContext(`${response} = ${code}`, sandbox);
      for (const key of Object.keys(context)) {
        delete sandbox[key];
      }
    } else {
      vm.runInContext(`${response} = ${code}`, sandbox);
    }
    return sandbox[response];
  };
}
