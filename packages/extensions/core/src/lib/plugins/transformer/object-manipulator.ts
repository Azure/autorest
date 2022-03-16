/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { inspect } from "util";
import {
  DataHandle,
  DataSink,
  IdentityPathMappings,
  IsPrefix,
  JsonPath,
  nodes,
  PathPosition,
} from "@azure-tools/datastore";
import {
  stringifyYamlAst,
  cloneYamlAst,
  getYamlNodeValue,
  valueToAst,
  YamlNode,
  getYamlNodeByPath,
  replaceYamlAstNode,
} from "@azure-tools/yaml";
import { cloneDeep } from "lodash";
import { AutorestContext } from "../../autorest-core";

export async function manipulateObject(
  src: DataHandle,
  target: DataSink,
  whereJsonQuery: string,
  transformer: (doc: any, obj: any, path: JsonPath) => any, // transforming to `undefined` results in removal
  config?: AutorestContext,
  transformationString?: string,
  debug?: boolean,
  mappingInfo?: {
    transformerSourceHandle: DataHandle;
    transformerSourcePosition: PathPosition;
    reason: string;
  },
): Promise<{ anyHit: boolean; result: DataHandle }> {
  if (whereJsonQuery === "$") {
    if (debug && config) {
      config.debug("Query is $ runnning directive transform on raw text.");
    }
    const data = await src.readData();
    const newObject = transformer(null, data, []);
    if (newObject !== data) {
      if (debug && config) {
        config.debug("Directive transform changed text. Skipping object transform.");
      }
      const resultHandle = await target.writeData(src.description, newObject, src.identity, src.artifactType);
      return {
        anyHit: true,
        result: resultHandle,
      };
    }
  }

  // find paths matched by `whereJsonQuery`

  let ast: YamlNode = cloneYamlAst(await src.readYamlAst());
  const { result: doc } = getYamlNodeValue<any>(ast);
  const hits = nodes(doc, whereJsonQuery).sort((a, b) => a.path.length - b.path.length);
  if (hits.length === 0) {
    if (debug && config) {
      config.debug(`Directive transform \`${whereJsonQuery}\` didn't match any path in the document`);
    }
    return { anyHit: false, result: src };
  }

  for (const hit of hits) {
    if (ast === undefined) {
      throw new Error("Cannot remove root node.");
    }
    if (debug && config) {
      config.debug(
        `Directive transform match path '/${hit.path.join("/")}'. Running on value:\n------------\n${inspect(
          hit.value,
        )}\n------------`,
      );
    }

    try {
      const newObject = transformer(doc, cloneDeep(hit.value), hit.path);
      if (debug && config) {
        config.debug(`Transformed Result:\n------------\n${inspect(newObject)}\n------------`);
      }
      const newAst = newObject === undefined ? undefined : valueToAst(newObject); // <- can extend ToAst to also take an "ambient" object with AST, in order to create anchor refs for existing stuff!
      const oldAst = getYamlNodeByPath(ast, hit.path);
      ast =
        replaceYamlAstNode(ast, oldAst, newAst) ||
        (() => {
          throw new Error("Cannot remove root node.");
        })();
    } catch (error: any) {
      // Background: it can happen that one transformation fails but the others are still valid. One typical use case is
      // the common parameters versus normal HTTP operations. They are on the same level in the path, so the commonly used
      // '$.paths.*.*' "where selection" finds both, however, most probably the transformation should and can be executed
      // either on the parameters or on the HTTP operations, i.e. one of the transformations will fail.
      if (config != null) {
        let errorText = `Directive with 'where' clause '${whereJsonQuery}' failed by path '${hit.path}:\n`;
        if (transformationString != null) {
          const formattedCode = `\`\`\`\n${transformationString}\n\`\`\``;
          errorText = `Directive with 'where' clause '${whereJsonQuery}' failed to execute transformation in path '${hit.path}':\n ${formattedCode}\n`;
        }

        config.trackWarning({
          code: "Transform/DirectiveCodeError",
          message: `${errorText}  '${error.message}'`,
          details: {
            error,
          },
        });
      }
    }
    /*
        // patch source map
        if (newAst !== undefined) {
          const reasonSuffix = mappingInfo ? ` (${mappingInfo.reason})` : '';
          if (mappingInfo) {
            mapping.push(
              ...From(Descendants(newAst)).Select((descendant: any) => {
                return <Mapping>{
                  name: `Injected object at '${stringify(hit.path)}'${reasonSuffix}`,
                  source: mappingInfo.transformerSourceHandle.key,
                  original: mappingInfo.transformerSourcePosition,
                  generated: { path: hit.path.concat(descendant.path) }
                };
              }));
          }

          // try to be smart and assume that nodes existing in both old and new AST have a relationship
          mapping.push(
            ...From(Descendants(newAst))
              .Where((descendant: any) => paths(doc, stringify(hit.path.concat(descendant.path))).length === 1)
              .Select((descendant: any) => {
                return <Mapping>{
                  name: `Original object at '${stringify(hit.path)}'${reasonSuffix}`,
                  source: src.key,
                  original: { path: hit.path.concat(descendant.path) },
                  generated: { path: hit.path.concat(descendant.path) }
                };
              }));
        }
        */
  }

  // write back
  const resultHandle = await target.writeData("manipulated", stringifyYamlAst(ast), src.identity, src.artifactType, {
    pathMappings: new IdentityPathMappings(src.key),
  });
  return {
    anyHit: true,
    result: resultHandle,
  };
}
