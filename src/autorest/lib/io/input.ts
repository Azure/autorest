/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// untyped imports
const getUri = require("get-uri");
const fileUri: (path: string, options: { resolve: boolean }) => string = require("file-url");

import { isAbsolute } from "path";
import * as promisify from "pify";
import { Readable } from "stream";
import * as URI from "urijs";

const getUriAsync: (uri: string) => Promise<Readable> = promisify(getUri);

export async function readUri(uri: string): Promise<string> {
  const readable = await getUriAsync(uri);

  const readAll = new Promise<string>(function (resolve, reject) {
    let result = "";
    readable.on("data", data => result += data.toString());
    readable.on("end", () => resolve(result));
    readable.on("error", err => reject(err));
  });

  return await readAll;
}

export function createFileUri(path: string): string {
  return fileUri(path, { resolve: false });
}

/**
 * The singularity of all resolving.
 * With URI as our one data type of truth, this method maps an absolute or relative path or URI to a URI using given base URI.
 * @param baseUri   Absolute base URI
 * @param pathOrUri Relative/absolute path/URI
 * @returns Absolute URI
 */
export function resolveUri(baseUri: string, pathOrUri: string): string {
  if (isAbsolute(pathOrUri)) {
    return createFileUri(pathOrUri);
  }
  if (!baseUri) {
    throw "'pathOrUri' was detected to be relative so 'baseUri' is required";
  }
  return new URI(pathOrUri).absoluteTo(baseUri).toString();
}