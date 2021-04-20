#!/usr/bin/env node
/* eslint-disable no-console */

global.isDebuggerEnabled =
  !!require("inspector").url() || global.v8debug || /--debug|--inspect/.test(process.execArgv.join(" "));

const maxMemorySizeArg = process.argv.join(" ").match(/--max-memory-size=(\w+)/);
const maxMemorySize = maxMemorySizeArg && parseInt(maxMemorySizeArg[1]);
if (isNaN(maxMemorySize)) {
  console.error(`\nWarning: --max-memory-size parameter '${maxMemorySizeArg[1]}' is not an integer, ignoring it.\n`);
}

// if the process was started with a low heap size (and we're not debugging!) then respawn with a bigger heap size.
if (
  maxMemorySize &&
  !isDebuggerEnabled &&
  require("v8").getHeapStatistics().heap_size_limit < maxMemorySize * 1024000
) {
  process.env["NODE_OPTIONS"] = `${
    process.env["NODE_OPTIONS"] || ""
  } --max-old-space-size=${maxMemorySize} --no-warnings`;
  const argv =
    process.argv.indexOf("--break") === -1
      ? process.argv.slice(1)
      : ["--inspect-brk", ...process.argv.slice(1).filter((each) => each !== "--break")];
  require("child_process")
    .spawn(process.execPath, argv, { argv0: "node", stdio: "inherit" })
    .on("close", (code) => {
      process.exit(code);
    });
} else {
  try {
    const v = process.versions.node.split(".");
    if (v[0] < 10 || (v[0] === 10 && v[1] < 16)) {
      console.error(
        "\nFATAL: Node v10 or higher (v10.16.x minimum, v14.x LTS recommended) is required for AutoRest.\n",
      );
      process.exit(1);
    }

    if (v[0] > 14) {
      console.error("\nWARNING: AutoRest has not been tested with Node versions greater than v14.\n");
    }

    require(`${__dirname}/../dist/app.js`);
  } catch (e) {
    console.error(e);
  }
}
