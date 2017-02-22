import * as marked from 'marked'
import * as chalk from 'chalk'
import * as markedTerminal from 'marked-terminal'
import { argv as cli } from 'yargs'
import * as moment from 'moment';

marked.setOptions({
  renderer: new markedTerminal({
    heading: chalk.green.bold,
    firstHeading: chalk.green.bold,
    showSectionPrefix: false,
    strong: chalk.bold.cyan,
    em: chalk.cyan,
    blockquote: chalk.yellow,
    tab: 2
  })
})

export class Console {
  private static quiet: boolean = cli['-quiet'];
  private static debug: boolean = cli['-debug'];
  private static verbose: boolean = cli['-verbose'];

  public static Log(text: string) {
    if (!this.quiet) {
      console.log(marked(`${text}`.trim()).trim());
    }
  }

  private static get Timestamp(): string {
    const m = new Date();
    return chalk.red(`${chalk.gray(m.getHours())}:${chalk.gray(m.getMinutes())}:${chalk.gray(m.getSeconds())}`);
  }

  public static Debug(text: string) {
    if (this.debug) {
      console.log(chalk.bold.yellow(`[${this.Timestamp}] `) + marked(`${text}`.trim()).trim());
    }
  }

  public static Verbose(text: string) {
    if (this.verbose) {
      console.log(chalk.bold.magenta(`[${this.Timestamp}] `) + marked(`${text}`.trim()).trim());
    }
  }

  public static Error(text: string) {
    console.error(chalk.bold.red(`${text}`.trim()).trim());
  }

  public static Exit(reason: string) {
    this.Error(reason || "Unknown Error");
    process.exit(1);
  }
}