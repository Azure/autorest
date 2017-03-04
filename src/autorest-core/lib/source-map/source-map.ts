/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Mappings, Position, SmartPosition } from "../approved-imports/source-map";
import * as yaml from "../parsing/yaml";
import { DataHandleRead } from "../data-store/data-store";

export async function compilePosition(position: SmartPosition, yamlFile: DataHandleRead): Promise<Position> {
  const path = (position as any).path;
  if (path) {
    return yaml.resolvePath(await yamlFile, path);
  }
  return position as Position;
}

export async function compile(mappings: Mappings, target: sourceMap.SourceMapGenerator, yamlFiles: DataHandleRead[] = []): Promise<void> {
  // build lookup
  const yamlFileLookup: { [key: string]: DataHandleRead } = {};
  for (const yamlFile of yamlFiles) {
    yamlFileLookup[yamlFile.key] = yamlFile;
  }

  const generatedFile = target.toJSON().file;
  const compilePos = (position: SmartPosition, key: string) => {
    if ((position as any).path && !yamlFileLookup[key]) {
      throw new Error(`File '${key}' was not passed along with 'yamlFiles' (got '${JSON.stringify(yamlFiles.map(x => x.key))}')`);
    }
    return compilePosition(position, yamlFileLookup[key]);
  }

  for (const mapping of mappings) {
    target.addMapping({
      generated: await compilePos(mapping.generated, generatedFile),
      original: await compilePos(mapping.original, mapping.source),
      name: mapping.name,
      source: mapping.source
    });
  }
}
