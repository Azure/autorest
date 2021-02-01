/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Initializer } from "./initializer";
import { EOL, setRegion, getRegions } from "./text-manipulation";

export type fIterable<T> = Iterable<T> | (() => Iterable<T>);

export interface IText {
  text: string;
}

export interface ITextEdit {
  edit: (s: string) => string;
}

export type TextOrString = IText | string | ITextEdit;
export type Texts = TextOrString | fIterable<TextOrString>;
export type Texts2 = Texts | fIterable<Texts>;
export type Texts3 = Texts2 | fIterable<Texts2>;
export type Texts4 = Texts3 | fIterable<Texts3>;
export type Texts5 = Texts4 | fIterable<Texts4>;
export type TextPossibilities = Texts5 | Text;

export function isText(object: TextPossibilities): object is IText {
  return (<any>object).text ? true : false;
}

export function isTextEdit(object: TextPossibilities): object is ITextEdit {
  return (<any>object).edit ? true : false;
}

export class Text extends Initializer implements IText {
  protected content = new Array<IText | ITextEdit | string>();

  constructor(content?: TextPossibilities, objectIntializer?: Partial<Text>) {
    super();
    if (content) {
      this.add(content);
    }
    this.apply(objectIntializer);
  }

  public get count(): number {
    return this.content.length;
  }

  public add(text: TextPossibilities): IText {
    if (typeof text === "string") {
      this.content.push(text);
      return this;
    }
    if (text instanceof Text) {
      this.content.push(text);
      return this;
    }
    if (isText(text) || isTextEdit(text)) {
      this.content.push(text);
      return this;
    }
    if (typeof text === "function") {
      return this.add(text());
    }
    for (const each of text) {
      this.add(each);
    }
    return this;
  }

  get text(): string {
    let output = "";
    for (const each of this.content) {
      if (typeof each === "string") {
        output = output + EOL + each;
        continue;
      }
      if (isTextEdit(each)) {
        output = each.edit(output) + EOL;
        continue;
      }
      output = output + EOL + each.text;
    }
    return output;
  }

  public toString = (): string => {
    return this.text;
  };

  trim() {
    this.add({ edit: (s: string) => s.trim() });
  }
}

export class TextWithRegions extends Text {
  private prefix: string;
  private postfix: string;

  constructor(content?: TextPossibilities, objectIntializer?: Partial<TextWithRegions>, prefix = "#", postfix = "") {
    super(content);
    this.apply(objectIntializer);
    this.prefix = prefix;
    this.postfix = postfix;
  }

  removeRegion(region: string) {
    this.add({ edit: (s: string) => setRegion(s, region, "", undefined, this.prefix, this.postfix) });
  }

  setRegion(region: string, content: TextPossibilities, prepend = true) {
    this.add({ edit: (s: string) => setRegion(s, region, content, prepend, this.prefix, this.postfix) });
  }

  has(name: string) {
    for (const each of getRegions(this.text, this.prefix, this.postfix)) {
      if (each.name === name) {
        return true;
      }
    }
    return false;
  }

  append(name: string, content: TextPossibilities) {
    this.add({ edit: (s: string) => setRegion(s, name, content, false, this.prefix, this.postfix) });
  }
  prepend(name: string, content: TextPossibilities) {
    this.add({ edit: (s: string) => setRegion(s, name, content, true, this.prefix, this.postfix) });
  }

  get regions() {
    if (!this.text.trim()) {
      return [];
    }
    return [...getRegions(this.text, this.prefix, this.postfix)];
  }
}
