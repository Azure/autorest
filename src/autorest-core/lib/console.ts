/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as marked from "marked";
import * as chalk from "chalk";

import * as moment from "moment";

const markedTerminal = require("marked-terminal");

marked.setOptions({
  renderer: new markedTerminal({
    heading: chalk.green.bold,
    firstHeading: chalk.green.bold,
    showSectionPrefix: false,
    strong: chalk.bold.blue,
    em: chalk.cyan,
    blockquote: chalk.yellow,
    tab: 2
  })
});

export class Console {
  public static quiet: boolean = false;
  public static debug: boolean = false;
  public static verbose: boolean = false;

  public static Log(text: any) {
    if (!this.quiet) {
      console.log(marked(`${text}`.trim()).trim());
    }
  }

  private static get Timestamp(): string {
    const m = new Date();
    const hh = `${m.getHours()}`;
    const mm = `${m.getMinutes()}`;
    const ss = `${m.getSeconds()}`;

    return chalk.red(`${chalk.gray(hh)}:${chalk.gray(mm)}:${chalk.gray(ss)}`);
  }

  public static Debug(text: any) {
    if (this.debug) {
      console.log(chalk.bold.yellow(`[${this.Timestamp}] `) + marked(`${text}`.trim()).trim());
    }
  }

  public static Verbose(text: any) {
    if (this.verbose) {
      console.log(chalk.bold.magenta(`[${this.Timestamp}] `) + marked(`${text}`.trim()).trim());
    }
  }

  public static Error(text: any) {
    console.error(chalk.bold.red(`${text}`.trim()).trim());
  }

  public static Exit(reason: any) {
    this.Error(reason || "Unknown Error");
    process.exit(1);
  }
}