/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { FileUriToPath } from './uri';
import * as fs from "fs";
import * as path from "path";
import * as pify from "pify";

const fsAsync = pify(fs);

async function createDirectoryFor(filePath: string): Promise<void> {
  var dirname = path.dirname(filePath);
  if (!fs.existsSync(dirname)) {
    await createDirectoryFor(dirname);
    try {
      await fsAsync.mkdir(dirname);
    } catch (e) {
      // mkdir throws if directory already exists - which happens occasionally due to race conditions
    }
  }
}

async function WriteStringInternal(fileName: string, data: string): Promise<void> {
  await createDirectoryFor(fileName);
  await fsAsync.writeFile(fileName, data);
}

/**
 * Writes string to local file system.
 * @param fileUri  Target file uri.
 * @param data     String to write (encoding: UTF8).
 */
export function WriteString(fileUri: string, data: string): Promise<void> {
  return WriteStringInternal(FileUriToPath(fileUri), data);
}