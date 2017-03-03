/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as fs from "fs";
import * as path from "path";
import * as pify from "pify";

const fsAsync = pify(fs);

async function createDirectoryFor(filePath: string): Promise<void> {
  var dirname = path.dirname(filePath);
  if (!fs.existsSync(dirname)) {
    await createDirectoryFor(dirname);
    await fsAsync.mkdir(dirname);
  }
}

/**
 * Writes string to local file system.
 * @param fileName  Target file name.
 * @param data      String to write (encoding: UTF8).
 */
export async function writeString(fileName: string, data: string): Promise<void> {
  await createDirectoryFor(fileName);
  await fsAsync.writeFile(fileName, data);
}