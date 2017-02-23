/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import * as yaml from "yaml-ast-parser";
import * as yamlAst from "./yamlAst";

// function mergeInternal(a: yaml.YAMLNode, b: yaml.YAMLNode, path: jsonpath.PathComponent[]): { result: yaml.YAMLNode, anchorRenames: [string, string][] } {
//     if (a === null || b === null) {
//         throw new Error("Argument cannot be null");
//     }
//     if (a.kind !== b.kind) {
//         throw new Error(`Node type mismatch at '${jsonpath.stringify(path)}'`);
//     }

//     switch (a.kind) {
//         case yaml.Kind.SCALAR: {

//         }

//     }

//     // trivial case
//     if (a === b) {
//         return a;
//     }

//     // mapping nodes
//     if (typeof a === "object" && typeof b === "object") {
//         if (a instanceof Array && b instanceof Array) {
//             // sequence nodes
//             const result = a.slice();
//             for (const belem of b) {
//                 if (a.indexOf(belem) === -1) {
//                     result.push(belem);
//                 }
//             }
//             return result;
//         }
//         else {
//             // object nodes - iterate all members
//             const result: any = {};
//             let keys = Object.getOwnPropertyNames(a).concat(Object.getOwnPropertyNames(b)).sort();
//             keys = keys.filter((v, i) => i === 0 || v !== keys[i - 1]); // distinct
//             for (const key of keys)
//             {
//                 const subpath = path.concat(key);

//                 // forward if only present in one of the nodes
//                 if (a[key] === undefined) {
//                     result[key] = b[key];
//                     continue;
//                 }
//                 if (b[key] === undefined) {
//                     result[key] = a[key];
//                     continue;
//                 }

//                 // try merge objects otherwise
//                 const aMember = a[key];
//                 const bMember = b[key];
//                 result[key] = mergeInternal(aMember, bMember, subpath);
//             }
//             return result;
//         }
//     }

//     throw new Error(`'${jsonpath.stringify(path)}' has incomaptible values (${a}, ${b}).`);
// }

// export function merge(a: yaml.YAMLNode, b: yaml.YAMLNode): yaml.YAMLNode {
//     yamlAst.renameAnchors(a, s => "a" + s);
//     yamlAst.renameAnchors(b, s => "b" + s);
//     return mergeInternal(a, b, ["$"]);
// }

function parseNodesInternal(yamlRootNode: yaml.YAMLNode, yamlNode: yaml.YAMLNode): any {
  switch (yamlNode.kind) {
    case yaml.Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as yaml.YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject || yamlNodeScalar.value;
    }
    case yaml.Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case yaml.Kind.MAP: {
      yamlNode.valueObject = {};
      const yamlNodeMapping = yamlNode as yaml.YamlMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== yaml.Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = parseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as yaml.YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(parseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as yaml.YAMLAnchorReference;
      return yamlAst.resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).valueObject;
    }
    case yaml.Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

function parseNodeInternal(yamlRootNode: yaml.YAMLNode, yamlNode: yaml.YAMLNode): any {
  switch (yamlNode.kind) {
    case yaml.Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as yaml.YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject || yamlNodeScalar.value;
    }
    case yaml.Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case yaml.Kind.MAP: {
      yamlNode.valueObject = {};
      const yamlNodeMapping = yamlNode as yaml.YamlMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== yaml.Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = parseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as yaml.YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(parseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as yaml.YAMLAnchorReference;
      return yamlAst.resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).valueObject;
    }
    case yaml.Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function parseNode<T>(yamlNode: yaml.YAMLNode): T {
  parseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function parse<T>(rawYaml: string): T {
  const node = yamlAst.parse(rawYaml);
  return parseNode<T>(node);
}

export function stringify(object: any): string {
  return yaml.safeDump(object, null);
}