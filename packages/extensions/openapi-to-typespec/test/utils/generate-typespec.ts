import { execSync, spawnSync } from "child_process";
import { readFileSync } from "fs";
import { readdir } from "fs/promises";
import { join, dirname, extname, resolve } from "path";
import { resolveProject } from "./resolve-root";

const brownFieldProjects = [
  "arm-agrifood",
  "arm-alertsmanagement",
  "arm-analysisservices",
  "arm-apimanagement",
  "arm-authorization",
  "arm-azureintegrationspaces",
  "arm-compute",
  "arm-dns",
  "arm-machinelearningservices",
  "arm-storage",
];

export async function generateTypespec(repoRoot: string, folder: string, debug = false) {
  const { path: root } = await resolveProject(__dirname);
  const path = join(root, "test", folder);
  const dir = await readdir(path);
  if (!dir?.length) {
    throw new Error(`No files found in ${path}`);
  }

  const firstSwagger = dir
    .filter((d) => d !== "resources.json")
    .find((f) => f.endsWith(".json") || f.endsWith(".yaml") || f.endsWith(".yml") || f.endsWith(".md"));

  if (!firstSwagger) {
    throw new Error("No swagger file found");
  }

  const swaggerPath = join(path, firstSwagger);
  generate(repoRoot, swaggerPath, debug, brownFieldProjects.includes(folder));
}

// A list containing all the projects we could compile. After we enable all the projects, we will delete this list.
const whiteList = [
  "anomalyDetector",
  "arm-agrifood",
  "arm-networkanalytics",
  "arm-playwrighttesting",
  "arm-servicenetworking",
  "arm-sphere",
  "arm-storage",
  "arm-test",
];

export async function generateSwagger(folder: string) {
  if (!whiteList.includes(folder)) {
    return;
  }

  const { path: root } = await resolveProject(__dirname);
  const path = join(root, "test", folder, "tsp-output");
  const command =
    "tsp compile . --emit=@azure-tools/typespec-autorest --option @azure-tools/typespec-autorest.output-file=./swagger-output/swagger.json";
  execSync(command, { cwd: path, stdio: "inherit" });
}

// `isFullCompatible` is mainly used for brownfield projects, where users want to fully honor the definition in the swagger file.
// For greenfield projects, we expect users to set `isFullCompatible` to `false` so that it would follow the arm template definition.
function generate(root: string, path: string, debug = false, isFullCompatible = false) {
  const extension = extname(path);
  const inputFile = extension === ".json" ? `--input-file=${path}` : `--require=${path}`;

  let overrideGuess = false;
  if (extension === ".md") {
    const fileContent = readFileSync(path, "utf-8");
    overrideGuess = fileContent.includes("guessResourceKey: false");
  }

  const args = [
    resolve(root, "packages/apps/autorest/entrypoints/app.js"),
    "--openapi-to-typespec",
    inputFile,
    "--use=.",
    `--output-folder=${dirname(path)}`,
    "--src-path=tsp-output",
    ...(debug ? ["--openapi-to-typespec.debugger"] : []),
    ...(isFullCompatible ? ["--openapi-to-typespec.isFullCompatible"] : []),
    ...(overrideGuess ? ["--guessResourceKey=false"] : ["--guessResourceKey=true"]),
  ];
  const spawn = spawnSync("node", args, { stdio: "inherit" });

  if (spawn.status !== 0) {
    throw new Error(
      `Generation failed, command:\n autorest ${args.join(" ")}\nStdout:\n${spawn.stdout}\nStderr:\n${spawn.stderr}`,
    );
  }
}

async function main() {
  const swagger = process.argv[3] === "swagger";
  const folder = process.argv[4];
  const debug = process.argv[5] === "--debug";
  const { path: root } = await resolveProject(__dirname);
  const repoRoot = resolve(root, "..", "..", "..");
  const folders: string[] = folder
    ? [folder as string]
    : (await readdir(join(root, "test"))).filter((d) => d !== "utils");

  for (let i = 0; i < folders.length; i++) {
    const folder = folders[i];
    // https://github.com/Azure/typespec-azure/issues/862
    if (folder === "arm-playwrighttesting") continue;
    try {
      await generateTypespec(repoRoot, folder, debug);
      if (swagger) {
        await generateSwagger(folder);
      }
    } catch (e) {
      throw new Error(`Failed to generate ${folder}, error:\n${e}`);
    }
  }
}

main().catch((e) => {
  throw e;
});
