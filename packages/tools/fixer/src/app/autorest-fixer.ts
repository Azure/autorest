import { readFile, writeFile } from "fs/promises";
import { logger } from "../logger";
import { findFiles } from "../utils";
import { AutorestFixerConfig } from "./autorest-fixer-config";
import { fixSwagger } from "./swagger-fixer";

export class AutorestFixer {
  public constructor(private config: AutorestFixerConfig) {}

  public async fix() {
    const files = await findFiles(this.config.include);
    logger.info(`Running fixer on ${files.length} files`);
    for (const path of files) {
      const file = await loadSpec(path);
      if (file.type === "swagger") {
        const result = fixSwagger(file.spec);
        for (const fix of result.fixes) {
          logger.info(`${fix.code}: ${fix.message} in ${path} at #/${fix.path.join("/")}`);
        }
        await saveSpec(path, result.spec);
      } else if (file.type === "openapi") {
        logger.warn(`Not supporting fixing OpenAPI3 files yet: ${path}`);
      } else if (file.type === "unkown") {
        // Nothing.
      }
    }
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
