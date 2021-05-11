import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { flatMap, groupBy, pickBy } from "lodash";
import { ModelerFourOptions } from "../modeler/modelerfour-options";

export class Checker {
  codeModel: CodeModel;
  options: ModelerFourOptions = {};

  constructor(protected session: Session<CodeModel>) {
    this.codeModel = session.model; // shadow(session.model, filename);
  }

  async init() {
    // get our configuration for this run.
    this.options = await this.session.getValue("modelerfour", {});
    return this;
  }

  checkOperationGroups() {
    const duplicates = findDuplicates(this.codeModel.operationGroups, (x) => x.language.default.name);
    for (const [dupe] of Object.entries(duplicates)) {
      this.session.error(`Duplicate Operation group '${dupe}' detected .`, ["DuplicateOperationGroup"]);
    }
  }

  checkOperations() {
    for (const group of this.codeModel.operationGroups) {
      const duplicates = findDuplicates(group.operations, (x) => x.language.default.name);
      for (const [dupe, operations] of Object.entries(duplicates)) {
        const paths = operations
          .map((x) => x.requests?.[0].protocol.http?.path)
          .map((x) => `  - ${x}`)
          .join("\n");
        this.session.error(
          `Duplicate Operation '${group.language.default.name}' > '${dupe}' detected(This is most likely due to 2 operation using the same 'operationId' or 'tags'). Duplicates have those paths:\n${paths}`,
          ["DuplicateOperation"],
        );
      }
    }
  }

  checkSchemas() {
    const allSchemas = flatMap(Object.values(this.codeModel.schemas), (schemas) =>
      Array.isArray(schemas) ? schemas : [],
    );

    for (const name of allSchemas.filter((x) => !x.language.default.name)) {
      this.session.warning(`Schema Missing Name '${JSON.stringify(name)}'.`, []);
    }

    const types = [
      ...(this.codeModel.schemas.objects ?? []),
      ...(this.codeModel.schemas.groups ?? []),
      ...(this.codeModel.schemas.choices ?? []),
      ...(this.codeModel.schemas.sealedChoices ?? []),
    ];

    const duplicates = findDuplicates(types, (each) => each.language.default.name);
    for (const name of Object.keys(duplicates)) {
      this.session.error(`Duplicate object schemas with '${name}' name  detected.`, []);
    }

    /* for (const dupe of values(this.codeModel.schemas.numbers).select(each => each.type).duplicates()) {
      this.session.error(`Duplicate '${dupe}' detected.`, []);
    }; */
  }

  process() {
    if (this.options["additional-checks"] !== false) {
      this.checkOperationGroups();

      this.checkOperations();

      this.checkSchemas();
    }
    return this.codeModel;
  }
}

function findDuplicates<T>(items: T[], groupByFn: (item: T) => string): Record<string, T[]> {
  const grouped = groupBy(items, groupByFn);
  return pickBy(grouped, (x) => x.length > 1);
}
