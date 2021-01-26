import {
  CodeModel,
  Schema,
  ObjectSchema,
  isObjectSchema,
  SchemaType,
  Property,
  ParameterLocation,
  Operation,
  Parameter,
  VirtualParameter,
  getAllProperties,
  ImplementationLocation,
  DictionarySchema,
} from "@autorest/codemodel";
import { Session } from "@azure-tools/autorest-extension-base";
import { values, items, length, Dictionary, refCount, clone } from "@azure-tools/linq";
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
    for (const dupe of values(this.codeModel.operationGroups)
      .select((each) => each.language.default.name)
      .duplicates()) {
      this.session.error(`Duplicate Operation group '${dupe}' detected .`, []);
    }
  }

  checkOperations() {
    for (const group of this.codeModel.operationGroups) {
      for (const dupe of values(group.operations)
        .select((each) => each.language.default.name)
        .duplicates()) {
        this.session.error(`Duplicate Operation '${dupe}' detected.`, []);
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
