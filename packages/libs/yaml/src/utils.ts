import { YamlNodeWithPath } from "./parser";
import { Kind, YamlMap, YamlMapping, YamlNode, YamlSequence } from "./types";

/**
 * Walk the yaml ast tree.
 * @param node Node to start walking.
 * @param walker Callback called for each nodes
 */
export function walkYamlAst(node: YamlNode, walker: (node: YamlNodeWithPath) => void) {
  walkYamlAstInternal(node, [], walker);
}

function walkYamlAstInternal(
  node: YamlNode,
  currentPath: Array<string | number>,
  walker: (node: YamlNodeWithPath) => void,
): void {
  walker({ path: currentPath, node });

  switch (node.kind) {
    case Kind.MAPPING:
      walkYamlAstInternal(node.value, currentPath.concat([node.key.value]), walker);
      break;
    case Kind.MAP:
      for (const mapping of node.mappings) {
        walkYamlAstInternal(mapping, currentPath, walker);
      }
      break;
    case Kind.SEQ:
      for (let i = 0; i < node.items.length; ++i) {
        walkYamlAstInternal(node.items[i], currentPath.concat([i]), walker);
      }
      break;
  }
}

export function getYamlNodeByPath(base: YamlNode, jsonPath: Array<string | number>): YamlNode {
  try {
    for (const jsonPathPart of jsonPath) {
      base = getYamlNodeByKey(base, jsonPathPart, true);
    }
    return base;
  } catch (error) {
    console.error("HERE", jsonPath);
    throw new Error(`Error retrieving '${jsonPath.join(">")}' (${error})`);
  }
}

/**
 * Resolves the YAML node given a path PathComponent.
 * @param yamlAstRoot            Root node of AST (required for resolving anchor references)
 * @param base         Current AST node to start resolving from
 * @param jsonPathPart           Path component to resolve
 * @param deferResolvingMappings If set to true, if resolving to a mapping, will return the entire mapping node instead of just the value (useful if desiring keys)
 */
function getYamlNodeByKey(base: YamlNode, jsonPathPart: string | number, deferResolvingMappings: boolean): YamlNode {
  switch (base.kind) {
    case Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case Kind.MAPPING: {
      if (deferResolvingMappings) {
        return getYamlNodeByKey(base.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== base.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${base.key.value}'`);
      }
      return base.value;
    }
    case Kind.MAP: {
      const mapping = getYamlMapProperty(base, jsonPathPart.toString());
      if (mapping !== undefined) {
        return deferResolvingMappings ? mapping : getYamlNodeByKey(mapping, jsonPathPart, deferResolvingMappings);
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case Kind.SEQ: {
      const pathPartNumber = Number(jsonPathPart);
      if (typeof jsonPathPart !== "number" && isNaN(pathPartNumber)) {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > pathPartNumber || pathPartNumber >= base.items.length) {
        throw new Error(
          `Trying to retrieve item '${jsonPathPart}' from sequence with '${base.items.length}' items (index out of bounds)`,
        );
      }
      return base.items[pathPartNumber];
    }
    case Kind.ANCHOR_REF: {
      return getYamlNodeByKey(base.value, jsonPathPart, deferResolvingMappings);
    }
    case Kind.INCLUDE_REF:
      throw new Error("INCLUDE_REF not implemented");
  }
  throw new Error(`Unexpected YAML AST node kind '${(base as YamlNode).kind}'`);
}

function getYamlMapProperty(node: YamlMap, property: string): YamlMapping | undefined {
  return node.mappings.find((x) => x.key.value === property);
}

export function replaceYamlAstNode(
  root: YamlNode,
  target: YamlNode,
  value: YamlNode | undefined,
): YamlNode | undefined {
  // root replacement?
  if (target === root) {
    return value;
  }

  const parent = target.kind === Kind.MAPPING ? target : target.parent;
  switch (parent.kind) {
    case Kind.MAPPING: {
      const astSub = parent as YamlMapping;

      // replace the mapping's value
      if (value !== undefined && value.kind !== Kind.MAPPING) {
        astSub.value = value;
        return root;
      }

      // replace the mapping
      const parentMap = parent.parent as YamlMap;
      const index = parentMap.mappings.indexOf(astSub);
      if (value !== undefined) {
        parentMap.mappings[index] = value as YamlMapping;
      } else {
        parentMap.mappings = parentMap.mappings.filter((x, i) => i !== index);
      }
      return root;
    }
    case Kind.SEQ: {
      const astSub = parent as YamlSequence;
      const index = astSub.items.indexOf(target);
      if (value !== undefined) {
        astSub.items[index] = value;
      } else {
        astSub.items = astSub.items.filter((x, i) => i !== index);
      }
      return root;
    }
  }
  throw new Error(`unexpected YAML AST node kind '${parent.kind}' for a parent`);
}
