/* eslint-disable no-console */
import { color } from "@autorest/common";
import {
  AUTOREST_CONFIGURATION_DEFINITION_FOR_HELP,
  ConfigurationPropertyType,
  ConfigurationSchemaDefinition,
  RootConfigurationProperty,
} from "@autorest/configuration";
import { parseYAML } from "@azure-tools/yaml";
import { Artifact } from "../lib/artifact";

export function printAutorestHelp(artifacts: Artifact[]) {
  printHelpHeader();
  printHelpForConfigurationSchema(AUTOREST_CONFIGURATION_DEFINITION_FOR_HELP);

  printHelpFromHelpContent(artifacts);
}

function printHelpHeader() {
  console.log(
    [
      "",
      "",
      color("**Usage**: `autorest [config-file.{md|json|yaml}] [...additional options]`"),
      "",
      color("  See: https://aka.ms/autorest/cli for additional documentation"),
    ].join("\n"),
  );
}

interface Category {
  name: string;
  description?: string;
  options: Option[];
}

interface Option {
  key: string;
  description: string;
  type: ConfigurationPropertyType;
}

function groupFlagsByCategory(def: ConfigurationSchemaDefinition<any, any>): Category[] {
  const categories = new Map<string, Category>();
  const unknownCategories: Option[] = [];
  for (const [key, { name, description }] of Object.entries(def.categories)) {
    categories.set(key, { name, description, options: [] });
  }

  for (const [key, option] of Object.entries<RootConfigurationProperty<any>>(def.schema)) {
    const category = categories.get(option.category);
    const options = category === undefined ? unknownCategories : category.options;

    options.push({
      key,
      description: option.description ?? "",
      type: option.type,
    });
  }

  return [...categories.values()];
}

function printHelpForConfigurationSchema(def: ConfigurationSchemaDefinition<any, any>) {
  const categories = groupFlagsByCategory(def);
  let maxKeyAndTypeLength = 0;
  const processed = categories.map((category) => {
    return {
      ...category,
      options: category.options.map((option) => {
        const keyPart = `--${option.key}`;
        const typePart = printConfiguarationPropertyType(option.type);
        const keyAndType = `${keyPart}\`${typePart}\``;
        if (keyAndType.length > maxKeyAndTypeLength) {
          maxKeyAndTypeLength = keyAndType.length;
        }

        return { keyAndType, description: option.description };
      }),
    };
  });

  for (const category of processed) {
    console.log("");
    console.log(color(`### ${category.name}`));
    if (category.description) {
      console.log(color(category.description));
    }
    for (const option of category.options) {
      console.log(color(`  ${option.keyAndType.padEnd(maxKeyAndTypeLength + 1)}  **${option.description}**`));
    }
  }
}

function printConfiguarationPropertyType(type: ConfigurationPropertyType): string {
  switch (type) {
    case "boolean":
      return " ";
    default:
      return `=<${type}>`;
  }
}

export interface Help {
  categoryFriendlyName: string; // e.g. "Output Verbosity", "C# generator"
  activationScope?: string; // e.g. "csharp"
  description?: string; // inline markdown allowed
  settings: Array<SettingHelp>;
}

export interface SettingHelp {
  required?: boolean; // defaults to "false"
  key: string; // e.g. "namespace"
  type?: string; // not specified => flag; otherwise, please use TypeScript syntax
  description: string; // inline markdown allowed
}

/**
 * Print help defined in an extension `help-content` section in the configuration.
 */
function printHelpFromHelpContent(artifacts: Artifact[]) {
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
