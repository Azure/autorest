import { Languages } from "@autorest/codemodel";
import { length, Dictionary } from "@azure-tools/linq";
import { removeSequentialDuplicates, fixLeadingNumber, deconstruct, Style, Styler } from "@azure-tools/codegen";
import { Session } from "@autorest/extension-base";

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
}

const setNameDefaultOptions: SetNameOptions = Object.freeze({
  removeDuplicates: true,
});

export interface Nameable {
  language: Languages;
}

export function setName(
  thing: Nameable,
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
  thing: Nameable,
  styler: Styler,
  defaultValue: string,
  overrides: Dictionary<string>,
  options?: SetNameOptions,
) {
  options = { ...setNameDefaultOptions, ...options };
  thing.language.default.name = styler(
    defaultValue && isUnassigned(thing.language.default.name) ? defaultValue : thing.language.default.name,
    options.removeDuplicates,
    overrides,
  );
}

export function isUnassigned(value: string) {
  return !value || value.indexOf("·") > -1;
}

export interface ScopeNamerOptions {
  deduplicateNames?: boolean;
  overrides?: Record<string, string>;
}

export interface NamerEntry {
  entity: Nameable;
  styler: Styler;
  initialName: string;
}

export class ScopeNamer {
  private names = new Map<string, NamerEntry[]>();

  public constructor(private session: Session<unknown>, private options: ScopeNamerOptions) {}

  /**
   * Add a nameable entity to be styled and named.
   * @param entity
   * @param styler
   * @param defaultName
   */
  public add(entity: Nameable, styler: Styler, defaultName?: string) {
    const initialName =
      defaultName && isUnassigned(entity.language.default.name) ? defaultName : entity.language.default.name;

    const name = styler(initialName, false, this.options.overrides);
    const list = this.names.get(name);
    const entry = { entity, styler, initialName };
    if (list) {
      list.push(entry);
    } else {
      this.names.set(name, [entry]);
    }
  }

  /**
   * Returns true if the name is already used in this scope.
   * @param name Name to check
   * @returns Boolean
   */
  public isUsed(name: string): boolean {
    return this.names.has(name);
  }

  /**
   * Trigger the renaming process.
   * Will go over all the entity and find best possible names.
   */
  public process() {
    const state = this.processSimplifyNames();
    if (this.options.deduplicateNames) {
      this.deduplicateNames(state);
    }
  }

  private processSimplifyNames(): Map<string, [Nameable, Styler][]> {
    const processedNames = new Map<string, [Nameable, Styler][]>();
    for (const [name, entities] of this.names.entries()) {
      for (const { entity, styler, initialName } of entities) {
        let selectedName = name;
        const noDupName = styler(initialName, true, this.options.overrides);
        if (noDupName !== name) {
          if (!this.names.has(noDupName) && !processedNames.has(noDupName)) {
            selectedName = noDupName;
          }
        }

        entity.language.default.name = selectedName;
        const entries = processedNames.get(selectedName);
        if (entries) {
          entries.push([entity, styler]);
        } else {
          processedNames.set(selectedName, [[entity, styler]]);
        }
      }
    }
    return processedNames;
  }

  private deduplicateNames(names: Map<string, [Nameable, Styler][]>) {
    const entityNames = new Set(names.keys());
    for (const [_, entries] of names.entries()) {
      if (entries.length > 1) {
        for (const [entity, styler] of entries.slice(1)) {
          this.deduplicateSchemaName(entity, styler, entityNames);
        }
      }
    }
  }

  /*
   * This function checks the `schemaNames` set for a proposed name for the
   * given `schema` using the `indexer` to generate the key to the set.  A
   * custom `indexer` would be used when there's a piece of information other
   * than the name itself to determine the uniqueness of the name (like a
   * namespace).
   */
  private deduplicateSchemaName(schema: Nameable, styler: Styler, entityNames: Set<string>): void {
    const schemaName = schema.language.default.name;
    const maxDedupes = 1000;
    if (entityNames.has(schemaName)) {
      for (let i = 1; i <= maxDedupes; i++) {
        const newName = `${schemaName}AutoGenerated${i === 1 ? "" : i}`;
        const styledNewName = styler(newName, false, this.options.overrides);
        if (!entityNames.has(styledNewName)) {
          schema.language.default.name = styledNewName;
          entityNames.add(styledNewName);
          this.session.warning(`Deduplicating schema name: '${schemaName}' -> '${styledNewName}'`, [
            "PreNamer/DeduplicateName",
          ]);
          return;
        }
      }

      this.session.error(
        `Attempted to deduplicate schema name '${schema.language.default.name}' more than ${maxDedupes} times and failed.`,
        ["PreNamer/DeduplicateName"],
      );
    }

    entityNames.add(schemaName);
  }
}
