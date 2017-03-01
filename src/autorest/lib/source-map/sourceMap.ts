/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import * as sourceMap from "source-map";
import * as yaml from "../parsing/yaml";
import { DataHandleRead } from "../data-store/dataStore";

/**
 * Also allow for object paths that will gladly be resolved by us.
 */
export type Position = sourceMap.Position /* line: 1-based, column: 0-based */ | { path: jsonpath.PathComponent[] };

export function parseJsonPath(jsonPath: string): Position {
  return { path: jsonpath.parse(jsonPath).map(part => part.expression.value) };
}

export interface Mapping {
  generated: Position;
  original: Position;
  source: string;
  name?: string;
}

export type Mappings = Iterable<Mapping>;

export async function compilePosition(position: Position, yamlFile: DataHandleRead): Promise<sourceMap.Position> {
  const path = (position as any).path;
  if (path) {
    return yaml.resolvePath(yamlFile, path);
  }
  return position as sourceMap.Position;
}

export async function compile(mappings: Mappings, target: sourceMap.SourceMapGenerator, yamlFiles: DataHandleRead[] = []): Promise<void> {
  // build lookup
  const yamlFileLookup: { [key: string]: DataHandleRead } = {};
  for (const yamlFile of yamlFiles) {
    yamlFileLookup[yamlFile.key] = yamlFile;
  }

  const generatedFile = target.toJSON().file;
  const compilePos = (position: Position, key: string) => {
    if (!yamlFileLookup[key]) {
      throw new Error(`File '${key}' was not passed along with 'yamlFiles' (got '${JSON.stringify(yamlFiles.map(x => x.key))}')`);
    }
    return compilePosition(position, yamlFileLookup[key]);
  }

  for (const mapping of mappings) {
    const compiledMapping: sourceMap.Mapping = {
      generated: await compilePos(mapping.generated, generatedFile),
      original: await compilePos(mapping.original, mapping.source),
      name: mapping.name,
      source: mapping.source
    };
    target.addMapping(compiledMapping);
  }
}
