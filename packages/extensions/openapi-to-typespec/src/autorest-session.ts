import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";

let _session: Session<CodeModel>;
let _armCommonTypeVersion: ArmCommonTypeVersion | undefined;
let _userSetArmCommonTypeVersion: string;

const commonTypeModels: string[] = [];

export function setSession(session: Session<CodeModel>): void {
  _session = session;
}

export function getSession(): Session<CodeModel> {
  return _session;
}

export function setArmCommonTypeVersion(version: string): void {
  if (_userSetArmCommonTypeVersion === undefined) {
    _userSetArmCommonTypeVersion = version;
  }
}

export function setArmCommonTypeModel(model: string): void {
  if (!commonTypeModels.includes(model)) {
    commonTypeModels.push(model);
  }
}

export function isCommonTypeModel(model: string): boolean {
  const lowerCaseModel = model.toLowerCase();
  const lowerCaseCommonTypeModels = commonTypeModels.map((m) => m.toLowerCase());
  return lowerCaseCommonTypeModels.includes(lowerCaseModel);
}

export type ArmCommonTypeVersion = "v3" | "v4" | "v5" | "v6";

export function getArmCommonTypeVersion(): ArmCommonTypeVersion {
  if (!_armCommonTypeVersion) {
    if (["v3", "v4", "v5", "v6"].includes(_userSetArmCommonTypeVersion)) {
      _armCommonTypeVersion = _userSetArmCommonTypeVersion as ArmCommonTypeVersion;
    } else {
      _armCommonTypeVersion = "v3"; // We hardcode the common type version to v3 if it's not set or the value is not valid, otherwise no model can extend a resource model.
    }
  }
  return _armCommonTypeVersion;
}

export function getUserSetArmCommonTypeVersion(): string {
  return _userSetArmCommonTypeVersion;
}
