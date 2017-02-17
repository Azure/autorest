#!/usr/bin/env node
// start of autorest-ng
// the console app starts for real here.

// this file should get 'required' by the boostrapper

import { spawn, execFile, ChildProcess } from "child_process";
import * as path from "path";
import * as yargs from "yargs";

function awaitable(child: ChildProcess): Promise<number> {
    return new Promise(function (resolve, reject) {
        child.addListener("error", reject);
        child.addListener("exit", resolve);
    });
}

async function main() {
    let autorestExe = spawn("dotnet", [path.join(__dirname, "../../AutoRest.dll"), ...process.argv.slice(2)]);
    autorestExe.stdout.pipe(process.stdout);
    autorestExe.stderr.pipe(process.stderr);
    let exitCode = await awaitable(autorestExe);
    process.exit(exitCode);
}

main();