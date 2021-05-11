import { CodeModel, Schema } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { values, Dictionary } from "@azure-tools/linq";
import { groupBy, pickBy } from "lodash";
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
          `Duplicate Operation '${group.language.default.name}' > '${dupe}' detected. Using the following paths:\n${paths}`,
          ["DuplicateOperation"],
        );
      }
    }
  }

  checkSchemas() {
    const allSchemas = values(<Dictionary<Array<Schema>>>(<any>this.codeModel.schemas))
      .selectMany((schemas) => (Array.isArray(schemas) ? values(schemas) : []))
      .toArray();

    for (const each of values(allSchemas).where((each) => !each.language.default.name)) {
      this.session.warning(`Schema Missing Name '${JSON.stringify(each)}'.`, []);
    }

    const types = values(<Array<Schema>>this.codeModel.schemas.objects)
      .concat(values(this.codeModel.schemas.groups))
      .concat(values(this.codeModel.schemas.choices))
      .concat(values(this.codeModel.schemas.sealedChoices))
      .toArray();
    for (const dupe of values(types).duplicates((each) => each.language.default.name)) {
      this.session.error(`Duplicate object schemas with '${dupe.language.default.name}' name  detected.`, []);
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
