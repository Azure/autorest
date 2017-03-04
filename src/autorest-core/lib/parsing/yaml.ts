/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Kind, YAMLNode, YAMLMapping, YAMLMap, YAMLSequence, YAMLAnchorReference, resolveAnchorRef } from "../approved-imports/yaml";
import { JsonPath, JsonPathComponent } from "../approved-imports/jsonpath";
import { indexToPosition } from "./textUtility";
import { DataHandleRead } from "../data-store/data-store";


/**
 * Resolves the YAML node given a path PathComponent.
 * @param yamlAstRoot            Root node of AST (required for resolving anchor references)
 * @param yamlAstCurrent         Current AST node to start resolving from
 * @param jsonPathPart           Path component to resolve
 * @param deferResolvingMappings If set to true, if resolving to a mapping, will return the entire mapping node instead of just the value (useful if desiring keys)
 */
function resolvePathPart(yamlAstRoot: YAMLNode, yamlAstCurrent: YAMLNode, jsonPathPart: JsonPathComponent, deferResolvingMappings: boolean): YAMLNode {
  switch (yamlAstCurrent.kind) {
    case Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case Kind.MAPPING: {
      let astSub = yamlAstCurrent as YAMLMapping;
      if (deferResolvingMappings) {
        return resolvePathPart(yamlAstRoot, astSub.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== astSub.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${astSub.key.value}'`);
      }
      return astSub.value;
    }
    case Kind.MAP: {
      let astSub = yamlAstCurrent as YAMLMap;
      for (let mapping of astSub.mappings) {
        if (jsonPathPart.toString() === mapping.key.value) {
          return deferResolvingMappings
            ? mapping
            : resolvePathPart(yamlAstRoot, mapping, jsonPathPart, deferResolvingMappings);
        }
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case Kind.SEQ: {
      let astSub = yamlAstCurrent as YAMLSequence;
      if (typeof jsonPathPart !== "number") {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > jsonPathPart || jsonPathPart >= astSub.items.length) {
        throw new Error(`Trying to retrieve item '${jsonPathPart}' from sequence with '${astSub.items.length}' items (index out of bounds)`);
      }
      return astSub.items[jsonPathPart];
    }
    case Kind.ANCHOR_REF: {
      let astSub = yamlAstCurrent as YAMLAnchorReference;
      let newCurrent = resolveAnchorRef(yamlAstRoot, astSub.referencesAnchor).node;
      return resolvePathPart(yamlAstRoot, newCurrent, jsonPathPart, deferResolvingMappings);
    }
    case Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
  throw new Error(`unexpected YAML AST node kind '${yamlAstCurrent.kind}'`);
}

export function resolvePathParts(yamlAstRoot: YAMLNode, jsonPathParts: JsonPath): number {
  if (jsonPathParts.length === 0 || jsonPathParts[0] !== "$") {
    throw new Error(`Argument: Invalid JSON path '${JSON.stringify(jsonPathParts)}' (not starting with $)`);
  }
  // special treatment of root "$", so it gets mapped to the VERY beginning of the document (possibly "---")
  // instead of the first YAML mapping node. This allows disambiguation of "$" and "$.<first prop>" in YAML.
  if (jsonPathParts.length === 1) {
    return 0;
  }

  let yamlAstCurrent = yamlAstRoot;
  for (let i = 1; i < jsonPathParts.length; ++i) {
    yamlAstCurrent = resolvePathPart(yamlAstRoot, yamlAstCurrent, jsonPathParts[i], true);
  }
  return yamlAstCurrent.startPosition;
}

/**
 * Resolves the text position of a JSON path in raw YAML.
 */
export async function resolvePath(yamlFile: DataHandleRead, jsonPath: JsonPath): Promise<sourceMap.Position> {
  const yaml = await yamlFile.ReadData();
  const yamlAst = await (await yamlFile.ReadMetadata()).yamlAst;
  const textIndex = resolvePathParts(yamlAst, jsonPath);
  return indexToPosition(yaml, textIndex);
}