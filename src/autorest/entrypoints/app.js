#!/usr/bin/env node
// load modules from static linker filesystem.
try {
  if (process.argv.indexOf('--no-static-loader') === -1 && process.env['no-static-loader'] === undefined && require('fs').existsSync('./static-loader.js')) {
      require(`${__dirname}/../dist/static-loader.js`).load(`${__dirname}/../dist/static_modules.fs`);
  }
  require (`${__dirname}/../dist/app.js`);  
  
} catch (e) {
  console.error(e);
}
