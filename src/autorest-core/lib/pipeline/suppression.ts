/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DirectiveView } from "../configuration";
import { Message } from "../message";
import { ConfigurationView } from "../autorest-core";
import { JsonPath, matches } from "../ref/jsonpath";
import { From } from "../ref/linq";

export class Suppressor {
  private suppressions: DirectiveView[];

  public constructor(private config: ConfigurationView) {
    this.suppressions = config.Directives.filter(x => [...x.suppress].length > 0);
  }

  private MatchesSourceFilter(document: string, path: JsonPath | undefined, supression: DirectiveView): boolean {
    // from
    const from = From(supression.from);
    const matchesFrom = !from.Any() || from.Any(d => document.toLowerCase().endsWith(d.toLowerCase()));

    // where
    const where = From(supression.where);
    const matchesWhere = !where.Any() || (path && where.Any(w => matches(w, path))) || false;

    return matchesFrom && matchesWhere;
  }

  public Filter(m: Message): Message | null {
    // the message does not have a source attached to it - assume it may pass
    if (!m.Source || m.Source.length === 0) {
      return m;
    }

    // filter
    for (const sup of this.suppressions) {
      // matches key
      if (From(m.Key || []).Any(k => From(sup.suppress).Any(s => k.toLowerCase() === s.toLowerCase()))) {
        // filter applicable sources
        m.Source = m.Source.filter(s => !this.MatchesSourceFilter(s.document, (s.Position as any).path, sup));
      }
    }

    // drop message if all source locations have been stripped
    if (m.Source.length === 0) {
      return null;
    }

    return m;
  }

  // TODO: make method that'll complain about suppressions that weren't used!
}