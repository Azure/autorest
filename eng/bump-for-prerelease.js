// @ts-check

/**
 * Script using the list of changes in all packages to figureout the next version prerelease number.
 */

const { join, resolve } = require("path");
const fs = require("fs");
const stripJsonComments = require("./strip-json-comments");
const { execSync } = require("child_process");

// Constants
const PRERELEASE_TYPE = "dev";

const root = resolve(join(__dirname), "..");
const changeDir = join(root, "common", "changes");

const findAllFiles = async (dir) => {
  const files = [];
  for (const file of await fs.promises.readdir(dir)) {
    const path = join(dir, file);
    const stat = await fs.promises.lstat(path);
    if (stat.isDirectory()) {
      files.push(...(await findAllFiles(path)));
    } else {
      files.push(path);
    }
  }
  return files;
};

const readJsonFile = async (filename) => {
  const content = await fs.promises.readFile(filename);
  return JSON.parse(stripJsonComments(content.toString()));
};

const getAllChanges = async () => {
  const files = await findAllFiles(changeDir);
  return await Promise.all(files.map((x) => readJsonFile(x)));
};

/**
 * @returns map of package to number of changes.
 */
const getChangeCountPerPackage = async () => {
  const changes = await getAllChanges();
  console.log("Changes", changes);
  const changeCounts = {};

  for (const change of changes) {
    if (!(change.packageName in changeCounts)) {
      // Count all changes that are not "none"
      changeCounts[change.packageName] = change.changes.filter((x) => x.type !== "none");
    }
    changeCounts[change.packageName]++;
  }

  return changeCounts;
};

const getPackagesPaths = async () => {
  const rushJson = await readJsonFile(join(root, "rush.json"));

  const paths = {};
  for (const project of rushJson.projects) {
    paths[project.packageName] = join(root, project.projectFolder);
  }
  return paths;
};

const addPrereleaseNumber = async (changeCounts, packagePaths) => {
  for (const [packageName, changeCount] of Object.entries(changeCounts)) {
    const projectPath = packagePaths[packageName];
    if (!projectPath) {
      throw new Error(`Cannot find package path for '${packageName}'`);
    }
    const packageJsonPath = join(projectPath, "package.json");
    const packageJsonContent = await readJsonFile(packageJsonPath);
    if (!packageJsonContent.version.endsWith(`-${PRERELEASE_TYPE}`)) {
      throw new Error(
        [
          `Couldn't add change count to package '${packageName}'. Version ${packageJsonContent.version} should be ending with '-${PRERELEASE_TYPE}'`,
          `This means that the rush publish --apply --publish didn't bump this package version but this script found 1 change. Appending the change count would result in an invalid version.`,
        ].join("\n"),
      );
    }
    const newVersion = `${packageJsonContent.version}.${changeCount}`;
    console.log(`Setting version for ${packageName} to '${newVersion}'`);
    await fs.promises.writeFile(
      packageJsonPath,
      JSON.stringify(
        {
          ...packageJsonContent,
          version: newVersion,
        },
        null,
        2,
      ),
    );
  }
};

const run = async () => {
  const changeCounts = await getChangeCountPerPackage();
  console.log("Change counts: ", changeCounts);

  const packagePaths = await getPackagesPaths();
  console.log("Package paths", packagePaths);

  console.log("Bumping versions");
  execSync(`npx @microsoft/rush publish --apply --prerelease-name="${PRERELEASE_TYPE}" --partial-prerelease`);
  console.log("Adding prerelease number");
  await addPrereleaseNumber(changeCounts, packagePaths);
};

run().catch((e) => console.error(e));
