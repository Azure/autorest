/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { nodes } from "../ref/jsonpath";
import { safeEval } from "../ref/safe-eval";
import { ManipulateObject } from "./object-manipulator";
import { DataHandle, DataSink } from '../data-store/data-store';
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

  private MatchesSourceFilter(document: string, transform: DirectiveView, artifact: string | null): boolean {
    document = "/" + document;

    // from
    const from = From(transform.from);
    const matchesFrom = !from.Any() || from
      .Any(d =>
        artifact === d ||
        document.endsWith("/" + d));

    // console.log(matchesFrom, document, artifact, [...transform.from]);

    return matchesFrom;
  }

  private async ProcessInternal(data: DataHandle, sink: DataSink, documentId?: string): Promise<DataHandle> {
    for (const trans of this.transformations) {
      // matches filter?
      if (this.MatchesSourceFilter(documentId || data.key, trans, data.GetArtifact())) {
        for (const w of trans.where) {
          // transform
          for (const t of trans.transform) {
            const result = await ManipulateObject(data, sink, w,
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
            const result = await ManipulateObject(data, sink, w, obj => s/*,
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

  public async Process(data: DataHandle, sink: DataSink, isObject: boolean, documentId?: string): Promise<DataHandle> {
    const trans1 = !isObject ? await sink.WriteObject(`trans_input?${data.key}`, data.ReadData()) : data;
    const result = await this.ProcessInternal(trans1, sink, documentId);
    const trans2 = !isObject ? await sink.WriteData(`trans_output?${data.key}`, result.ReadObject<string>()) : result;
    return trans2;
  }
}