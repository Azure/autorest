/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DEFAULT_SCHEMA, dump, load, Schema } from "js-yaml";

const propertyPriority = [
  "info",
  "$key",
  "booleans",
  "numbers",
  "chars",
  "strings",
  "choices",
  "sealedChoices",
  "constants",
  "dictionaries",
  "compounds",

  "name",
  "schemas",
  "type",
  "format",
  "schema",
  "operationId",
  "path",
  "method",
  "description",
  "default",
];

const propertyNegativePriority = [
  "objects",
  "arrays",
  "request",
  "responses",
  "exceptions",
  "callbacks",
  "http",
  "commands",
  "operations",
  "extensions",
  "details",
  "language",
  "protocol",
];

function sortWithPriorty(a: any, b: any): number {
  if (a == b) {
    return 0;
  }
  const ia = propertyPriority.indexOf(a);
  const ib = propertyPriority.indexOf(b);
  const na = propertyNegativePriority.indexOf(a);
  const nb = propertyNegativePriority.indexOf(b);

  const dota = `${a}`.startsWith(".");
  const dotb = `${b}`.startsWith(".");

  if (dota) {
    if (!dotb) {
      return 1;
    }
  } else {
    if (dotb) {
      return -1;
    }
  }

  if (na > -1) {
    if (nb > -1) {
      return na - nb;
    }
    return 1;
  }

  if (nb > -1) {
    return -1;
  }

  if (ia != -1) {
    return ib != -1 ? ia - ib : -1;
  }

  return ib != -1 || a > b ? 1 : a < b ? -1 : 0;
}

export function deserialize<T>(text: string, filename: string, schema: Schema = DEFAULT_SCHEMA): T {
  return (load(text, {
    schema,
    filename,
  }) as any) as T;
}

export interface SerializeOptions {
  schema?: Schema;
  sortKeys?: boolean;
}

export function serialize<T>(model: T, schemaOrOptions: Schema | SerializeOptions = DEFAULT_SCHEMA): string {
  const options: SerializeOptions =
    schemaOrOptions instanceof Schema
      ? { schema: schemaOrOptions, sortKeys: true }
      : { schema: DEFAULT_SCHEMA, sortKeys: true, ...schemaOrOptions };

  return dump(model, {
    schema: options.schema,
    sortKeys: options.sortKeys && sortWithPriorty,
    skipInvalid: true,
    lineWidth: 240,
  });
  // .replace(/\s*\w*: {}/g, '')
  // .replace(/\s*\w*: \[\]/g, '')
  // .replace(/(\s*- \$key:)/g, '\n$1')
  // .replace(/-\n\s+version/g, '- version');
  // .replace(/(\s*)(language:)/g, '\n$1## ----------------------------------------------------------------------$1$2')
  // replace(/([^:]\n)(\s*-)/g, '$1\n$2')

  //.replace(/(\s*language:)/g, '\n$1');
}
