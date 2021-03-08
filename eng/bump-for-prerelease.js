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
      changeCounts[change.packageName] = 0;
    }
    changeCounts[change.packageName] += change.changes.filter((x) => x.type !== "none").length;
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

/**
 * Update the package dependencies to match the newly updated version.
 * @param {*} packageManifest
 * @param {*} updatedPackages
 */
const updateDependencyVersions = (packageManifest, updatedPackages) => {
  const dependencies = {};
  if (packageManifest.dependencies) {
    for (const [name, currentVersion] of Object.entries(packageManifest.dependencies)) {
      const updatedPackage = updatedPackages[name];
      if (updatedPackage) {
        dependencies[name] = `~${updatedPackage.newVersion}`;
      } else {
        dependencies[name] = currentVersion;
        currentVersion;
      }
    }
  }

  return {
    ...packageManifest,
    dependencies,
  };
};

const addPrereleaseNumber = async (changeCounts, packagePaths) => {
  const updatedManifests = {};
  const packagesWithChanges = Object.entries(changeCounts).filter(([_, changeCount]) => changeCount > 0);
  for (const [packageName, changeCount] of packagesWithChanges) {
    const projectPath = packagePaths[packageName];
    if (!projectPath) {
      throw new Error(`Cannot find package path for '${packageName}'`);
    }
    const packageJsonPath = join(projectPath, "package.json");
    const packageJsonContent = await readJsonFile(packageJsonPath);
    const newVersion = `${packageJsonContent.version}.${changeCount}`;

    if (!packageJsonContent.version.endsWith(`-${PRERELEASE_TYPE}`)) {
      throw new Error(
        [
          `Couldn't add change count to package '${packageName}'. Version ${packageJsonContent.version} should be ending with '-${PRERELEASE_TYPE}'`,
          `This means that the rush publish --apply --publish didn't bump this package version but this script found 1 change. Appending the change count would result in an invalid version.`,
        ].join("\n"),
      );
    }

    console.log(`Setting version for ${packageName} to '${newVersion}'`);
    updatedManifests[packageName] = {
      packageJsonPath,
      oldVersion: packageJsonContent.version,
      newVersion: newVersion,
      manifest: {
        ...packageJsonContent,
        version: newVersion,
      },
    };
  }

  for (const { packageJsonPath, manifest } of Object.values(updatedManifests)) {
    const newManifest = updateDependencyVersions(manifest, updatedManifests);
    await fs.promises.writeFile(packageJsonPath, JSON.stringify(newManifest, null, 2));
  }
};

const run = async () => {
  const changeCounts = await getChangeCountPerPackage();
  console.log("Change counts: ", changeCounts);

  const packagePaths = await getPackagesPaths();
  console.log("Package paths", packagePaths);

  // Bumping with rush publish so rush computes from the changes what will be the next non prerelease version.
  console.log("Bumping versions with rush publish");
  execSync(`npx @microsoft/rush publish --apply --prerelease-name="${PRERELEASE_TYPE}" --partial-prerelease`);

  console.log("Adding prerelease number");
  await addPrereleaseNumber(changeCounts, packagePaths);
};

run().catch((e) => console.error(e));
