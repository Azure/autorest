import { CodeModel } from "@azure-tools/codemodel";
import { Session } from "@azure-tools/autorest-extension-base";

export class Example {
  codeModel: CodeModel;

  constructor(protected session: Session<CodeModel>) {
    this.codeModel = session.model; // shadow(session.model, filename);
  }

  process() {
    return this.codeModel;
  }
}
