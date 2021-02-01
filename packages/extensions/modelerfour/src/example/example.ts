import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";

export class Example {
  codeModel: CodeModel;

  constructor(protected session: Session<CodeModel>) {
    this.codeModel = session.model; // shadow(session.model, filename);
  }

  process() {
    return this.codeModel;
  }
}
