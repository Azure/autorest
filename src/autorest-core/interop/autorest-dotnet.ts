/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import { spawn, ChildProcess } from "child_process";
import * as fs from "fs";
import { homedir } from "os";
import * as path from "path";

const empty = "";

function WalkUpPath(startPath: string, relativePath: string, maxParents: number): string {
  const result = path.resolve(startPath, relativePath);

  if (fs.existsSync(result)) {
    return result;
  }
  const parent = path.resolve(startPath, '..');


  if (startPath === parent || (maxParents--) < 1) {
    return empty;
  }

  return WalkUpPath(parent, relativePath, maxParents);
}

function AutoRestDllPath(): string {
  // try relative path to __dirname
  let result = WalkUpPath(__dirname, "AutoRest.dll", 4);
  if (result !== empty) {
    return result;
  }

  // try relative to process.argv[1]
  result = WalkUpPath(process.argv[1], "AutoRest.dll", 4);
  if (result !== empty) {
    return result;
  }


  // try relative path to __dirname in solution
  result = WalkUpPath(__dirname, "core/AutoRest/bin/netcoreapp1.0/AutoRest.dll", 8);
  if (result !== empty) {
    return result;
  }

  throw new Error("Unable to find AutoRest.dll.");
}

function DotNetPath() {
  // try global installation directory
  let result = path.join(homedir(), ".autorest", "frameworks", "dotnet")
  if (fs.existsSync(result)) {
    return result;
  }

  result = path.join(homedir(), ".autorest", "frameworks", "dotnet.exe")
  if (fs.existsSync(result)) {
    return result;
  }

  // hope there is one in the PATH
  return "dotnet";
}

export function SpawnLegacyAutoRest(args: string[]): ChildProcess {
  const autorestdll = AutoRestDllPath();
  const dotnet = /autorest.src.core/ig.test(autorestdll) ? "dotnet" : DotNetPath();

  return spawn(
    dotnet,
    [autorestdll, ...args]);
}

export function SpawnJsonRpcAutoRest(): ChildProcess {
  return SpawnLegacyAutoRest(["--server"]);
}
