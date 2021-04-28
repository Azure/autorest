import { readFile, writeFile } from "fs/promises";
import { logger } from "../logger";
import { findFiles } from "../utils";
import { AutorestFixerConfig } from "./autorest-fixer-config";
import { fixSwagger } from "./swagger-fixer";

export class AutorestFixer {
  public constructor(private config: AutorestFixerConfig) {}

  public async fix() {
    const files = await findFiles(this.config.include);
    logger.info(`${this.config.dryRun && "[DRY RUN] "}Running fixer on ${files.length} files`);

    const fixes = [];
    for (const path of files) {
      const file = await loadSpec(path);
      if (file.type === "swagger") {
        const result = fixSwagger(path, file.spec);
        for (const fix of result.fixes) {
          logger.info(`${fix.code}: ${fix.message} in ${path} at #/${fix.path.join("/")}`);
          fixes.push(fix);
        }
        if (!this.config.dryRun) {
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
  return writeFile(path, JSON.stringify(spec, null, 2));
}
