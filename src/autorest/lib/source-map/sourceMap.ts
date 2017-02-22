/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import { resolvePath } from "../parsing/yamlAst";
import * as sourceMap from "source-map";
import * as yamlAst from "yaml-ast-parser";

/**
 * Also allow for object paths that will gladly be resolved by us.
 */
export type Position = sourceMap.Position | { path: jsonpath.PathComponent[] };

export interface Mapping {
  generated: Position;
  original: Position;
  source: string;
  name?: string;
}

export type Mappings = Iterable<Mapping>;

export function compile(mappings: Mappings, target: sourceMap.SourceMapGenerator, yamlFiles: { [fileName: string]: string } = {}): void {
  const generatedFile = target.toJSON().file;

  const getAST = (() => {
    const yamlASTs: { [fileName: string]: yamlAst.YAMLNode } = {};
    return (fileName: string) => {
      if (!yamlASTs[fileName]) {
        const yaml = yamlFiles[fileName];
        if (yaml === undefined) {
          throw new Error(`File '${fileName}' was not provided.`);
        }
        yamlASTs[fileName] = yamlAst.safeLoad(yaml, null) as yamlAst.YAMLNode;
      }
      return yamlASTs[fileName];
    }
  })();

  const compilePosition = (position: Position, fileName: string) => {
    if ((position as any).path) {
      return resolvePath(yamlFiles[fileName], getAST(fileName), (position as any).path);
    }
    return position as sourceMap.Position;
  };

  for (const mapping of mappings) {
    const compiledMapping: sourceMap.Mapping = {
      generated: compilePosition(mapping.generated, generatedFile),
      original: compilePosition(mapping.original, mapping.source),
      name: mapping.name,
      source: mapping.source
    };
    target.addMapping(compiledMapping);
  }
}
