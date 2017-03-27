/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Mappings, Position, SmartPosition } from "../ref/source-map";
import { Descendants, ToAst } from "../ref/yaml";
import { JsonPath, parse, stringify } from '../ref/jsonpath';
import * as yaml from "../parsing/yaml";
import { DataHandleRead } from "../data-store/data-store";

// for carrying over rich information into the realm of line/col based source maps
// convention: <original name (contains no `nameWithPathSeparator`)>\n(<path>)
const nameWithPathSeparator = "\n\n(";
const nameWithPathEndMark = ")";
export function TryDecodePathFromName(name: string | undefined): JsonPath | undefined {
  try {
    if (!name) {
      return undefined;
    }
    const sepIndex = name.indexOf(nameWithPathSeparator);
    if (sepIndex === -1 || !name.endsWith(nameWithPathEndMark)) {
      return undefined;
    }
    const secondPart = name.slice(sepIndex + 2, name.length - 1);
    return parse(secondPart);
  } catch (e) {
    return undefined;
  }
}
export function EncodePathInName(name: string | undefined, path: JsonPath): string {
  if (name && name.indexOf(nameWithPathSeparator) !== -1) {
    throw new Error("Cannot encode the path since the original name already contains the separator string.");
  }
  return (name || "") + nameWithPathSeparator + stringify(path) + nameWithPathEndMark;
}

export async function CompilePosition(position: SmartPosition, yamlFile: DataHandleRead): Promise<Position> {
  const path = (position as any).path;
  if (path) {
    return yaml.ResolvePath(yamlFile, path);
  }
  return position as Position;
}

export async function Compile(mappings: Mappings, target: sourceMap.SourceMapGenerator, yamlFiles: DataHandleRead[] = []): Promise<void> {
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
    return CompilePosition(position, yamlFileLookup[key]);
  }

  for (const mapping of mappings) {
    const associatedPath: JsonPath | null = (mapping.original as any).path || (mapping.generated as any).path || null;

    target.addMapping({
      generated: await compilePos(mapping.generated, generatedFile),
      original: await compilePos(mapping.original, mapping.source),
      name: associatedPath !== null ? EncodePathInName(mapping.name, associatedPath) : mapping.name,
      source: mapping.source
    });
  }
}

export function* CreateAssignmentMapping(assignedObject: any, sourceKey: string, sourcePath: JsonPath, targetPath: JsonPath, subject: string): Mappings {
  for (const descendant of Descendants(ToAst(assignedObject))) {
    const path = descendant.path;
    yield {
      name: `${subject} (${stringify(path)})`, source: sourceKey,
      original: { path: sourcePath.concat(path) },
      generated: { path: targetPath.concat(path) }
    };
  }
}