import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";

let _session: Session<CodeModel>;
let _armCommonTypeVersion: string;
let _userSetArmCommonTypeVersion: string;

export function setSession(session: Session<CodeModel>): void {
  _session = session;
}

export function getSession(): Session<CodeModel> {
  return _session;
}

export function setArmCommonTypeVersion(version: string): void {
  _userSetArmCommonTypeVersion = version;
}

export function getArmCommonTypeVersion(): string {
  if (!_armCommonTypeVersion) {
    if (["v3", "v4", "v5", "v6"].includes(_userSetArmCommonTypeVersion)) {
      _armCommonTypeVersion = _userSetArmCommonTypeVersion;
    } else {
      _armCommonTypeVersion = "v3"; // We hardcode the common type version to v3 if it's not set or the value is not valid, otherwise no model can extend a resource model.
    }
  }
  return _armCommonTypeVersion;
}

export function getUserSetArmCommonTypeVersion(): string {
  return _userSetArmCommonTypeVersion;
}
