import { createSandbox, JsonPath } from "@azure-tools/datastore";
import { AutorestContext } from "../../autorest-core";
import { Channel } from "../../message";

const safeEval = createSandbox();

export interface TransformOptions {
  /**
   * Current configuration.
   */
  config: AutorestContext;

  /**
   * Value to transform.
   */
  value: unknown;

  /**
   * Json path to the object.
   */
  path: JsonPath;

  /**
   * Value parent.
   */
  parent?: unknown;

  /**
   * Whole document.
   */
  doc: unknown;

  documentPath: string;
}

export interface TestOptions {
  /**
   * Value to transform.
   */
  value: unknown;

  /**
   * Whole document.
   */
  doc: unknown;

  /**
   * Json path to the object.
   */
  path: JsonPath;
}

interface TransformEvalContext {
  /**
   * Value to transform.
   */
  $: unknown;

  /**
   * Json path to the object.
   */
  $path: JsonPath;

  /**
   * Whole document.
   */
  $doc: unknown;

  /**
   * Path to the document
   */
  $documentPath: string;

  /**
   * Set of usable functions
   */
  $lib: Lib;

  /**
   * Value parent.
   */
  $parent?: unknown;
}

interface Lib {
  debug: (message: string) => void;
  verbose: (message: string) => void;
  log: (message: string) => void;
  config: AutorestContext;
}

/**
 * Evaluate the transform code of a directive.
 * @param transformCode Code to transform.
 * @returns the modified value.
 */
export const evalDirectiveTransform = (transformCode: string, context: TransformOptions): unknown => {
  const { config } = context;

  const evalContext: TransformEvalContext = {
    $: context.value,
    $doc: context.doc,
    $path: context.path,
    $documentPath: context.documentPath,
    $parent: context.parent,
    $lib: {
      debug: (text: string) => config.Message({ Channel: Channel.Debug, Text: text }),
      verbose: (text: string) => config.Message({ Channel: Channel.Debug, Text: text }),
      // eslint-disable-next-line no-console
      log: (text: string) => console.error(text),
      config,
    },
  };

  return safeEval<unknown>(`(() => { { ${transformCode} }; return $; })()`, evalContext);
};

export const evalDirectiveTest = (testCode: string, options: TestOptions): unknown[] => {
  const context = {
    $: options.value,
    $doc: options.doc,
    $path: options.path,
  };
  return [
    ...safeEval<any>(
      `(function* () { ${testCode.indexOf("yield") === -1 ? `yield (${testCode}\n)` : `${testCode}\n`} })()`,
      context,
    ),
  ];
};
