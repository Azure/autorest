import { readFile, writeFile } from "fs/promises";
import chalk from "chalk";
import { logger } from "../logger";
import { findFiles } from "../utils";
import { AutorestFixerConfig } from "./autorest-fixer-config";
import { fixSwagger } from "./swagger-fixer";
import { FixCode } from "./types";
import { AllFixers } from ".";

export class AutorestFixer {
  public constructor(private config: AutorestFixerConfig) {}

  public async fix() {
    if (this.config.fixers === AllFixers) {
      logger.info(`Running all fixers:\n${Object.values(FixCode).map((x) => ` - ${x}\n`)}`);
    } else if (this.config.fixers.length === 0) {
      logger.info(`No fixers passed. Use --fixers to specify which fixer to use.`);
      return;
    } else {
      logger.info(`Running fixers:\n${this.config.fixers.map((x) => ` - ${x}\n`)}`);
    }

    const files = await findFiles(this.config.include);
    logger.info(`${this.config.dryRun ? "[DRY RUN] " : ""}Running fixer on ${files.length} files`);

    const fixes = [];
    for (const path of files) {
      const file = await loadSpec(path);
      if (file.type === "swagger") {
        const result = fixSwagger(path, file.spec, this.config.fixers);
        for (const fix of result.fixes) {
          logger.info(`${chalk.blue(fix.code)}: ${fix.message} in ${path} at #/${fix.path.join("/")}`);
          fixes.push(fix);
        }
        if (!this.config.dryRun && result.fixes.length > 0) {
          await saveSpec(path, result.spec);
        }
      } else if (file.type === "openapi") {
        logger.warn(`Not supporting fixing OpenAPI3 files yet: ${path}`);
      } else if (file.type === "unkown") {
        // Nothing.
      }
    }
    logger.info(`Found ${fixes.length} fixes.`);
  }
}

type SwaggerSpec = { type: "swagger"; spec: any };
type OpenAPISpec = { type: "openapi"; spec: any };
type UnkownSpec = { type: "unkown" };

async function loadSpec(path: string): Promise<SwaggerSpec | OpenAPISpec | UnkownSpec> {
  const content = await readFile(path);
  const json = JSON.parse(content.toString());
  if (json.swagger) {
    return { type: "swagger", spec: json };
  }

  if (json.openapi) {
    return { type: "openapi", spec: json };
  }

  return { type: "unkown" };
}

async function saveSpec(path: string, spec: any) {
  return writeFile(path, JSON.stringify(spec, null, 2) + "\n");
}
