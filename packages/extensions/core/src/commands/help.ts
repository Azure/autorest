/* eslint-disable no-console */
import { color } from "@autorest/common";
import { parseYAML } from "@azure-tools/yaml";
import { Help } from "../help";
import { Artifact } from "../lib/artifact";

export function printAutorestHelp(artifacts: Artifact[]) {
  printHelpHeader();
  // - sort artifacts by name (then content, just for stability)
  const helpArtifacts = artifacts.sort((a, b) =>
    a.uri === b.uri ? (a.content > b.content ? 1 : -1) : a.uri > b.uri ? 1 : -1,
  );
  // - format and print
  for (const helpArtifact of helpArtifacts) {
    const { result: help, errors } = parseYAML<Help>(helpArtifact.content);
    if (errors.length > 0) {
      for (const { message, position } of errors) {
        console.error(color(`!Parsing error at **${helpArtifact.uri}**:__${position}: ${message}__`));
      }
    }
    if (!help) {
      continue;
    }
    const activatedBySuffix = help.activationScope ? ` (activated by --${help.activationScope})` : "";
    console.log("");
    console.log(color(`### ${help.categoryFriendlyName}${activatedBySuffix}`));
    if (help.description) {
      console.log(color(help.description));
    }
    console.log("");
    for (const settingHelp of help.settings) {
      const keyPart = `--${settingHelp.key}`;
      const typePart = settingHelp.type ? `=<${settingHelp.type}>` : " "; // `[=<boolean>]`;
      const settingPart = `${keyPart}\`${typePart}\``;
      // if (!settingHelp.required) {
      //   settingPart = `[${settingPart}]`;
      // }
      console.log(color(`  ${settingPart.padEnd(30)}  **${settingHelp.description}**`));
    }
  }
}

function printHelpHeader() {
  console.log(
    [
      "",
      "",
      color("**Usage**: autorest `[configuration-file.md] with [...options]`"),
      "",
      color("  See: https://aka.ms/autorest/cli for additional documentation"),
    ].join("\n"),
  );
}
