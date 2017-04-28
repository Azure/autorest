import { nodes } from '../ref/jsonpath';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { safeEval } from "../ref/safe-eval";
import { ManipulateObject } from "./object-manipulator";
import { DataHandleRead, DataStoreView } from "../data-store/data-store";
import { DirectiveView } from "../configuration";
import { ConfigurationView } from "../autorest-core";
import { From } from "../ref/linq";
import { Channel, Message, SourceLocation } from '../message';

export class Manipulator {
  private transformations: DirectiveView[];

  public constructor(private config: ConfigurationView) {
    this.transformations = From(config.Directives).Where(x => [...x.transform].length > 0 || [...x.set].length > 0).ToArray();
  }

  private MatchesSourceFilter(document: string, transform: DirectiveView): boolean {
    // from
    const from = From(transform.from);
    const matchesFrom = !from.Any() || from
      .Select(d => d.toLowerCase())
      .Any(d =>
        document.toLowerCase().endsWith(d) ||
        document.toLowerCase().indexOf("/" + d) !== -1);

    return matchesFrom;
  }

  public async Process(data: DataHandleRead, scope: DataStoreView, documentId?: string): Promise<DataHandleRead> {
    let nextId = (() => { let i = 0; return () => ++i; })();
    for (const trans of this.transformations) {
      // matches filter?
      if (this.MatchesSourceFilter(documentId || data.key, trans)) {
        for (const w of trans.where) {
          // transform
          for (const t of trans.transform) {
            const target = await scope.Write(`transform_${nextId()}.yaml`);
            data = (await ManipulateObject(data, target, w, (doc, obj, path) => safeEval<any>(`(() => { { ${t} }; return $; })()`, { $: obj, $doc: doc, $path: path }))).result;
          }
          // set
          for (const s of trans.set) {
            const target = await scope.Write(`set_${nextId()}.yaml`);
            data = (await ManipulateObject(data, target, w, obj => s)).result;
          }
          // test
          for (const t of trans.test) {
            const doc = data.ReadObject<any>();
            const allHits = nodes(doc, w).sort((a, b) => a.path.length - b.path.length);
            for (const hit of allHits) {
              let testResults = safeEval<any>(`(() => { { ${t} }; return (${t}); })()`, { $: hit.value, $doc: doc, $path: hit.path });
              if (!testResults) {
                if (!Array.isArray(testResults)) {
                  testResults = [testResults];
                }
                for (const testResult of testResults) {
                  const messageText = typeof testResult === "string" ? testResult : "Custom test failed";
                  const message = (testResult as Message).Text
                    ? testResult as Message
                    : <Message>{ Text: messageText, Channel: Channel.Warning, Details: testResult };
                  message.Source = message.Source || [<SourceLocation>{ Position: { path: hit.path } }];
                  for (const src of message.Source) {
                    src.document = src.document || data.key;
                  }
                }
              }
            }
          }
        }
      }
    }

    return data;
  }

  // TODO: make method that'll warn about transforms that weren't used!
}