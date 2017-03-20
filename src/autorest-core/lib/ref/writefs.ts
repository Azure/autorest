/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as fs from "fs";
import * as path from "path";
import * as pify from "pify";
import { parse } from "url";

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
  const uri = parse(fileUri);
  if (uri.protocol !== "file:") {
    throw `Protocol '${uri.protocol}' not supported for writing.`;
  }
  // convert to path
  let p = uri.path;
  if (p === undefined) {
    throw `Cannot write to '${uri}'. Path not found.`;
  }
  if (path.sep === "\\") {
    p = p.substr(p.startsWith("/") ? 1 : 0);
    p = p.replace(/\//g, "\\");
  }
  return WriteStringInternal(p, data);
}