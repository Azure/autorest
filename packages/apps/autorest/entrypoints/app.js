#!/usr/bin/env node

global.isDebuggerEnabled =
  !!require("inspector").url() || global.v8debug || /--debug|--inspect/.test(process.execArgv.join(" "));

// TODO-TIM do we need this file?
require(`${__dirname}/../dist/app.js`);
