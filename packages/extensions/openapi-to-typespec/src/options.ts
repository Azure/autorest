import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { getSession } from "./autorest-session";
import { TypespecOptions } from "./interfaces";

export let options: TypespecOptions;

export function getOptions(): TypespecOptions {
  if (!options) {
    updateOptions();
  }

  return options;
}

export function updateOptions() {
  const session = getSession();
  options = {
    isAzureSpec: getIsAzureSpec(session),
    namespace: getNamespace(session),
    guessResourceKey: getGuessResourceKey(session),
    isArm: getIsArm(session),
    isFullCompatible: getIsFullCompatible(session),
  };
}

export function getGuessResourceKey(session: Session<CodeModel>) {
  const shouldGuess = session.configuration["guessResourceKey"] ?? false;
  return shouldGuess !== false;
}

export function getIsArm(session: Session<CodeModel>) {
  const isArm = session.configuration["isArm"] ?? false;
  return isArm !== false;
}

export function getIsAzureSpec(session: Session<CodeModel>) {
  return session.configuration["isAzureSpec"] !== false;
}

export function getNamespace(session: Session<CodeModel>) {
  return session.configuration["namespace"];
}

export function getIsFullCompatible(session: Session<CodeModel>) {
  const isFullCompatible = session.configuration["isFullCompatible"] ?? false;
  return isFullCompatible !== false;
}
