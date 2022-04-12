import { inspect } from "util";
import { getFromJsonPointer } from "@azure-tools/json";
import { parseJsonRef } from "@azure-tools/jsonschema";
import { OpenAPI2Document } from "./v2";
import { OpenAPI3Document } from "./v3";

export interface WorkspaceConfig<T extends OpenAPI2Document | OpenAPI3Document> {
  specs: { [filePath: string]: T } | Map<string, T>;
}

export interface ResolveReferenceRelativeTo {
  /**
   * Reference as it is.
   * @example
   *  #/components/schemas/Foo
   *  file:///bar.json#/components/schemas/Foo
   */
  ref: string;

  /**
   * File where the reference was defined.
   * @example file:///foo.json
   *
   */
  relativeTo: string;
}

export interface TargetedJsonRef {
  /**
   * File part of the json ref.
   * @example foo.json for "foo.json#/components/schemas/Bar"
   */
  file: string;

  /**
   * Path part of the json ref.
   * @example /components/schemas/Bar for "foo.json#/components/schemas/Bar"
   */
  path?: string;
}

export type ResolveReferenceArgs = TargetedJsonRef | ResolveReferenceRelativeTo;

export interface OpenAPIWorkspace<T extends OpenAPI2Document | OpenAPI3Document> {
  specs: Map<string, T>;

  resolveReference<T>(args: ResolveReferenceArgs): T;
}

export class InvalidRefError extends Error {}

export function createOpenAPIWorkspace<T extends OpenAPI2Document | OpenAPI3Document>(
  workspace: WorkspaceConfig<T>,
): OpenAPIWorkspace<T> {
  const specs = workspace.specs instanceof Map ? workspace.specs : new Map(Object.entries(workspace.specs));

  function resolveReference<T>(args: ResolveReferenceArgs): T {
    const ref = parseRef(args);
    const spec = specs.get(ref.file);
    if (spec === undefined) {
      throw new InvalidRefError(`Ref file '${ref.file}' doesn't exists in workspace.`);
    }

    const result = ref.path ? getFromJsonPointer(spec, ref.path) : spec;
    return result as any;
  }
  return { specs, resolveReference };
}

function parseRef(args: ResolveReferenceArgs): TargetedJsonRef {
  if ("relativeTo" in args) {
    const ref = parseJsonRef(args.ref);
    return ref.file ? { file: ref.file, path: ref.path } : { file: args.relativeTo, path: ref.path };
  }
  return args;
}
