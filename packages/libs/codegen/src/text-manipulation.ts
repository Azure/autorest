/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Text, TextPossibilities } from "./file-generator";
import { Dictionary, values } from "@azure-tools/linq";

let indentation = "    ";

export const lineCommentPrefix = "//";
export const docCommentPrefix = "///";
export const EOL = "\n";
export const CommaChar = ", ";

const acronyms = new Set([
  "ip",
  "os",
  "ms",
  "vm", //  'ssl', 'https', 'http', ''
]);

declare global {
  interface Array<T> {
    joinWith(selector: (t: T) => string, separator?: string): string;
    last: T;
  }

  interface String {
    capitalize(): string;
    uncapitalize(): string;
    slim(): string;
  }
}

/** joins an array by passing thru a selector and uses the separator string (defaults to comma) */
Array.prototype.joinWith = function <T>(selector: (t: T) => string, separator?: string): string {
  return (<Array<T>>this)
    .map(selector)
    .filter((v) => (v ? true : false))
    .join(separator || CommaChar);
};

/** todo: can we remove this? */
/* eslint-disable */
if (!Array.prototype.hasOwnProperty('last')) {
  Object.defineProperty(Array.prototype, 'last', {
    get() {
      return this[this.length - 1];
    }
  });
}

String.prototype.capitalize = function (): string {
  const result = <string>this;
  if (acronyms.has(result)) {
    return result.toUpperCase();
  }
  return result ? `${result.charAt(0).toUpperCase()}${result.substr(1)}` : result;
};
String.prototype.uncapitalize = function (): string {
  const result = <string>this;
  return result ? `${result.charAt(0).toLowerCase()}${result.substr(1)}` : result;
};
/** Trims the string and removes multi leading spaces? */
String.prototype.slim = function (): string {
  return this.trim().replace(/([^ ])  +/g, '$1 ');
};

export function join<T>(items: Array<T>, separator: string) {
  return items.filter(v => v ? true : false).join(separator);
}

export function joinComma<T>(items: Array<T>, mapFn: (item: T) => string) {
  return join(items.map(mapFn), CommaChar);
}

export interface IHasName {
  name: string;
}

export function sortByName(a: IHasName, b: IHasName): number {
  return a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
}

export function setIndentation(spaces: number) {
  indentation = ' '.repeat(spaces);
}

export function trimDots(content: string) {
  return content.replace(/^[.\s]*(.*?)[.\s]*$/g, '$1');
}

export function toMap<T>(source: Array<T>, eachFn: (item: T) => string): Map<string, Array<T>> {
  const result = new Map<string, Array<T>>();

  for (const each of source) {
    const key = eachFn(each);
    let values = result.get(key);
    if (!values) {
      values = new Array<T>();
      result.set(key, values);
    }
    values.push(each);
  }
  return result;
}

export function fixEOL(content: string) {
  return content.replace(/\r\n/g, EOL);
}

export function indent(content: string, factor: number = 1): string {
  const i = indentation.repeat(factor);
  content = i + fixEOL(content.trim());
  return content.split(/\n/g).join(`${EOL}${i}`);
}

export function comment(content: string, prefix = lineCommentPrefix, factor = 0, maxLength = 120) {
  const result = new Array<string>();
  let line = '';
  prefix = indent(prefix, factor);

  content = content.trim();
  if (content) {
    for (const word of content.replace(/\n+/g, ' » ').split(/\s+/g)) {
      if (word === '»') {
        result.push(line);
        line = prefix;
        continue;
      }

      if (maxLength < line.length) {
        result.push(line);
        line = '';
      }

      if (!line) {
        line = prefix;
      }

      line += ` ${word}`;
    }
    if (line) {
      result.push(line);
    }

    return result.join(EOL);
  }
  return '';
}

export function docComment(content: string, prefix = docCommentPrefix, factor = 0, maxLength = 120) {
  return comment(content, prefix, factor, maxLength);
}

export function dotCombine(prefix: string, content: string) {
  return trimDots([trimDots(prefix), trimDots(content)].join('.'));
}


export function map<T, U>(dictionary: Dictionary<T>, callbackfn: (key: string, value: T) => U, thisArg?: any): Array<U> {
  return Object.getOwnPropertyNames(dictionary).map((key) => callbackfn(key, dictionary[key]));
}

export function ToMap<T>(dictionary: Dictionary<T>): Map<string, T> {
  const result = new Map<string, T>();
  Object.getOwnPropertyNames(dictionary).map(key => result.set(key, dictionary[key]));
  return result;
}

export function __selectMany<T>(multiArray: Array<Array<T>>): Array<T> {
  const result = new Array<T>();
  multiArray.map(v => result.push(...v));
  return result;
}


export function pall<T, U>(array: Array<T>, callbackfn: (value: T, index: number, array: Array<T>) => Promise<U>, thisArg?: any): Promise<Array<U>> {
  return Promise.all(array.map(callbackfn));
}

export function deconstruct(identifier: string | Array<string>): Array<string> {
  if (Array.isArray(identifier)) {
    return [...values(identifier).selectMany(deconstruct)];
  }
  return `${identifier}`.
    replace(/([a-z]+)([A-Z])/g, '$1 $2').
    replace(/(\d+)([a-z|A-Z]+)/g, '$1 $2').
    replace(/\b([A-Z]+)([A-Z])([a-z])/, '$1 $2$3').
    split(/[\W|_]+/).map(each => each.toLowerCase());
}

export function isCapitalized(identifier: string): boolean {
  return /^[A-Z]/.test(identifier);
}

const ones = ['', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
const teens = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
const tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
const magnitude = ['thousand', 'million', 'billion', 'trillion', 'quadrillion', 'quintillion', 'septillion', 'octillion'];
const magvalues = [10 ** 3, 10 ** 6, 10 ** 9, 10 ** 12, 10 ** 15, 10 ** 18, 10 ** 21, 10 ** 24, 10 ** 27];

export function* convert(num: number): Iterable<string> {
  if (!num) {
    yield 'zero';
    return;
  }
  if (num > 1e+30) {
    yield 'lots';
    return;
  }

  if (num > 999) {
    for (let i = magvalues.length; i > -1; i--) {
      const c = magvalues[i];
      if (num > c) {
        yield* convert(Math.floor(num / c));
        yield magnitude[i];
        num = num % c;

      }
    }
  }
  if (num > 99) {
    yield ones[Math.floor(num / 100)];
    yield 'hundred';
    num %= 100;
  }
  if (num > 19) {
    yield tens[Math.floor(num / 10)];
    num %= 10;
  }
  if (num) {
    yield ones[num];
  }
}

export function fixLeadingNumber(identifier: Array<string>): Array<string> {
  if (identifier.length > 0 && /^\d+/.exec(identifier[0])) {
    return [...convert(parseInt(identifier[0])), ...identifier.slice(1)];
  }
  return identifier;
}

export function removeProhibitedPrefix(identifier: string, prohibitedPrefix: string, skipIdentifiers?: Array<string>): string {
  if (identifier.toLowerCase().startsWith(prohibitedPrefix.toLowerCase())) {
    const regex = new RegExp(`(^${prohibitedPrefix})(.*)`, 'i');
    let newIdentifier = identifier.replace(regex, '$2');
    if (newIdentifier.length < 2) {
      // if it results in an empty string or a single letter string
      // then, it is not really a word.
      return identifier;
    }

    newIdentifier = isCapitalized(identifier) ? newIdentifier.capitalize() : newIdentifier.uncapitalize();
    return (skipIdentifiers !== undefined) ? skipIdentifiers.includes(newIdentifier) ? identifier : newIdentifier : newIdentifier;
  }

  return identifier;
}


export function isEqual(s1: string, s2: string): boolean {
  // when s2 is undefined and s1 is the string 'undefined', it returns 0, making this true.
  // To prevent that, first we need to check if s2 is undefined.
  return s2 !== undefined && !!s1 && !s1.localeCompare(s2, undefined, { sensitivity: 'base' });
}

export function removeSequentialDuplicates(identifier: Iterable<string>) {
  const ids = [...identifier].filter(each => !!each);
  for (let i = 0; i < ids.length; i++) {
    while (isEqual(ids[i], ids[i - 1])) {
      ids.splice(i, 1);
    }
    while (isEqual(ids[i], ids[i - 2]) && isEqual(ids[i + 1], ids[i - 1])) {
      ids.splice(i, 2);
    }
  }

  return ids;
}

export function pascalCase(identifier: string | Array<string>, removeDuplicates = true): string {
  return identifier === undefined ? '' : typeof identifier === 'string' ?
    pascalCase(fixLeadingNumber(deconstruct(identifier)), removeDuplicates) :
    (removeDuplicates ? [...removeSequentialDuplicates(identifier)] : identifier).map(each => each.capitalize()).join('');
}


export function camelCase(identifier: string | Array<string>): string {
  if (typeof (identifier) === 'string') {
    return camelCase(fixLeadingNumber(deconstruct(identifier)));
  }
  switch (identifier.length) {
    case 0:
      return '';
    case 1:
      return identifier[0].uncapitalize();
  }
  return `${identifier[0].uncapitalize()}${pascalCase(identifier.slice(1))}`;
}


export function getPascalIdentifier(name: string): string {
  return pascalCase(fixLeadingNumber(deconstruct(name)));
}

export function escapeString(text: string | undefined): string {
  if (text) {
    const q = JSON.stringify(text);
    return q.substr(1, q.length - 2);
  }
  return '';
}

/** emits c# to get the name of a property - uses nameof when it can, and uses a literal when it's an array value. */
export function nameof(text: string): string {
  if (text.indexOf('[') > -1) {
    return `$"${text.replace(/\[(.*)\]/, '[{$1}]')}"`;
  }
  return `nameof(${text})`;
}


export function* getRegions(source: string, prefix: string = '#', postfix: string = '') {
  source = source.replace(/\r?\n|\r/g, '«');

  const rx = new RegExp(`(.*?)«?(\\s*${prefix}\\s*region\\s*(.*?)\\s*${postfix})\\s*«(.*?)«(\\s*${prefix}\\s*endregion\\s*${postfix})\\s*?«`, 'g');
  let match;
  let finalPosition = 0;
  /* eslint-disable */
  while (match = rx.exec(source)) {
    if (match[1]) {
      // we have text before this region.
      yield {
        name: '',
        start: '',
        content: match[1].replace(/«/g, '\n'),
        end: ''
      };
    }

    // this region
    yield {
      name: match[3],
      start: match[2],
      content: match[4].replace(/«/g, '\n'),
      end: match[5]
    };
    finalPosition = rx.lastIndex;
  }

  if (finalPosition < source.length) {
    // we have text after the last region.
    yield {
      name: '',
      start: '',
      content: source.substring(finalPosition).replace(/«/g, '\n'),
      end: '',
    };
  }
}

export function setRegion(source: string, region: string, content: TextPossibilities, prepend = true, prefix: string = '#', postfix: string = '') {
  const result = new Array<string>();
  const ct = new Text(content).text.replace(/\r?\n|\r/g, '«').replace(/^«*/, '').replace(/«*$/, '');
  let found = false;
  for (const each of getRegions(source, prefix, postfix)) {
    if (each.name === region) {
      // found the region, replace it.
      // (this also makes sure that we only have one region by that name when replacing/deleting)
      if (!found && ct) {
        // well, only if it has content, otherwise, we're deleting it.
        result.push(each.start, ct, each.end, '«');
        found = true;
      }
    }
    else {
      result.push(each.start, each.content, each.end, '«');
    }
  }
  if (!found) {
    if (prepend) {
      result.splice(0, 0, `${prefix} region ${region} ${postfix}`, ct, `${prefix} endregion ${postfix}«`);
    } else {
      result.push(`${prefix} region ${region} ${postfix}`, ct, `${prefix} endregion ${postfix}«`);
    }
  }
  return result.join('«').replace(/\r?\n|\r/g, '«').replace(/^«*/, '').replace(/«*$/, '').replace(/«««*/g, '««').replace(/«/g, '\n');
}

// Note: Where is this used?
export function _setRegion(source: string, region: string, content: TextPossibilities, prepend = true, prefix: string = '#', postfix: string = '') {
  const ct = new Text(content).text.replace(/\r?\n|\r/g, '«').replace(/^«*/, '').replace(/«*$/, '');

  source = source.replace(/\r?\n|\r/g, '«');

  const rx = new RegExp(`«(\\s*${prefix}\\s*region\\s*${region}\\s*${postfix})\\s*«.*?(«\\s*${prefix}\\s*endregion\\s*${postfix}«?)`, 'g');
  if (rx.test(source)) {
    if (ct.length > 0) {
      source = source.replace(rx, `«$1«${ct}$2`);
    } else {
      source = source.replace(rx, '');
    }
  } else {
    if (ct.length > 0) {
      const text = `«${prefix} region ${region} ${postfix}«${ct}«${prefix} endregion ${postfix}«`;
      source = prepend ? text + source : source + text;
    }
  }
  source = source.replace(/«««*/g, '««').replace(/«/g, '\n');
  return source;
}

export function selectName(nameOptions: Array<string>, reservedNames: Set<string>) {
  // we're here because the original name is in conflict.
  // so we start with the alternatives  (skip the 0th!) NOT
  for (const each of nameOptions) {
    if (!reservedNames.has(each)) {
      reservedNames.add(each);
      return each;
    }
  }

  // hmm, none of the names were suitable. 
  // use the first one, and tack on a number until we have a free value
  let i = 1;
  do {
    const name = `${nameOptions[0]}${i}`;
    if (!reservedNames.has(name)) {
      reservedNames.add(name);
      return name;
    }

    i++;
  } while (i < 100);

  // after an unreasonalbe search, return something invalid
  return `InvalidPropertyName${nameOptions[0]}`;
}

