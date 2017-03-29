import * as fs from "fs";
import * as path from "path";
import * as promisify from "pify";

export const readdir: (path: string | Buffer) => Promise<Array<string>> = promisify(fs.readdir);
export const close: (fd: number) => Promise<void> = promisify(fs.close);
export const readFile: (filename: string) => Promise<string> = promisify(fs.readFile);
export const writeFile: (filename: string, content: string) => Promise<void> = promisify(fs.readFile);