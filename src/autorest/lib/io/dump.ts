/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as fs from "fs";
import * as path from "path";
import * as pify from "pify";

const fsAsync = pify(fs);

async function ensureDirectoryExistence(filePath: string): Promise<void> {
  var dirname = path.dirname(filePath);
  if (!fs.existsSync(dirname)) {
    await ensureDirectoryExistence(dirname);
    await fsAsync.mkdir(dirname);
  }
}

export async function dumpString(fileName: string, data: string) {
  await ensureDirectoryExistence(fileName);
  await fsAsync.writeFile(fileName, data);
}