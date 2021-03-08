import { createSandbox } from "@azure-tools/datastore";
import { flatMap } from "lodash";
import { AutorestConfiguration } from "./autorest-configuration";
import { arrayOf } from "./utils";

const safeEval = createSandbox();

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

/**
 * Returns list of ResolvedDirective matching the given predicate.
 * @param config Configuration containing directives.
 * @param predicate Optional filter condition.
 */
export const resolveDirectives = (
  config: AutorestConfiguration,
  predicate?: (each: ResolvedDirective) => boolean,
): ResolvedDirective[] => {
  // optionally filter by predicate.
  const plainDirectives = arrayOf<Directive>(config["directive"]);

  const declarations = config["declare-directive"] || {};

  const expandDirective = (dir: Directive): Directive[] => {
    const makro = Object.keys(dir).filter((m) => declarations[m])[0];
    if (!makro) {
      return [dir]; // nothing to expand
    }

    // prepare directive
    let parameters: string[] = (<any>dir)[makro];
    if (!Array.isArray(parameters)) {
      parameters = [parameters];
    }
    dir = { ...dir };
    delete (<any>dir)[makro];
    // call makro
    const makroResults: any = flatMap(parameters, (parameter) => {
      const result = safeEval(declarations[makro], { $: parameter, $context: dir });
      return Array.isArray(result) ? result : [result];
    });
    return flatMap(makroResults, (result: any) => expandDirective({ ...result, ...dir }));
  };

  // makro expansion
  if (predicate) {
    return flatMap(plainDirectives, expandDirective)
      .map((each) => new ResolvedDirective(each))
      .filter(predicate);
  }
  return flatMap(plainDirectives, expandDirective).map((each) => new ResolvedDirective(each));
  // return From(plainDirectives).SelectMany(expandDirective).Select(each => new StaticDirectiveView(each)).ToArray();
};
