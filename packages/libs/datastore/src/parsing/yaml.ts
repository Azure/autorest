/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle } from "../data-store";
import { JsonPath, JsonPathComponent, stringify } from "../json-path/json-path";
import { EnhancedPosition } from "../source-map/source-map";
import {
  CloneAst,
  CreateYAMLAnchorRef,
  CreateYAMLMap,
  CreateYAMLMapping,
  CreateYAMLScalar,
  Descendants,
  Kind,
  ParseNode,
  ResolveAnchorRef,
  YAMLAnchorReference,
  YAMLMap,
  YAMLMapping,
  YAMLNode,
  YAMLSequence,
} from "../yaml";
import { IndexToPosition } from "./text-utility";

function ResolveMapProperty(node: YAMLMap, property: string): YAMLMapping | null {
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
  yamlAstRoot: YAMLNode,
  yamlAstCurrent: YAMLNode,
  jsonPathPart: JsonPathComponent,
  deferResolvingMappings: boolean,
): YAMLNode {
  switch (yamlAstCurrent.kind) {
    case Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case Kind.MAPPING: {
      const astSub = yamlAstCurrent as YAMLMapping;
      if (deferResolvingMappings) {
        return ResolvePathPart(yamlAstRoot, astSub.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== astSub.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${astSub.key.value}'`);
      }
      return astSub.value;
    }
    case Kind.MAP: {
      const astSub = yamlAstCurrent as YAMLMap;
      const mapping = ResolveMapProperty(astSub, jsonPathPart.toString());
      if (mapping !== null) {
        return deferResolvingMappings
          ? mapping
          : ResolvePathPart(yamlAstRoot, mapping, jsonPathPart, deferResolvingMappings);
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case Kind.SEQ: {
      const astSub = yamlAstCurrent as YAMLSequence;
      const pathPartNumber = Number(jsonPathPart);
      if (typeof jsonPathPart !== "number" && isNaN(pathPartNumber)) {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > pathPartNumber || pathPartNumber >= astSub.items.length) {
        throw new Error(
          `Trying to retrieve item '${jsonPathPart}' from sequence with '${astSub.items.length}' items (index out of bounds)`,
        );
      }
      return astSub.items[pathPartNumber];
    }
    case Kind.ANCHOR_REF: {
      const astSub = yamlAstCurrent as YAMLAnchorReference;
      const newCurrent = ResolveAnchorRef(yamlAstRoot, astSub.referencesAnchor).node;
      return ResolvePathPart(yamlAstRoot, newCurrent, jsonPathPart, deferResolvingMappings);
    }
    case Kind.INCLUDE_REF:
      throw new Error("INCLUDE_REF not implemented");
  }
  throw new Error(`unexpected YAML AST node kind '${yamlAstCurrent.kind}'`);
}

export function ResolveRelativeNode(yamlAstRoot: YAMLNode, yamlAstCurrent: YAMLNode, jsonPath: JsonPath): YAMLNode {
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
  yamlAstRoot: YAMLNode,
  target: YAMLNode,
  value: YAMLNode | undefined,
): YAMLNode | undefined {
  // root replacement?
  if (target === yamlAstRoot) {
    return value;
  }

  const parent = target.kind === Kind.MAPPING ? target : target.parent;
  switch (parent.kind) {
    case Kind.MAPPING: {
      const astSub = parent as YAMLMapping;

      // replace the mapping's value
      if (value !== undefined && value.kind !== Kind.MAPPING) {
        astSub.value = value;
        return yamlAstRoot;
      }

      // replace the mapping
      const parentMap = parent.parent as YAMLMap;
      const index = parentMap.mappings.indexOf(astSub);
      if (value !== undefined) {
        parentMap.mappings[index] = value as YAMLMapping;
      } else {
        parentMap.mappings = parentMap.mappings.filter((x, i) => i !== index);
      }
      return yamlAstRoot;
    }
    case Kind.SEQ: {
      const astSub = parent as YAMLSequence;
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
  return CreateEnhancedPosition(yamlFile, jsonPath, node);
}

export function CreateEnhancedPosition(yamlFile: DataHandle, jsonPath: JsonPath, node: YAMLNode): EnhancedPosition {
  const startIdx = jsonPath.length === 0 ? 0 : node.startPosition;
  const endIdx = node.endPosition;
  const startPos = IndexToPosition(yamlFile, startIdx);
  const endPos = IndexToPosition(yamlFile, endIdx);

  const result: EnhancedPosition = { column: startPos.column, line: startPos.line };
  result.path = jsonPath;

  // enhance
  if (node.kind === Kind.MAPPING) {
    const mappingNode = node as YAMLMapping;
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

/**
 * REPRESENTATION
 */

/**
 * rewrites anchors to $id/$$ref
 */
export function ConvertYaml2Jsonx(ast: YAMLNode): YAMLNode {
  ast = CloneAst(ast);
  for (const nodeWithPath of Descendants(ast)) {
    const node = nodeWithPath.node;
    if (node.anchorId) {
      if (node.kind === Kind.MAP) {
        const yamlNodeMapping = node as YAMLMap;
        yamlNodeMapping.mappings.push(CreateYAMLMapping(CreateYAMLScalar("$id"), CreateYAMLScalar(node.anchorId)));
      }
      node.anchorId = undefined;
    }
    if (node.kind === Kind.ANCHOR_REF) {
      const yamlNodeAnchor = node as YAMLAnchorReference;
      const map = CreateYAMLMap();
      map.mappings.push(
        CreateYAMLMapping(CreateYAMLScalar("$$ref"), CreateYAMLScalar(yamlNodeAnchor.referencesAnchor)),
      );
      ReplaceNode(ast, yamlNodeAnchor, map);
    }
  }
  return ast;
}

/**
 * rewrites $id/$ref/$$ref to anchors
 */
export function ConvertJsonx2Yaml(ast: YAMLNode): YAMLNode {
  ast = CloneAst(ast);
  for (const nodeWithPath of Descendants(ast)) {
    const node = nodeWithPath.node;
    if (node.kind === Kind.MAP) {
      const yamlNodeMapping = node as YAMLMap;
      const propId = ResolveMapProperty(yamlNodeMapping, "$id");
      let propRef = ResolveMapProperty(yamlNodeMapping, "$ref");
      const propReff = ResolveMapProperty(yamlNodeMapping, "$$ref");
      if (propRef && isNaN(parseInt(ParseNode<any>(propRef.value) + ""))) {
        propRef = null;
      }
      propRef = propRef || propReff;

      if (propId) {
        yamlNodeMapping.anchorId = ParseNode<any>(propId.value) + "";
        ReplaceNode(ast, propId, undefined);
      } else if (propRef) {
        ReplaceNode(ast, yamlNodeMapping, CreateYAMLAnchorRef(ParseNode<any>(propRef.value) + ""));
      }
    }
  }
  return ast;
}
