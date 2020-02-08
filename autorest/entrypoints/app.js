#!/usr/bin/env node
// load modules from static linker filesystem.
// if the process was started with a low heap size (and we're not debugging!) then respawn with a bigger heap size.
if ((require('v8').getHeapStatistics()).heap_size_limit < 8000000000 && !(global.v8debug || /--debug|--inspect/.test(process.execArgv.join(' ')))) {
  process.env['NODE_OPTIONS'] = `${process.env['NODE_OPTIONS'] || ''} --max-old-space-size=8192 --no-warnings`
  const argv = process.argv.indexOf('--break') === -1 ? process.argv.slice(1) : ['--inspect-brk', ...process.argv.slice(1).filter(each => each !== '--break')];
  require("child_process").spawn(process.execPath, argv, { argv0: "node", stdio: 'inherit' }).on('close', code => { process.exit(code); });
} else {
  try {
    const v = process.versions.node.split('.');
    if (v[0] < 10 || v[0] === 10 && v[1] < 12) {
      console.error("\nFATAL: Node v10 (v10.12.x minimum, v10.16.x LTS recommended) is required for AutoRest.\n")
      process.exit(1);
    }

    if (v[0] > 13) {
      console.error("\nWARNING: AutoRest has not been tested with Node versions greater than v13.\n")
    }
    if (process.argv.indexOf('--no-static-loader') === -1 && process.env['no-static-loader'] === undefined && require('fs').existsSync(`${__dirname}/../dist/static-loader.js`)) {
      require(`${__dirname}/../dist/static-loader.js`).load(`${__dirname}/../dist/static_modules.fs`);
    }
    require(`${__dirname}/../dist/app.js`);
  } catch (e) {
    console.error(e);
  }
}