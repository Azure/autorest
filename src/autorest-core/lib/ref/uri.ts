/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export function IsUri(uri: string): boolean {
  return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
}

/***********************
 * Data aquisition
 ***********************/
import * as promisify from "pify";
import { Readable } from "stream";
import { parse } from "url";
import { sep } from "path";
// polyfills for language support
require("../polyfill.min.js");

const stripBom: (text: string) => string = require("strip-bom");
const getUri = require("get-uri");
const getUriAsync: (uri: string) => Promise<Readable> = promisify(getUri);

/**
 * Loads a UTF8 string from given URI.
 */
export async function ReadUri(uri: string): Promise<string> {
  try {
    const readable = await getUriAsync(uri);

    const readAll = new Promise<string>(function (resolve, reject) {
      let result = "";
      readable.on("data", data => result += data.toString());
      readable.on("end", () => resolve(result));
      readable.on("error", err => reject(err));
    });

    return stripBom(await readAll);
  } catch (e) {
    throw new Error(`Failed to load '${uri}' (${e})`);
  }
}

export async function ExistsUri(uri: string): Promise<boolean> {
  try {
    await ReadUri(uri);
    return true;
  } catch (e) {
    return false;
  }
}


/***********************
 * URI manipulation
 ***********************/
import { dirname } from "path";
const URI = require("urijs");
const fileUri: (path: string, options: { resolve: boolean }) => string = require("file-url");

// remake of path.isAbsolute... because it's platform dependent:
// Windows: C:\\... -> true    /... -> true
// Linux:   C:\\... -> false   /... -> true
function isAbsolute(path: string): boolean {
  return !!path.match(/^(\/|[a-zA-Z]:\\)/);
}

/**
 * Create a 'file:///' URI from given absolute path.
 * Examples:
 * - "C:\swagger\storage.yaml" -> "file:///C:/swagger/storage.yaml"
 * - "/input/swagger.yaml" -> "file:///input/swagger.yaml"
 */
export function CreateFileUri(absolutePath: string): string {
  if (!isAbsolute(absolutePath)) {
    throw new Error("Can only create file URIs from absolute paths.");
  }
  return EnsureIsFileUri(fileUri(absolutePath, { resolve: false }));
}
export function CreateFolderUri(absolutePath: string): string {
  return EnsureIsFolderUri(CreateFileUri(absolutePath));
}

export function EnsureIsFolderUri(uri: string) {
  return EnsureIsFileUri(uri) + "/";
}
export function EnsureIsFileUri(uri: string) {
  return uri.replace(/\/$/g, "");
}

export function GetFilename(uri: string) {
  return uri.split("/").reverse()[0].split("\\").reverse()[0];
}

export function GetFilenameWithoutExtension(uri: string) {
  const lastPart = GetFilename(uri);
  const ext = lastPart.indexOf(".") === -1 ? "" : lastPart.split(".").reverse()[0];
  return lastPart.substr(0, lastPart.length - ext.length - 1);
}

/**
 * The singularity of all resolving.
 * With URI as our one data type of truth, this method maps an absolute or relative path or URI to a URI using given base URI.
 * @param baseUri   Absolute base URI
 * @param pathOrUri Relative/absolute path/URI
 * @returns Absolute URI
 */
export function ResolveUri(baseUri: string, pathOrUri: string): string {
  if (isAbsolute(pathOrUri)) {
    return CreateFileUri(pathOrUri);
  }
  pathOrUri = pathOrUri.replace(/\\/g, "/");
  if (!baseUri) {
    throw new Error("'pathOrUri' was detected to be relative so 'baseUri' is required");
  }
  return new URI(pathOrUri).absoluteTo(baseUri).toString();
}

export function ParentFolderUri(uri: string): string | null {
  // root?
  if (uri.endsWith("//")) {
    return null;
  }
  // folder? => cut away last "/"
  if (uri.endsWith("/")) {
    uri = uri.slice(0, uri.length - 1);
  }
  // cut away last component
  const compLen = uri.split("/").reverse()[0].length;
  return uri.slice(0, uri.length - compLen);
}

/***********************
 * OS abstraction (writing files, enumerating files)
 ***********************/
import { readdir, mkdir, exists, writeFile } from "./async";
import { lstatSync } from "fs";

function isAccessibleFile(localPath: string) {
  try {
    return lstatSync(localPath).isFile();
  } catch (e) {
    return false;
  }
}

function FileUriToLocalPath(fileUri: string): string {
  const uri = parse(fileUri);
  if (uri.protocol !== "file:") {
    throw new Error(`Protocol '${uri.protocol}' not supported for writing.`);
  }
  // convert to path
  let p = uri.path;
  if (p === undefined) {
    throw new Error(`Cannot write to '${uri}'. Path not found.`);
  }
  if (sep === "\\") {
    p = p.substr(p.startsWith("/") ? 1 : 0);
    p = p.replace(/\//g, "\\");
  }
  return p;
}

export async function* EnumerateFiles(folderUri: string, probeFiles: string[] = []): AsyncIterable<string> {
  folderUri = EnsureIsFolderUri(folderUri);
  if (folderUri.startsWith("file:")) {
    let files: string[] = [];
    try {
      files = await readdir(FileUriToLocalPath(folderUri));
    } catch (e) { }
    yield* files
      .map(f => ResolveUri(folderUri, f))
      .filter(f => isAccessibleFile(FileUriToLocalPath(f)));
  } else {
    for (const candid of probeFiles.map(f => ResolveUri(folderUri, f))) {
      if (await ExistsUri(candid)) {
        yield candid;
      }
    }
  }
}

async function CreateDirectoryFor(filePath: string): Promise<void> {
  var dir: string = dirname(filePath);
  if (!await exists(dir)) {
    await CreateDirectoryFor(dir);
    try {
      await mkdir(dir);
    } catch (e) {
      // mkdir throws if directory already exists - which happens occasionally due to race conditions
    }
  }
}

async function WriteStringInternal(fileName: string, data: string): Promise<void> {
  await CreateDirectoryFor(fileName);
  await writeFile(fileName, data);
}

/**
 * Writes string to local file system.
 * @param fileUri  Target file uri.
 * @param data     String to write (encoding: UTF8).
 */
export function WriteString(fileUri: string, data: string): Promise<void> {
  return WriteStringInternal(FileUriToLocalPath(fileUri), data);
}