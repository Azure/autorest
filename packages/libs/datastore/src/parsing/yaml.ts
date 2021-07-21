/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle } from "../data-store";
import { JsonPath } from "../json-path/json-path";
import { EnhancedPosition } from "../source-map/source-map";
import { Kind, YamlMapping, YamlNode, YamlSequence, getYamlNodeByPath } from "@azure-tools/yaml";
import { indexToPosition } from "./text-utility";

/**
 * Resolves the text position of a JSON path in raw YAML.
 */

export async function ResolvePath(yamlFile: DataHandle, jsonPath: JsonPath): Promise<EnhancedPosition> {
  const yamlAst = await yamlFile.readYamlAst();
  const node = getYamlNodeByPath(yamlAst, jsonPath);
  return createEnhancedPosition(yamlFile, jsonPath, node);
}

export async function createEnhancedPosition(
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
