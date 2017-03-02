#!/usr/bin/env node
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper

import { spawn, ChildProcess } from "child_process";
import * as path from "path";
import { homedir } from "os";

function awaitable(child: ChildProcess): Promise<number> {
  return new Promise((resolve, reject) => {
    child.addListener("error", reject);
    child.addListener("exit", resolve);
  });
}

async function main() {
  const autorestArgs = process.argv.slice(2);
  try {
    const autorestExe = spawn(
      path.join(homedir(), ".autorest", "frameworks", "dotnet"),
      [path.join(__dirname, "../../AutoRest.dll"), ...autorestArgs]);
    autorestExe.stdout.pipe(process.stdout);
    autorestExe.stderr.pipe(process.stderr);
    const exitCode = await awaitable(autorestExe);
    process.exit(exitCode);
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
}

main();