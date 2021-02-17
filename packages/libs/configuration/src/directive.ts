import { arrayOf } from "./utils";

export interface Directive {
  "from"?: string[] | string;
  "where"?: string[] | string;
  "reason"?: string;

  // one of:
  "suppress"?: string[] | string;
  "set"?: string[] | string;
  "transform"?: string[] | string;
  "text-transform"?: string[] | string;
  "test"?: string[] | string;
}

export class ResolvedDirective {
  from: string[];
  where: string[];
  reason?: string;
  suppress: string[];
  transform: string[];
  test: string[];

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
