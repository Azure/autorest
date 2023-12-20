import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";

let _session: Session<CodeModel>;
let _armCommonTypeVersion: string;

export function setSession(session: Session<CodeModel>): void {
  _session = session;
}

export function getSession(): Session<CodeModel> {
  return _session;
}

export function setArmCommonTypeVersion(version: string): void {
  _armCommonTypeVersion = version;
}

export function getArmCommonTypeVersion(): string {
  return _armCommonTypeVersion;
}
