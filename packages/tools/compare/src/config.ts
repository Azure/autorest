// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import fs from "fs";
import * as yaml from "js-yaml";
import { AutoRestLanguage } from "./runner";

/**
 * Defines configuration for a set of specs with a root path.
 */
export interface SpecConfiguration {
  /**
   * The root path from which the following spec paths can be found.  If this is
   * a relative path it will be resolved relative to the path where the
   * configuration file was found.
   */
  specRootPath: string;

  /**
   * The array of relative spec paths to be generated for each language.
   */
  specPaths: string[];
}

export type UseExistingOutput = "none" | "old" | "all";

/**
 * Defines configuration for runs of a particular language generator.
 */
export interface LanguageConfiguration {
  /**
   * The name of the language of the generated code.
   */
  language: AutoRestLanguage;

  /**
   * The base output path for the output of this language.  If this is a relative path
   * it will be resolved relative to the path where the configuration file was found.
   */
  outputPath: string;

  /**
   * The array of arguments passed through to AutoRest for the baseline
   * (old) generation run.
   */
  oldArgs: string[];

  /**
   * The array of arguments passed through to AutoRest for the new generation
   * run.
   */
  newArgs: string[];

  /**
   * The array of spec names that will be excluded for this language.  Any items
   * in this array will be excluded from every SpecConfiguration in the
   * RunConfiguration.
   */
  excludeSpecs?: string[];

  /**
   * Determines whether existing output for the baseline should be used.
   * Defaults to "none" which forces old and new output to be regenerated.
   * "all" will cause existing output to be used for old and new runs, "old"
   * reuse the existing old (baseline) output.
   */
  useExistingOutput?: UseExistingOutput;
}

/**
 * Defines configuration for set of languages and specs where an operation
 * (comparison, baseline generation, etc) will be run.
 */
export interface RunConfiguration {
  debug?: boolean;
  specs: SpecConfiguration[];
  languages: LanguageConfiguration[];
}

/**
 * Loads a RunConfiguration object from the YAML file at configPath.
 */
export function loadConfiguration(configPath: string): RunConfiguration | undefined {
  try {
    return yaml.load(fs.readFileSync(configPath, "utf8")) as RunConfiguration;
  } catch (e) {
    console.error(e);
  }
}
