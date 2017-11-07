/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import * as fs from "fs";

export function mkdir(path: string | Buffer): Promise<void> {
  return new Promise((r, j) => fs.mkdir(path, (err) => err ? j(err) : r()))
}
export const exists: (path: string | Buffer) => Promise<boolean> = path => new Promise<boolean>((r, j) => fs.stat(path, (err: NodeJS.ErrnoException, stats: fs.Stats) => err ? r(false) : r(true)));

export function readdir(path: string): Promise<Array<string>> {
  return new Promise((r, j) => fs.readdir(path, (err, files) => err ? j(err) : r(files)));
}
export function close(fd: number): Promise<void> {
  return new Promise((r, j) => fs.close(fd, (err) => err ? j(err) : r()));
}
export function readFile(path: string, options?: { encoding?: string | null; flag?: string; }): Promise<string | Buffer> {
  return new Promise((r, j) => fs.readFile(path, options, (err, data) => err ? j(err) : r(data)));
}
export function writeFile(filename: string, content: string): Promise<void> {
  return new Promise((r, j) => fs.writeFile(filename, content, (err) => err ? j(err) : r()))
}