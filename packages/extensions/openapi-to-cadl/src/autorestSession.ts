import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";

let _session: Session<CodeModel>;

export function setSession(session: Session<CodeModel>): void {
  _session = session;
}

export function getSession(): Session<CodeModel> {
  return _session;
}
