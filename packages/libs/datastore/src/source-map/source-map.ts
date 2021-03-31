/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Position, SourceMapGenerator } from "source-map";
import { DataHandle } from "../data-store";
import { JsonPath, stringify } from "../json-path/json-path";
import { IndexToPosition } from "../parsing/text-utility";
import * as yaml from "../parsing/yaml";
import { Descendants, ToAst } from "../yaml";

// information to attach to line/column based to get a richer experience
export interface PositionEnhancements {
  path?: JsonPath;
  length?: number;
  valueOffset?: number;
  valueLength?: number;
}

export type EnhancedPosition = Position & PositionEnhancements;

export type SmartPosition = Position | { path: JsonPath };

export interface Mapping {
  generated: SmartPosition;
  original: SmartPosition;
  source: string;
  name?: string;
}

// for carrying over rich information into the realm of line/col based source maps
// convention: <original name (contains no `nameWithPathSeparator`)>\n(<path>)
const enhancedPositionSeparator = "\n\n(";
const enhancedPositionEndMark = ")";

export function tryDecodeEnhancedPositionFromName(name: string | undefined): EnhancedPosition | undefined {
  try {
    if (!name) {
      return undefined;
    }
    const sepIndex = name.indexOf(enhancedPositionSeparator);
    if (sepIndex === -1 || !name.endsWith(enhancedPositionEndMark)) {
      return undefined;
    }
    const secondPart = name.slice(sepIndex + 3, name.length - 1);
    return JSON.parse(secondPart);
  } catch (e) {
    return undefined;
  }
}

export function encodeEnhancedPositionInName(name: string | undefined, pos: EnhancedPosition): string {
  if (name && name.indexOf(enhancedPositionSeparator) !== -1) {
    name = name.split(enhancedPositionSeparator)[0];
  }
  return (name || "") + enhancedPositionSeparator + JSON.stringify(pos, null, 2) + enhancedPositionEndMark;
}

export async function CompilePosition(position: SmartPosition, yamlFile: DataHandle): Promise<EnhancedPosition> {
  if (!(position as EnhancedPosition).line) {
    if ((position as any).path) {
      return await yaml.ResolvePath(yamlFile, (position as any).path);
    }
    if ((position as any).index) {
      return IndexToPosition(yamlFile, (position as any).index);
    }
  }
  return <EnhancedPosition>position;
}

export async function compileMapping(
  mappings: Mapping[],
  target: SourceMapGenerator,
  yamlFiles: Array<DataHandle> = [],
): Promise<void> {
  // build lookup
  const yamlFileLookup: { [key: string]: DataHandle } = {};
  for (const yamlFile of yamlFiles) {
    yamlFileLookup[yamlFile.key] = yamlFile;
  }

  const generatedFile = target.toJSON().file;
  const compilePos = (position: SmartPosition, key: string) => {
    if ((position as any).path && !yamlFileLookup[key]) {
      throw new Error(
        `File '${key}' was not passed along with 'yamlFiles' (got '${JSON.stringify(yamlFiles.map((x) => x.key))}')`,
      );
    }
    return CompilePosition(position, yamlFileLookup[key]);
  };

  for (const mapping of mappings) {
    const compiledGenerated = await compilePos(mapping.generated, generatedFile);
    const compiledOriginal = await compilePos(mapping.original, mapping.source);
    target.addMapping({
      generated: compiledGenerated,
      original: compiledOriginal,
      name: encodeEnhancedPositionInName(mapping.name, compiledOriginal),
      source: mapping.source,
    });
  }
}

/** This recursively associates a node in the 'generated' document with a node in the 'source' document
 *
 * @description This does make an implicit assumption that the decendents of the 'generated' node are 1:1 with the descendents in the 'source' node.
 * In the event that is not true, elements in the target's source map will not be pointing to the correct elements in the source node.
 */
export function CreateAssignmentMapping(
  assignedObject: any,
  sourceKey: string,
  sourcePath: JsonPath,
  targetPath: JsonPath,
  subject: string,
  recurse = true,
  result = new Array<Mapping>(),
): Array<Mapping> {
  for (const descendant of Descendants(ToAst(assignedObject))) {
    const path = descendant.path;
    result.push({
      name: `${subject} (${stringify(path)})`,
      source: sourceKey,
      original: { path: sourcePath.concat(path) },
      generated: { path: targetPath.concat(path) },
    });

    // if it's just the top node that is 1:1, break now.
    if (!recurse) {
      break;
    }
  }
  return result;
}
