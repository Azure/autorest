/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { arrayOf, AutorestConfiguration, ResolvedDirective, resolveDirectives } from "@autorest/configuration";
import { JsonPath, matches } from "@azure-tools/datastore";
import { Message } from "../message";

export class Suppressor {
  private suppressions: Array<ResolvedDirective>;

  public constructor(config: AutorestConfiguration) {
    this.suppressions = resolveDirectives(config, (x) => x.suppress.length > 0);
  }

  private matchesSourceFilter(document: string, path: JsonPath | undefined, supression: ResolvedDirective): boolean {
    // from
    const from = arrayOf(supression.from);
    const matchesFrom = from.length === 0 || from.find((d) => document.toLowerCase().endsWith(d.toLowerCase()));

    // where
    const where = arrayOf(supression.where);
    const matchesWhere = where.length === 0 || (path && where.find((w) => matches(w, path))) || false;

    return Boolean(matchesFrom && matchesWhere);
  }

  public filter(m: Message): Message | null {
    const hadSource = m.Source && m.Source.length > 0;
    // filter
    for (const sup of this.suppressions) {
      // matches key
      const key = m.Key ? [...m.Key] : [];
      if (key.find((k) => arrayOf(sup.suppress).find((s) => k.toLowerCase() === s.toLowerCase()))) {
        // filter applicable sources
        if (m.Source && hadSource) {
          m.Source = m.Source.filter((s) => !this.matchesSourceFilter(s.document, (<any>s.Position).path, sup));
        } else {
          return null;
        }
      }
    }

    // drop message if all source locations have been stripped
    if (hadSource && m.Source?.length === 0) {
      return null;
    }

    return m;
  }

  // TODO: make method that'll complain about suppressions that weren't used!
}
