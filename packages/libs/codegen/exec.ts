/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { isDirectory, isFile, readdir } from "@azure-tools/async-io";
import { spawn } from "child_process";
import * as path from "path";

export function cmdlineToArray(
  text: string,
  result: Array<string> = [],
  matcher = /[^\s"]+|"([^"]*)"/gi,
  count = 0,
): Array<string> {
  text = text.replace(/\\"/g, "\ufffe");
  const match = matcher.exec(text);
  return match
    ? cmdlineToArray(
        text,
        result,
        matcher,
        result.push(match[1] ? match[1].replace(/\ufffe/g, '\\"') : match[0].replace(/\ufffe/g, '\\"')),
      )
    : result;
}

function getPathVariableName() {
  // windows calls it's path 'Path' usually, but this is not guaranteed.
  if (process.platform === "win32") {
    let PATH = "Path";
    Object.keys(process.env).forEach(function (e) {
      if (e.match(/^PATH$/i)) {
        PATH = e;
      }
    });
    return PATH;
  }
  return "PATH";
}
async function realPathWithExtension(command: string): Promise<string | undefined> {
  const pathExt = (process.env.pathext || ".EXE").split(";");
  for (const each of pathExt) {
    const filename = `${command}${each}`;
    if (await isFile(filename)) {
      return filename;
    }
  }
  return undefined;
}

async function getFullPath(
  command: string,
  recursive = false,
  searchPath?: Array<string>,
): Promise<string | undefined> {
  command = command.replace(/"/g, "");
  const ext = path.extname(command);

  if (path.isAbsolute(command)) {
    // if the file has an extension, or we're not on win32, and this is an actual file, use it.
    if (ext || process.platform !== "win32") {
      if (await isFile(command)) {
        return command;
      }
    }

    // if we're on windows, look for a file with an acceptable extension.
    if (process.platform === "win32") {
      // try all the PATHEXT extensions to see if it is a recognized program
      const cmd = await realPathWithExtension(command);
      if (cmd) {
        return cmd;
      }
    }
    return undefined;
  }

  if (searchPath) {
    for (const folder of searchPath) {
      let fullPath = await getFullPath(path.resolve(folder, command));
      if (fullPath) {
        return fullPath;
      }
      if (recursive) {
        try {
          for (const entry of await readdir(folder)) {
            const folderPath = path.resolve(folder, entry);

            if (await isDirectory(folderPath)) {
              fullPath =
                (await getFullPath(path.join(folderPath, command))) || (await getFullPath(command, true, [folderPath]));
              if (fullPath) {
                return fullPath;
              }
            }
          }
        } catch {
          // ignore failures
        }
      }
    }
  }

  return undefined;
}

function quoteIfNecessary(text: string): string {
  if (text && text.indexOf(" ") > -1 && text.charAt(0) !== '"') {
    return `"${text}"`;
  }
  return text;
}

function getSearchPath(): Array<string> {
  return (process.env[getPathVariableName()] || "").split(path.delimiter);
}

export async function resolveFullPath(command: string, alternateRecursiveFolders?: Array<string>) {
  let fullCommandPath = await getFullPath(command, false, getSearchPath());

  if (!fullCommandPath) {
    // fallback to searching the subfolders we're given.
    if (alternateRecursiveFolders) {
      fullCommandPath = await getFullPath(command, true, alternateRecursiveFolders);
    }
  }
  return fullCommandPath;
}

export async function execute(cwd: string, command: string, ...parameters: Array<string>): Promise<void> {
  const fullCommandPath = await resolveFullPath(command);
  if (!fullCommandPath) {
    throw new Error(`Unknown command ${command}`);
  }

  // quote parameters if necessary?
  for (let i = 0; i < parameters.length; i++) {
    // parameters[i] = quoteIfNecessary(parameters[i]);
  }

  return new Promise((r, j) => {
    if (process.platform === "win32" && fullCommandPath.indexOf(" ") > -1 && !/.exe$/gi.exec(fullCommandPath)) {
      const pathVar = getPathVariableName();
      // preserve the current path
      const originalPath = process.env[pathVar];
      try {
        // insert the dir into the path
        process.env[pathVar] = `${path.dirname(fullCommandPath)}${path.delimiter}${originalPath}`;

        // call spawn and return
        spawn(path.basename(fullCommandPath), parameters, { env: process.env, cwd, stdio: "inherit" }).on(
          "close",
          (c, s) => {
            if (c) {
              j("Command Failed");
            }
            r();
          },
        );
        return;
      } finally {
        // regardless, restore the original path on the way out!
        process.env[pathVar] = originalPath;
      }
    }
    spawn(fullCommandPath, parameters, { env: process.env, cwd, stdio: "inherit" }).on("close", (c, s) => {
      if (c) {
        j("Command Failed");
      }
      r();
    });
    return;
  });
}
