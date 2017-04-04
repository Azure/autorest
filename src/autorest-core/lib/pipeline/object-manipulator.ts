/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { IdentitySourceMapping } from "../source-map/merging";
import { Descendants, StringifyAst, ToAst, YAMLNode } from "../ref/yaml";
import { ReplaceNode, ResolveRelativeNode } from "../parsing/yaml";
import { DataHandleRead, DataHandleWrite } from "../data-store/data-store";
import { IsPrefix, JsonPath, nodes, stringify } from "../ref/jsonpath";
import { Mapping, SmartPosition } from "../ref/source-map";
import { From } from "../ref/linq";

export async function ManipulateObject(
  src: DataHandleRead,
  target: DataHandleWrite,
  whereJsonQuery: string,
  transformer: (obj: any) => any, // transforming to `undefined` results in removal
  mappingInfo?: {
    transformerSourceHandle: DataHandleRead,
    transformerSourcePosition: SmartPosition,
    reason: string
  }): Promise<{ anyHit: boolean, result: DataHandleRead }> {

  // find paths matched by `whereJsonQuery`
  const allHits = nodes(await src.ReadObject<any>(), whereJsonQuery).sort((a, b) => a.path.length - b.path.length);
  if (allHits.length === 0) {
    return { anyHit: false, result: src };
  }

  // filter out sub-hits (only consider highest hit)
  const hits: { path: JsonPath, value: any }[] = [];
  for (const hit of allHits) {
    if (hits.every(existingHit => !IsPrefix(existingHit.path, hit.path))) {
      hits.push(hit);
    }
  }

  // process
  let ast: YAMLNode = await src.ReadYamlAst();
  let mapping = From(IdentitySourceMapping(src.key, ast)).Where(m => hits.every(hit => !IsPrefix(hit.path, (m.generated as any).path)));
  for (const hit of hits) {
    if (ast === undefined) {
      throw new Error("Cannot remove root node.");
    }
    const newObject = transformer(hit.value);
    const newAst = newObject === undefined
      ? undefined
      : ToAst(newObject); // <- can extend ToAst to also take an "ambient" object with AST, in order to create anchor refs for existing stuff!
    const oldAst = ResolveRelativeNode(ast, ast, hit.path);
    ast = ReplaceNode(ast, oldAst, newAst) || (() => { throw new Error("Cannot remove root node."); })();

    // patch source map
    if (newAst !== undefined && mappingInfo) {
      mapping = mapping.Concat(
        From(Descendants(newAst)).Select(descendant => {
          return <Mapping>{
            name: `Injected object at '${stringify(hit.path)}' (${mappingInfo.reason})`,
            source: mappingInfo.transformerSourceHandle.key,
            original: mappingInfo.transformerSourcePosition,
            generated: { path: hit.path.concat(descendant.path) }
          };
        }));
      mapping = mapping.Concat([{
        name: `Original object at '${stringify(hit.path)}' (${mappingInfo.reason})`,
        source: src.key,
        original: { path: hit.path },
        generated: { path: hit.path }
      }]);
    }
  }

  // write back
  const resultHandle = await target.WriteData(StringifyAst(ast), mapping, mappingInfo ? [src, mappingInfo.transformerSourceHandle] : [src]);
  return {
    anyHit: true,
    result: resultHandle
  };
}