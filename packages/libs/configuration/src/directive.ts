import { arrayOf } from "./utils";

export interface Directive {
  "from"?: Array<string> | string;
  "where"?: Array<string> | string;
  "reason"?: string;

  // one of:
  "suppress"?: Array<string> | string;
  "set"?: Array<string> | string;
  "transform"?: Array<string> | string;
  "text-transform"?: Array<string> | string;
  "test"?: Array<string> | string;
}

export class ResolvedDirective {
  from: Array<string>;
  where: Array<string>;
  reason?: string;
  suppress: Array<string>;
  transform: Array<string>;
  test: Array<string>;

  constructor(directive: Directive) {
    // copy untyped content over
    Object.assign(this, directive);

    // normalize typed content
    this.from = arrayOf(directive["from"]);
    this.where = arrayOf(directive["where"]);
    this.reason = directive.reason;
    this.suppress = arrayOf(directive["suppress"]);
    this.transform = arrayOf(directive["transform"] || directive["text-transform"]);
    this.test = arrayOf(directive["test"]);
  }
}
