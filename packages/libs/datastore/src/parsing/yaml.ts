/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle } from "../data-store";
import { JsonPath, JsonPathComponent, stringify } from "../json-path/json-path";
import { EnhancedPosition } from "../source-map/source-map";
import { Kind, ResolveAnchorRef, YamlMap, YamlMapping, YamlNode, YamlSequence } from "@azure-tools/yaml";
import { indexToPosition } from "./text-utility";

function ResolveMapProperty(node: YamlMap, property: string): YamlMapping | null {
  for (const mapping of node.mappings) {
    if (property === mapping.key.value) {
      return mapping;
    }
  }
  return null;
}

/**
 * Resolves the YAML node given a path PathComponent.
 * @param yamlAstRoot            Root node of AST (required for resolving anchor references)
 * @param yamlAstCurrent         Current AST node to start resolving from
 * @param jsonPathPart           Path component to resolve
 * @param deferResolvingMappings If set to true, if resolving to a mapping, will return the entire mapping node instead of just the value (useful if desiring keys)
 */
function ResolvePathPart(
  yamlAstRoot: YamlNode,
  yamlAstCurrent: YamlNode,
  jsonPathPart: JsonPathComponent,
  deferResolvingMappings: boolean,
): YamlNode {
  switch (yamlAstCurrent.kind) {
    case Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case Kind.MAPPING: {
      if (deferResolvingMappings) {
        return ResolvePathPart(yamlAstRoot, yamlAstCurrent.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== yamlAstCurrent.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${yamlAstCurrent.key.value}'`);
      }
      return yamlAstCurrent.value;
    }
    case Kind.MAP: {
      const mapping = ResolveMapProperty(yamlAstCurrent, jsonPathPart.toString());
      if (mapping !== null) {
        return deferResolvingMappings
          ? mapping
          : ResolvePathPart(yamlAstRoot, mapping, jsonPathPart, deferResolvingMappings);
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case Kind.SEQ: {
      const pathPartNumber = Number(jsonPathPart);
      if (typeof jsonPathPart !== "number" && isNaN(pathPartNumber)) {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > pathPartNumber || pathPartNumber >= yamlAstCurrent.items.length) {
        throw new Error(
          `Trying to retrieve item '${jsonPathPart}' from sequence with '${yamlAstCurrent.items.length}' items (index out of bounds)`,
        );
      }
      return yamlAstCurrent.items[pathPartNumber];
    }
    case Kind.ANCHOR_REF: {
      const newCurrent = ResolveAnchorRef(yamlAstRoot, yamlAstCurrent.referencesAnchor).node;
      return ResolvePathPart(yamlAstRoot, newCurrent, jsonPathPart, deferResolvingMappings);
    }
    case Kind.INCLUDE_REF:
      throw new Error("INCLUDE_REF not implemented");
  }
  throw new Error(`Unexpected YAML AST node kind '${(yamlAstCurrent as YamlNode).kind}'`);
}

export function ResolveRelativeNode(yamlAstRoot: YamlNode, yamlAstCurrent: YamlNode, jsonPath: JsonPath): YamlNode {
  try {
    for (const jsonPathPart of jsonPath) {
      yamlAstCurrent = ResolvePathPart(yamlAstRoot, yamlAstCurrent, jsonPathPart, true);
    }
    return yamlAstCurrent;
  } catch (error) {
    throw new Error(`Error retrieving '${stringify(jsonPath)}' (${error})`);
  }
}

export function ReplaceNode(
  yamlAstRoot: YamlNode,
  target: YamlNode,
  value: YamlNode | undefined,
): YamlNode | undefined {
  // root replacement?
  if (target === yamlAstRoot) {
    return value;
  }

  const parent = target.kind === Kind.MAPPING ? target : target.parent;
  switch (parent.kind) {
    case Kind.MAPPING: {
      const astSub = parent as YamlMapping;

      // replace the mapping's value
      if (value !== undefined && value.kind !== Kind.MAPPING) {
        astSub.value = value;
        return yamlAstRoot;
      }

      // replace the mapping
      const parentMap = parent.parent as YamlMap;
      const index = parentMap.mappings.indexOf(astSub);
      if (value !== undefined) {
        parentMap.mappings[index] = value as YamlMapping;
      } else {
        parentMap.mappings = parentMap.mappings.filter((x, i) => i !== index);
      }
      return yamlAstRoot;
    }
    case Kind.SEQ: {
      const astSub = parent as YamlSequence;
      const index = astSub.items.indexOf(target);
      if (value !== undefined) {
        astSub.items[index] = value;
      } else {
        astSub.items = astSub.items.filter((x, i) => i !== index);
      }
      return yamlAstRoot;
    }
  }
  throw new Error(`unexpected YAML AST node kind '${parent.kind}' for a parent`);
}

/**
 * Resolves the text position of a JSON path in raw YAML.
 */

export async function ResolvePath(yamlFile: DataHandle, jsonPath: JsonPath): Promise<EnhancedPosition> {
  // let node = (await (await yamlFile.ReadMetadata).resolvePathCache)[stringify(jsonPath)];
  const yamlAst = await yamlFile.readYamlAst();
  const node = ResolveRelativeNode(yamlAst, yamlAst, jsonPath);
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
