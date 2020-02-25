var cp = require('child_process');

require('./for-each').forEachProject((packageName, projectFolder, project) => {
  if (project.scripts.watch) {
    console.log(`npm run watch {cwd: ${__dirname}/../${projectFolder}}`);
    const proc = cp.spawn('npm', ['run', 'watch'], { cwd: projectFolder, shell: true, stdio: "inherit" });
    proc.on("error", (c, s) => {
      console.log(packageName);
      console.error(c);
      console.error(s);
    });
    proc.on('exit', (c, s) => {
      console.log(packageName);
      console.error(c);
      console.error(s);
    });
    proc.on('message', (c, s) => {
      console.log(packageName);
      console.error(c);
      console.error(s);
    })
  }
});


