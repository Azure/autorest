import chalk from "chalk";

const NOT_EMPTY_LINE_REGEXP = /^(?!$)/gm;

export function color(text: string): string {
  return text
    .replace(/(\[.*?\])/gm, (_, x) => chalk.yellow.bold(x))
    .replace(/\*\*(.*?)\*\*/gm, (_, x) => chalk.bold(x))
    .replace(/^# (.*)/gm, (_, x) => chalk.greenBright(x))
    .replace(/^## (.*)/gm, (_, x) => chalk.green(x))
    .replace(/^### (.*)/gm, (_, x) => chalk.cyanBright(x))
    .replace(/(https?:\/\/\S*)/gm, (_, x) => chalk.blue.bold.underline(x))
    .replace(/_(.*)_/gm, (_, x) => chalk.italic(x))
    .replace(/^>(.*)/gm, (_, x) => chalk.cyan(`  ${x}`))
    .replace(/^!(.*)/gm, (_, x) => chalk.red.bold(`  ${x}`))
    .replace(/```(.*)```/gs, (_, x) => indentAllLines(x, `  ${chalk.gray("|")} `))
    .replace(/`(.+?)`/gm, (_, x) => chalk.gray(x))
    .replace(/(".*?")/gm, (_, x) => chalk.gray(x))
    .replace(/('.*?')/gm, (_, x) => chalk.gray(x));
}

const indentAllLines = (lines: string, indent: string) => lines.replace(NOT_EMPTY_LINE_REGEXP, indent);
