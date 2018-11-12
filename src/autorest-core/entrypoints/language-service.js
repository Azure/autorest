// #!/usr/bin/env node
// load modules from static linker filesystem.
try {
  if (process.argv.indexOf('--no-static-loader') === -1 &&
      process.env['no-static-loader'] === undefined &&
      require('fs').existsSync('./static-loader.js')) {
    require('./static-loader.js').load(`${__dirname}/static_modules.fs`);
  }
} catch (e) {
}
require ('../dist/language-service/language-service.js');