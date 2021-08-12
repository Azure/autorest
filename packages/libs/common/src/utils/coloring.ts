import chalk from "chalk";

const NOT_EMPTY_LINE_REGEXP = /^(?!$)/gm;

export function color(text: string): string {
  return text
    .replace(/\*\*(.*?)\*\*/gm, (_, x) => chalk.bold(x))
    .replace(/(\[.*?s\])/gm, (_, x) => chalk.yellow.bold(x))
    .replace(/^# (.*)/gm, (_, x) => chalk.greenBright(x))
    .replace(/^## (.*)/gm, (_, x) => chalk.green(x))
    .replace(/^### (.*)/gm, (_, x) => chalk.cyanBright(x))
    .replace(/(https?:\/\/\S*)/gm, (_, x) => chalk.blue.bold.underline(x))
    .replace(/_(.*)_/gm, (_, x) => chalk.italic(x))
    .replace(/^>(.*)/gm, (_, x) => chalk.cyan(`  ${x}`))
    .replace(/^!(.*)/gm, (_, x) => chalk.red.bold(`  ${x}`))
    .replace(/^(ERROR) (.*?):(.*)/gm, (_, a, b, c) => `\n${chalk.red.bold(a)} ${chalk.green(b)}:${c}`)
    .replace(/^(WARNING) (.*?):(.*)/gm, (_, a, b, c) => `\n${chalk.yellow.bold(a)} ${chalk.green(b)}:${c}`)
    .replace(
      /^(\s* - \w*:\/\/\S*):(\d*):(\d*) (.*)/gm,
      (_, a, b, c, d) => `${chalk.cyan(a)}:${chalk.cyan.bold(b)}:${chalk.cyan.bold(c)} ${d}`,
    )
    .replace(/```(.*)```/gs, (_, x) => indentAllLines(x, `  ${chalk.gray("|")} `))
    .replace(/`(.+?)`/gm, (_, x) => chalk.gray(x))
    .replace(/(".*?")/gm, (_, x) => chalk.gray(x))
    .replace(/('.*?')/gm, (_, x) => chalk.gray(x));
}

const indentAllLines = (lines: string, indent: string) => lines.replace(NOT_EMPTY_LINE_REGEXP, indent);
