var fs = require('fs');

function read(filename) {
  const txt = fs.readFileSync(filename, 'utf8')
    .replace(/\r/gm, '')
    .replace(/\n/gm, '«')
    .replace(/\/\*.*?\*\//gm, '')
    .replace(/«/gm, '\n')
    .replace(/\s+\/\/.*/g, '');
  return JSON.parse(txt);
}

function versionToInt(ver) {
  let v = ver.replace(/[^\d\.]/g, '').split('.').slice(0, 3);
  while (v.length < 3) {
    v.unshift(0);
  }
  let n = 0;
  for (let i = 0; i < v.length; i++) {
    n = n + ((2 ** (i * 16)) * parseInt(v[v.length - 1 - i]))
  }
  return n;
}

const rush = read(`${__dirname}/../rush.json`);
const pjs = {};

// load all the projects
for (const each of rush.projects) {
  const packageName = each.packageName;
  const projectFolder = each.projectFolder;
  pjs[packageName] = require(`${__dirname}/../${projectFolder}/package.json`);
}

function setPeerDependencies(dependencies) {
  for (const dep in dependencies) {
    const ref = pjs[dep];
    if (ref) {
      if (dependencies[dep] !== `~${ref.version}`) {
        console.log(`updating peer depedency ${dep} to ~${ref.version}`);
        dependencies[dep] = `~${ref.version}`;
      }

    }
  }
}

// verify that peer dependencies are the same version as they are building.
for (const pj of Object.getOwnPropertyNames(pjs)) {
  const each = pjs[pj];
  setPeerDependencies(each.dependencies);
  setPeerDependencies(each.devDependencies);
  if (each['static-link']) {
    setPeerDependencies(each['static-link'].devDependencies);
  }
}

function recordDeps(dependencies) {
  for (const packageName in dependencies) {
    const packageVersion = dependencies[packageName];
    if (packageList[packageName]) {
      // same version?
      if (packageList[packageName] === packageVersion) {
        continue;
      }

      // pick the higher one
      const v = versionToInt(packageVersion);


      if (v === 0) {
        console.error(`Unparsed version ${packageName}:${packageVersion}`);
        process.exit(1);
      }
      const v2 = versionToInt(packageList[packageName]);
      if (v > v2) {
        packageList[packageName] = packageVersion;
      }
    } else {
      packageList[packageName] = packageVersion;
    }
  }
}
function fixDeps(pj, dependencies) {
  for (const packageName in dependencies) {
    if (dependencies[packageName] !== packageList[packageName]) {
      console.log(`updating ${pj}:${packageName} from '${dependencies[packageName]}' to '${packageList[packageName]}'`)
      dependencies[packageName] = packageList[packageName];
    }
  }
}
const packageList = {};
// now compare to see if someone has an exnternal package with different version
// than everyone else.
for (const pj of Object.getOwnPropertyNames(pjs)) {
  const each = pjs[pj];

  recordDeps(each.dependencies);
  recordDeps(each.devDependencies);
  if (each['static-link']) {
    recordDeps(each['static-link'].dependencies);
  }
}

for (const pj of Object.getOwnPropertyNames(pjs)) {
  const each = pjs[pj];
  fixDeps(pj, each.dependencies);
  fixDeps(pj, each.devDependencies);
  if (each['static-link']) {
    fixDeps(pj, each['static-link'].dependencies);
  }
}

// write out the results.
for (const each of rush.projects) {
  const packageName = each.packageName;
  const projectFolder = each.projectFolder;
  fs.writeFileSync(`${__dirname}/../${projectFolder}/package.json`, JSON.stringify(pjs[packageName], null, 2));
}

console.log("project.json files updated");