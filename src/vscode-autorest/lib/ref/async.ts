import * as fs from "fs";
import * as path from "path";
import * as promisify from "pify";

export const readdir: (path: string | Buffer) => Promise<Array<string>> = promisify(fs.readdir);
export const close: (fd: number) => Promise<void> = promisify(fs.close);
export const readFile: (filename: string, encoding: string) => Promise<string> = promisify(fs.readFile);
export const writeFile: (filename: string, content: string) => Promise<void> = promisify(fs.writeFile);
export const stat: (path: string | Buffer) => Promise<fs.Stats> = promisify(fs.stat);
export const exists: (path: string) => Promise<boolean> = async (path) => {
  try {
    await stat(path);
    return true;
  } catch (e) {
  }
  return false;
}

export const isDirectory: (path: string) => Promise<boolean> = async (path) => {
  try {
    return (await stat(path)).isDirectory()
  } catch (e) {
  }
  return false;
}

