/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, nodes, safeEval } from '@microsoft.azure/datastore';
import { From } from 'linq-es2015';
import { ConfigurationView } from '../autorest-core';
import { DirectiveView } from '../configuration';
import { Channel, Message, SourceLocation } from '../message';
import { manipulateObject } from './object-manipulator';

export class Manipulator {
  private transformations: Array<DirectiveView>;
  private ctr = 0;

  public constructor(private config: ConfigurationView) {
    this.transformations = config.Directives;
  }

  private matchesSourceFilter(document: string, transform: DirectiveView, artifact: string | null): boolean {
    document = '/' + document;
    // from
    const from = From(transform.from);
    return (!from.Any()) || (from.Any(d => artifact === d || document.endsWith('/' + d)));
  }

  private async processInternal(data: DataHandle, sink: DataSink, documentId?: string): Promise<DataHandle> {
    for (const trans of this.transformations) {
      // matches filter?
      if (this.matchesSourceFilter(documentId || data.key, trans, data.artifactType)) {
        for (const w of trans.where) {
          // transform
          for (const t of trans.transform) {
            const result = await manipulateObject(data, sink, w,
              (doc, obj, path) => {
                return safeEval<any>(`(() => { { ${t} }; return $; })()`, { $: obj, $doc: doc, $path: path, $documentPath: data.originalFullPath });
              }

              /*,
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
          // test
          for (const t of trans.test) {
            const doc = data.ReadObject<any>();
            const allHits = nodes(doc, w);
            for (const hit of allHits) {
              const testResults = [...safeEval<any>(`(function* () { ${t.indexOf('yield') === -1 ? `yield (${t}\n)` : `${t}\n`} })()`, { $: hit.value, $doc: doc, $path: hit.path })];
              for (const testResult of testResults) {
                if (testResult === false || typeof testResult !== 'boolean') {
                  const messageText = typeof testResult === 'string' ? testResult : 'Custom test failed';
                  const message = (<Message>testResult).Text
                    ? <Message>testResult
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

  public async process(data: DataHandle, sink: DataSink, isObject: boolean, documentId?: string): Promise<DataHandle> {
    const trans1 = !isObject ? await sink.WriteObject(`trans_input?${data.key}`, data.ReadData(), data.identity) : data;
    const result = await this.processInternal(trans1, sink, documentId);
    return (!isObject) ? sink.WriteData(`trans_output?${data.key}`, result.ReadObject<string>(), data.identity) : result;
  }
}
