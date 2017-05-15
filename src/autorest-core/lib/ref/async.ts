/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as fs from "fs";
import * as path from "path";
import * as promisify from "pify";

export const mkdir: (path: string | Buffer) => Promise<void> = promisify(fs.mkdir);
export const exists: (path: string | Buffer) => Promise<boolean> = path => Promise.resolve(fs.existsSync(path)); // async one deprecated! (TODO: replace with call to stat)
export const readdir: (path: string | Buffer) => Promise<Array<string>> = promisify(fs.readdir);
export const close: (fd: number) => Promise<void> = promisify(fs.close);
export const readFile: (filename: string) => Promise<string> = promisify(fs.readFile);
export const writeFile: (filename: string, content: string) => Promise<void> = (filename, content) => Promise.resolve(fs.writeFileSync(filename, content)); // for some reason writeFile only produced empty files

