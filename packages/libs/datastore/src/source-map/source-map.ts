/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Position, SourceMapGenerator } from "source-map";
import { DataHandle } from "../data-store";
import { JsonPath } from "../json-path/json-path";
import { indexToPosition } from "../parsing/text-utility";
import { walkYamlAst, valueToAst, getYamlNodeByPath, YamlNode, Kind, YamlMapping } from "@azure-tools/yaml";
import { PathMapping } from "./path-source-map";

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

export async function CompilePosition(position: SmartPosition, yamlFile: DataHandle): Promise<EnhancedPosition> {
  if (!(position as EnhancedPosition).line) {
    if ((position as any).path) {
      return await resolvePathPosition(yamlFile, (position as any).path);
    }
    if ((position as any).index) {
      return indexToPosition(yamlFile, (position as any).index);
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
    try {
      const compiledGenerated = await compilePos(mapping.generated, generatedFile);
      const compiledOriginal = await compilePos(mapping.original, mapping.source);
      target.addMapping({
        generated: compiledGenerated,
        original: compiledOriginal,
        source: mapping.source,
      });
    } catch {
      // Failed to acquire a mapping for the orignal or generated position(probably means the entry got added or removed) don't do anything.
    }
  }
}

/** This recursively associates a node in the 'generated' document with a node in the 'source' document
 *
 * @description This does make an implicit assumption that the decendents of the 'generated' node are 1:1 with the descendents in the 'source' node.
 * In the event that is not true, elements in the target's source map will not be pointing to the correct elements in the source node.
 */
export function createAssignmentMapping(
  assignedObject: any,
  sourceKey: string,
  sourcePath: JsonPath,
  targetPath: JsonPath,
  subject: string,
  recurse = true,
  result: PathMapping[] = [],
): Array<PathMapping> {
  if (!recurse) {
    result.push({
      source: sourceKey,
      original: sourcePath,
      generated: targetPath,
    });
    return result;
  }

  walkYamlAst(valueToAst(assignedObject), ({ path }) => {
    result.push({
      source: sourceKey,
      original: sourcePath.concat(path),
      generated: targetPath.concat(path),
    });

    // if it's just the top node that is 1:1, break now.
  });

  return result;
}

/**
 * Resolves the text position of a JSON path in raw YAML.
 */
export async function resolvePathPosition(yamlFile: DataHandle, jsonPath: JsonPath): Promise<EnhancedPosition> {
  const yamlAst = await yamlFile.readYamlAst();
  const node = getYamlNodeByPath(yamlAst, jsonPath);
  return createEnhancedPosition(yamlFile, jsonPath, node);
}

async function createEnhancedPosition(
  yamlFile: DataHandle,
  jsonPath: JsonPath,
  node: YamlNode,
): Promise<EnhancedPosition> {
  const startIdx = jsonPath.length === 0 ? 0 : node.startPosition;
  const endIdx = node.endPosition;
  const startPos = await indexToPosition(yamlFile, startIdx);
  const endPos = await indexToPosition(yamlFile, endIdx);

  const result: EnhancedPosition = { column: startPos.column, line: startPos.line };
  result.path = jsonPath;

  // enhance
  if (node.kind === Kind.MAPPING) {
    const mappingNode = node as YamlMapping;
    result.length = mappingNode.key.endPosition - mappingNode.key.startPosition;
    result.valueOffset = mappingNode.value.startPosition - mappingNode.key.startPosition;
    result.valueLength = mappingNode.value.endPosition - mappingNode.value.startPosition;
  } else {
    result.length = endIdx - startIdx;
    result.valueOffset = 0;
    result.valueLength = result.length;
  }

  return result;
}
