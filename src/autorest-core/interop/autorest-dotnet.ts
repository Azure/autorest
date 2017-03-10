/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import { spawn, ChildProcess } from "child_process";
import * as fs from "fs";
import { homedir } from "os";
import * as path from "path";

function AutoRestDllPath() {
  // try relative path to __dirname
  let result = path.join(__dirname, "../../AutoRest.dll");
  if (fs.existsSync(result)) {
    return result;
  }

  // try relative to process.argv[1]
  result = path.join(path.dirname(process.argv[1]), "../../AutoRest.dll");
  if (fs.existsSync(result)) {
    return result;
  }

  // try relative path to __dirname in solution
  result = path.join(__dirname, "../../core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll");
  if (fs.existsSync(result)) {
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

  // hope there is one in the PATH
  return "dotnet";
}

export function SpawnLegacyAutoRest(args: string[]): ChildProcess {
  return spawn(
    DotNetPath(),
    [AutoRestDllPath(), ...args]);
}

export function SpawnJsonRpcAutoRest(): ChildProcess {
  return SpawnLegacyAutoRest(["--server"]);
}