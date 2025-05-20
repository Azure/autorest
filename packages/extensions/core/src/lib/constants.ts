/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { existsSync } from "fs";
import * as path from "path";

const resolveAppRoot = () => {
  let current = path.resolve(__dirname);
  while (!existsSync(path.join(current, "package.json"))) {
    current = path.dirname(current);
  }
  return current;
};

/**
 * Root of autorest core(i.e core folder)
 */
export const AppRoot = resolveAppRoot();

/**
 * Version of this package.
 */
// eslint-disable-next-line @typescript-eslint/no-require-imports
export const VERSION = require("../../package.json").version;
