/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfigurationManager } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/dataStore";
import { parse } from "../parsing/literateYaml";
import { mergeYamls } from "../source-map/merging";

export type PipelineProducts = { [productKey: string]: DataStoreViewReadonly };
export type MultiPromise<T> = Promise<{ current: T, next: MultiPromise<T> } | null>;
export type DataPromise = MultiPromise<DataHandleRead>;

export module MultiPromiseUtility {
  export function empty<T>(): MultiPromise<T> {
    return Promise.resolve(null);
  }
  export function single<T>(value: T): MultiPromise<T> {
    return fromPromise<T>(Promise.resolve(value));
  }
  export function fromPromise<T>(promise: Promise<T>): MultiPromise<T> {
    return new Promise<{ current: T, next: MultiPromise<T> }>((resolve, reject) => {
      promise.then(value => resolve({ current: value, next: empty<T>() }));
      promise.catch(err => reject(err));
    });
  }

  export async function gather<T>(promise: MultiPromise<T>): Promise<Iterable<T>> {
    const res = await promise;
    if (res === null) {
      return [];
    }
    const tail = await gather<T>(res.next);
    return (function* () {
      yield res.current;
      yield* tail;
    })();
  }

  export async function map<T, U>(promise: MultiPromise<T>, selector: (item: T, index: number) => Promise<U>, startIndex: number = 0): MultiPromise<U> {
    const head = await promise;
    if (head === null) {
      return null;
    }
    const current = await selector(head.current, startIndex);
    return {
      current: current,
      next: map(head.next, selector, startIndex + 1)
    };
  }
}

type DataFactory = (workingScope: DataStoreViewReadonly) => DataPromise;

function pluginInput(inputFileUri: string): DataFactory {
  return async (workingScope: DataStoreViewReadonly) => {
    const handle = await workingScope.read(inputFileUri);
    if (handle === null) {
      throw new Error(`Input file '${inputFileUri}' not found.`);
    }
    return MultiPromiseUtility.single(handle);
  };
}

function pluginDeliteralizeYaml(literate: DataPromise): DataFactory {
  return (workingScope: DataStoreView) => MultiPromiseUtility.map(literate, async (literateDoc, index) => {
    const docScope = workingScope.createScope(`doc${index}_tmp`);
    const hwRawDoc = await workingScope.write(`doc${index}.yaml`);
    const hRawDoc = await parse(literateDoc, hwRawDoc, docScope);
    return hRawDoc;
  });
}

export class Pipeline {
  constructor(private configuration: AutoRestConfigurationManager) {
  }

  private async build(): Promise<void> {
    // bleep
  }

  public async run(pipelineView: DataStoreView): Promise<PipelineProducts> {
    await this.build();

    // RUN pipeline
    const result: PipelineProducts = {};

    // load Swaggers
    const swaggerScope = pipelineView.createScope("swagger");
    const rawSwaggers: DataHandleRead[] = [];
    let i = 0;
    for (const inputFileUri of this.configuration.inputFileUris) {
      // read literate Swagger
      const readThroughScope = pipelineView.createReadThroughScope(KnownScopes.Input, uri => uri === inputFileUri);
      const pluginSwaggerInput: DataPromise = pluginInput(inputFileUri)(readThroughScope);
      const pluginDeliteralizeSwagger: DataPromise = pluginDeliteralizeYaml(pluginSwaggerInput)(swaggerScope.createScope("deliteralize_" + i));
      rawSwaggers.push(...Array.from(await MultiPromiseUtility.gather(pluginDeliteralizeSwagger)));
      i++;
    }
    // merge swaggers
    const hwSwagger = await swaggerScope.write("swagger.yaml");
    const hSwagger = await mergeYamls(rawSwaggers, hwSwagger);

    return result;
  }
}