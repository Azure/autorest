import { spawnSync } from "child_process";
import { readFileSync } from "fs";
import { readdir } from "fs/promises";
import { join, dirname, extname } from "path";
import { resolveProject } from "./resolve-root";

export async function generateCadl(folder: string, debug = false) {
  const { path: root } = await resolveProject(__dirname);
  const path = join(root, "test", folder);
  const dir = await readdir(path);
  if (!dir?.length) {
    throw new Error(`No files found in ${path}`);
  }

  const firstSwagger = dir.find(
    (f) => f.endsWith(".json") || f.endsWith(".yaml") || f.endsWith(".yml") || f.endsWith(".md"),
  );

  if (!firstSwagger) {
    throw new Error("No swagger file found");
  }

  const swaggerPath = join(path, firstSwagger);
  generate(swaggerPath, debug);
}

function generate(path: string, debug = false) {
  const extension = extname(path);
  const inputFile = extension === ".json" ? `--input-file=${path}` : `--require=${path}`;

  let overrideGuess = false;
  if (extension === ".md") {
    const fileContent = readFileSync(path, "utf-8");
    overrideGuess = fileContent.includes("guessResourceKey: false");
  }

  const args = [
    "--openapi-to-cadl",
    inputFile,
    "--use=.",
    `--output-folder=${dirname(path)}`,
    "--src-path=tsp-output",
    ...(debug ? ["--openapi-to-cadl.debugger"] : []),
    ...(overrideGuess ? ["--guessResourceKey=false"] : ["--guessResourceKey=true"]),
  ];
  const spawn = spawnSync("autorest", args, { stdio: "inherit" });

  if (spawn.status !== 0) {
    throw new Error(`Generation failed, command:\n autorest ${args.join(" ")}`);
  }
}

async function main() {
  const folder = process.argv[4];
  const debug = process.argv[5] === "--debug";
  const { path: root } = await resolveProject(__dirname);

  const folders: string[] = folder
    ? [folder as string]
    : (await readdir(join(root, "test"))).filter((d) => d !== "utils");

  for (const folder of folders) {
    try {
      await generateCadl(folder, debug);
    } catch (e) {
      throw new Error(`Failed to generate ${folder}`);
    }
  }
}

main().catch((e) => {
  throw e;
});
