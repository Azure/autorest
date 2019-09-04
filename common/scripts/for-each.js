var cp = require("child_process");
var fs = require("fs");
var path = require("path");

function read(filename) {
  const txt = fs.readFileSync(filename, "utf8")
    .replace(/\r/gm, "")
    .replace(/\n/gm, "«")
    .replace(/\/\*.*?\*\//gm, "")
    .replace(/«/gm, "\n")
    .replace(/\s+\/\/.*/g, "");
  return JSON.parse(txt);
}

const rush = read(`${__dirname}/../../rush.json`);
const pjs = {};

function forEachProject(onEach) {
  // load all the projects
  for (const each of rush.projects) {
    const packageName = each.packageName;
    const projectFolder = path.resolve(`${__dirname}/../../${each.projectFolder}`);
    const project = require(`${projectFolder}/package.json`);
    onEach(packageName, projectFolder, project);
  }
}

function npmForEach(cmd) {
  const result = {};
  forEachProject((name, location, project) => {
    if (project.scripts[cmd]) {
      const proc = cp.spawn("npm", ['--silent',"run", cmd], { cwd: location, shell: true, stdio: "inherit" });
      proc.on("close", (code, signal) => {
        if (code !== 0) {
          process.exit(code);
        }
      });
      result[name] = {
        name, location, project, proc,
      };
    }
  });
  return result;
}

module.exports.forEachProject = forEachProject;
module.exports.npm = npmForEach;