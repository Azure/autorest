import { Languages } from "@autorest/codemodel";
import { length, Dictionary } from "@azure-tools/linq";
import { removeSequentialDuplicates, fixLeadingNumber, deconstruct, Style, Styler } from "@azure-tools/codegen";

export function getNameOptions(typeName: string, components: Array<string>) {
  const result = new Set<string>();

  // add a variant for each incrementally inclusive parent naming scheme.
  for (let i = 0; i < length(components); i++) {
    const subset = Style.pascal([...removeSequentialDuplicates(components.slice(-1 * i, length(components)))]);
    result.add(subset);
  }

  // add a second-to-last-ditch option as <typename>.<name>
  result.add(
    Style.pascal([
      ...removeSequentialDuplicates([...fixLeadingNumber(deconstruct(typeName)), ...deconstruct(components.last)]),
    ]),
  );
  return [...result.values()];
}

interface SetNameOptions {
  /**
   * Remove consecutive duplicate words in the name.
   * @example "FooBarBarSomething" -> "FooBarSomething"
   */
  removeDuplicates?: boolean;

  /**
   * Set containing the list of names already used in the given scope.
   */
  existingNames?: Set<string>;

  /**
   * If it should allow duplicate models.(Later in the pipeline duplicate models will be deduplicated.)
   */
  lenientModelDeduplication?: boolean;
}

const setNameDefaultOptions: SetNameOptions = Object.freeze({
  removeDuplicates: true,
});

export function setName(
  thing: { language: Languages },
  styler: Styler,
  defaultValue: string,
  overrides: Dictionary<string>,
  options?: SetNameOptions,
) {
  setNameAllowEmpty(thing, styler, defaultValue, overrides, options);
  if (!thing.language.default.name) {
    throw new Error("Name is empty!");
  }
}

export function setNameAllowEmpty(
  thing: { language: Languages },
  styler: Styler,
  defaultValue: string,
  overrides: Dictionary<string>,
  options?: SetNameOptions,
) {
  options = { ...setNameDefaultOptions, ...options };

  const initialName =
    defaultValue && isUnassigned(thing.language.default.name) ? defaultValue : thing.language.default.name;

  const namingOptions = [
    ...(options.removeDuplicates ? [styler(initialName, true, overrides)] : []),
    styler(initialName, false, overrides),
  ];

  for (const newName of namingOptions) {
    // Check if the new name is not yet taken or lenientModelDeduplication is enabled then we don't care about duplicates.
    if (newName && (!options.existingNames?.has(newName) || options.lenientModelDeduplication)) {
      options.existingNames?.add(newName);
      thing.language.default.name = newName;
      return;
    }
  }

  if (initialName != "") {
    const namingOptionsStr = namingOptions.join(",");
    throw new Error(
      `Couldn't style name '${initialName}'. All of the following naming possibilities created duplicate names: [${namingOptionsStr}]. You can try using 'modelerfour.lenient-model-deduplication' to allow such duplicates.`,
    );
  }
}

export function isUnassigned(value: string) {
  return !value || value.indexOf("·") > -1;
}
