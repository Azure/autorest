/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, nodes, createSandbox } from '@azure-tools/datastore';
import { YieldCPU } from '@azure-tools/tasks';
import { ConfigurationView } from '../autorest-core';
import { ResolvedDirective } from '../configuration';
import { Channel, Message, SourceLocation } from '../message';
import { manipulateObject } from './object-manipulator';
import { values } from '@azure-tools/linq';

const safeEval = createSandbox();

export class Manipulator {
  private transformations: Array<ResolvedDirective>;
  private ctr = 0;

  public constructor(private config: ConfigurationView) {
    this.transformations = config.resolveDirectives(directive => directive.from.length > 0 && directive.transform.length > 0 && directive.where.length > 0);
  }

  private matchesSourceFilter(document: string, transform: ResolvedDirective, artifact: string | null): boolean {
    document = '/' + document;
    return values(transform.from).any(each => artifact === each || document.endsWith('/' + each));
  }

  private async processInternal(data: DataHandle, sink: DataSink, documentId?: string): Promise<DataHandle> {
    for (const directive of this.transformations) {
      // matches filter?
      if (this.matchesSourceFilter(documentId || data.key, directive, data.artifactType)) {
        try {
          for (const w of directive.where) {
            // transform
            for (const t of directive.transform) {
              await YieldCPU();
              const result = await manipulateObject(data, sink, w,
                (doc, obj, path) => {
                  return safeEval<any>(`(() => { { ${t} }; return $; })()`, { $: obj, $doc: doc, $path: path, $documentPath: data.originalFullPath });
                },
                this.config,
                t

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
            for (const t of directive.test) {
              const doc = await data.ReadObject<any>();
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
        } catch {
          // TODO: Temporary comment. First I will make the modifiers for PowerShell work. It shouldn't fail with PowerShell modifiers.
          // throw Error(`Directive given has something wrong. - ${JSON.stringify(trans['directive'], null, 2)} - It could be badly formatted or not being declared. Please check your configuration file. `);
        }
      }
    }

    return data;
  }

  public async process(data: DataHandle, sink: DataSink, isObject: boolean, documentId?: string): Promise<DataHandle> {
    const trans1 = !isObject ? await sink.WriteObject(`trans_input?${data.key}`, await data.ReadData(), data.identity, data.artifactType) : data;
    const result = await this.processInternal(trans1, sink, documentId);
    return (!isObject) ? sink.WriteData(`trans_output?${data.key}`, await result.ReadObject<string>(), data.identity, data.artifactType) : result;
  }
}
