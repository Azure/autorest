/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import {
  CloneAst,
  CreateYAMLScalar,
  DataHandle,
  DataSink,
  Descendants,
  Kind,
  SmartPosition,
  StringifyAst,
  YAMLMap,
  YAMLMapping,
  YAMLNodeWithPath,
} from "@azure-tools/datastore";
import { Node, Parser } from "commonmark";
import { identitySourceMapping } from "@autorest/common";

function isDocumentationField(node: YAMLNodeWithPath) {
  if (!node || !node.node.value || !node.node.value.value || typeof node.node.value.value !== "string") {
    return false;
  }
  const path = node.path;
  if (path.length < 2) {
    return false;
  }
  if (path[path.length - 2] === "x-ms-examples") {
    return false;
  }
  const last = path[path.length - 1];
  return last === "Description" || last === "Summary";
}

export function plainTextVersion(commonmarkAst: Node): string {
  let result = "";
  const walker = commonmarkAst.walker();
  let event;
  while ((event = walker.next())) {
    const node = event.node;
    switch (node.type) {
      case "text":
        result += node.literal;
        break;
      case "code":
        result += node.literal;
        break;
      case "softbreak":
        result += " ";
        break;
      case "paragraph":
        if (!event.entering) {
          result += "\n";
        }
        break;
      case "heading":
        if (!event.entering) {
          result += "\n";
        }
        break;
    }
  }
  return result.trim();
}

export async function processCodeModel(codeModel: DataHandle, sink: DataSink): Promise<DataHandle> {
  const ast = CloneAst(await codeModel.ReadYamlAst());
  const mapping = identitySourceMapping(codeModel.key, ast);

  const cmParser = new Parser();

  // transform
  for (const d of Descendants(ast, [], true)) {
    if (d.node.kind === Kind.MAPPING && isDocumentationField(d)) {
      const node = <YAMLMapping>d.node;
      const rawMarkdown = node.value.value;

      // inject new child for original value into parent
      const parent = <YAMLMap>node.parent;
      const nodeOriginal = CloneAst(node);
      const key = nodeOriginal.key.value;
      const origKey = key + "_Original";
      nodeOriginal.key.value = origKey;
      parent.mappings.push(nodeOriginal);
      mapping.push({
        name: "original gfm",
        generated: <SmartPosition>{ path: d.path.map((x, i) => (i === d.path.length - 1 ? origKey : x)) },
        original: <SmartPosition>{ path: d.path },
        source: codeModel.key,
      });

      // sanitize
      const parsed = cmParser.parse(rawMarkdown);
      const plainText = plainTextVersion(parsed);
      node.value = CreateYAMLScalar(plainText);
    }
  }

  return sink.WriteData("codeModel.yaml", StringifyAst(ast), ["fix-me"], undefined, mapping, [codeModel]);
}
