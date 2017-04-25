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
            data = (await ManipulateObject(data, target, w, obj => safeEval(`(() => { { ${t} }; return $; })()`, { $: obj, $doc: data.ReadObject() }))).result;
          }
          // set
          for (const s of trans.set) {
            const target = await scope.Write(`set_${nextId()}.yaml`);
            data = (await ManipulateObject(data, target, w, obj => s)).result;
          }
        }
      }
    }

    return data;
  }

  // TODO: make method that'll warn about transforms that weren't used!
}