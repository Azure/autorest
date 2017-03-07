/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import { spawn, ChildProcess } from "child_process";
import * as fs from "fs";
import { homedir } from "os";
import * as path from "path";

function AutoRestDllPath() {
  let result = path.join(__dirname, "../../AutoRest.dll");

  // try relative path to __dirname
  if (fs.existsSync(result)) {
    return result;
  }

  // try relative to process.argv[1]
  result = path.join(path.dirname(process.argv[1]), "../../AutoRest.dll");
  // try relative path to __dirname
  if (fs.existsSync(result)) {
    return result;
  }

  throw "Unable to find AutoRest.Dll.";
}

function DotNetPath() {
  let result = path.join(homedir(), ".autorest", "frameworks", "dotnet")

  // try relative path to __dirname
  if (fs.existsSync(result)) {
    return result;
  }

  // hope there is one in the PATH
  return "dotnet";
}

export function spawnLegacyAutoRest(args: string[]): ChildProcess {
  return spawn(
    path.join(homedir(), ".autorest", "frameworks", "dotnet"),
    [AutoRestDllPath(), ...args]);
}

export function spawnJsonRpcAutoRest(): ChildProcess {
  return spawnLegacyAutoRest(["-JsonRpc"]); // TODO: sync with the cowboy
}