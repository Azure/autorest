/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { nodes } from "../ref/jsonpath";
import { safeEval } from "../ref/safe-eval";
import { ManipulateObject } from "./object-manipulator";
import { DataHandleRead, DataStoreView } from "../data-store/data-store";
import { DirectiveView } from "../configuration";
import { ConfigurationView } from "../autorest-core";
import { From } from "../ref/linq";
import { Channel, Message, SourceLocation } from "../message";

export class Manipulator {
  private transformations: DirectiveView[];
  private ctr = 0;

  public constructor(private config: ConfigurationView) {
    this.transformations = From(config.Directives).ToArray();
  }

  private MatchesSourceFilter(document: string, transform: DirectiveView): boolean {
    document = "/" + document;

    // console.log(document, [...transform.from]);

    // from
    const from = From(transform.from);
    const matchesFrom = !from.Any() || from
      .Any(d =>
        document.endsWith("/" + d) ||
        document.indexOf("/" + d + "/") !== -1);

    return matchesFrom;
  }

  private async ProcessInternal(data: DataHandleRead, scope: DataStoreView, documentId?: string): Promise<DataHandleRead> {
    for (const trans of this.transformations) {
      // matches filter?
      if (this.MatchesSourceFilter(documentId || data.key, trans)) {
        for (const w of trans.where) {
          // transform
          for (const t of trans.transform) {
            const target = await scope.Write(`transform_${++this.ctr}.yaml`);
            const result = await ManipulateObject(data, target, w,
              (doc, obj, path) => safeEval<any>(`(() => { { ${t} }; return $; })()`, { $: obj, $doc: doc, $path: path })/*,
              {
                reason: trans.reason,
                transformerSourceHandle: // TODO
              }*/);
            if (!result.anyHit) {
              // this.config.Message({
              //   Channel: Channel.Warning,
              //   Details: trans,
              //   Text: `Transformation directive with 'where' clause '${w}' was not used.`
              // });
            }
            data = result.result;
          }
          // set
          for (const s of trans.set) {
            const target = await scope.Write(`set_${++this.ctr}.yaml`);
            const result = await ManipulateObject(data, target, w, obj => s/*,
              {
                reason: trans.reason,
                transformerSourceHandle: // TODO
              }*/);
            if (!result.anyHit) {
              // this.config.Message({
              //   Channel: Channel.Warning,
              //   Details: trans,
              //   Text: `Set directive with 'where' clause '${w}' was not used.`
              // });
            }
            data = result.result;
          }
          // test
          for (const t of trans.test) {
            const doc = data.ReadObject<any>();
            const allHits = nodes(doc, w);
            for (const hit of allHits) {
              let testResults = [...safeEval<any>(`(function* () { ${t.indexOf("yield") === -1 ? `yield (${t}\n)` : `${t}\n`} })()`, { $: hit.value, $doc: doc, $path: hit.path })];
              for (const testResult of testResults) {
                if (testResult === false || typeof testResult !== "boolean") {
                  const messageText = typeof testResult === "string" ? testResult : "Custom test failed";
                  const message = (testResult as Message).Text
                    ? testResult as Message
                    : <Message>{ Text: messageText, Channel: Channel.Warning, Details: testResult };
                  message.Source = message.Source || [<SourceLocation>{ Position: { path: hit.path } }];
                  for (const src of message.Source) {
                    src.document = src.document || data.key;
                  }
                  this.config.Message(message);
                }
              }
            }
            if (allHits.length === 0) {
              // this.config.Message({
              //   Channel: Channel.Warning,
              //   Details: trans,
              //   Text: `Test directive with 'where' clause '${w}' was not used.`
              // });
            }
          }
        }
      }
    }

    return data;
  }

  public async Process(data: DataHandleRead, scope: DataStoreView, documentId?: string): Promise<DataHandleRead> {
    // if the input data is not an object (e.g. raw source code) transform to string object and back
    const needsTransform = !data.IsObject();

    const trans1 = needsTransform ? await (await scope.Write(`trans_input?${data.key}`)).WriteObject(data.ReadData()) : data;
    const result = await this.ProcessInternal(trans1, scope, documentId);
    const trans2 = needsTransform ? await (await scope.Write(`trans_output?${data.key}`)).WriteData(result.ReadObject<string>()) : result;
    return trans2;
  }
}