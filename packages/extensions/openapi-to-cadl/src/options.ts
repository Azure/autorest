import { CodeModel } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { getSession } from "./autorest-session";
import { CadlOptions } from "./interfaces";

export let options: CadlOptions;

export function getOptions(): CadlOptions {
  if (!options) {
    const session = getSession();
    options = {
      isAzureSpec: getIsAzureSpec(session),
      namespace: getNamespace(session),
      guessResourceKey: getGuessResourceKey(session),
    };
  }

  return options;
}

export function getGuessResourceKey(session: Session<CodeModel>) {
  const shouldGuess = session.configuration["guessResourceKey"] ?? false;
  return shouldGuess !== false;
}

export function getIsAzureSpec(session: Session<CodeModel>) {
  return session.configuration["isAzureSpec"] !== false;
}

export function getNamespace(session: Session<CodeModel>) {
  return session.configuration["namespace"];
}
