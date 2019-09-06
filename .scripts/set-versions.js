const { exec } = require('child_process');
const { writeFileSync } = require('fs');
const { forEachProject, projectCount } = require('./for-each');

let count = projectCount;


function updateVersion(name, project, location, patch) {
  const origJson = JSON.stringify(project, null, 2);

  // update the third digit
  const verInfo = project.version.split('.');
  verInfo[2] = patch;
  project.version = verInfo.join('.');

  // write the file if it's changed
  const newJson = JSON.stringify(project, null, 2);
  if (origJson !== newJson) {
    console.log(`Writing project '${name}' version to '${project.version}' in '${location}'`);
    writeFileSync(`${location}/package.json`, newJson)
  }

  count--;
  if (count === 0) {
    // last one!
    // call sync-versions
    require('./sync-versions');
  }
}

if (process.argv[2] === '--reset') {
  forEachProject((name, location, project) => {
    updateVersion(name, project, location, 0);
  })
} else {
  // Sets the patch version on each package.json in the project.
  forEachProject((name, location, project) => {
    exec(`git rev-list --parents HEAD --count --full-history .`, { cwd: location }, (o, stdout) => {
      const patch = (parseInt(stdout.trim()) + (Number(project.patchOffset) || -1));
      updateVersion(name, project, location, patch);
    });
  });
}

