import chalk from "chalk";

function addStyle(style: string, text: string): string {
  return `▌PUSH:${style}▐${text}▌POP▐`;
}
function compileStyledText(text: string): string {
  const styleStack = ["(x => x)"];
  let result = "";
  let consumedUpTo = 0;
  const appendPart = (end: number) => {
    const CHALK = chalk;
    result += eval(styleStack[styleStack.length - 1])(text.slice(consumedUpTo, end));
    consumedUpTo = end;
  };

  const commandRegex = /▌(.+?)▐/g;
  let i: RegExpExecArray;
  // eslint-disable-next-line no-cond-assign
  while ((i = commandRegex.exec(text))) {
    const startIndex = i.index;
    const length = i[0].length;
    const command = i[1].split(":");

    // append up to here with current style
    appendPart(startIndex);

    // process command
    consumedUpTo += length;
    switch (command[0]) {
      case "PUSH":
        styleStack.push("CHALK." + command[1]);
        break;
      case "POP":
        styleStack.pop();
        break;
    }
  }
  appendPart(text.length);
  return result;
}

export function color(text: string): string {
  return compileStyledText(
    text
      .replace(/\*\*(.*?)\*\*/gm, addStyle("bold", "$1"))
      .replace(/(\[.*?s\])/gm, addStyle("yellow.bold", "$1"))
      .replace(/^# (.*)/gm, addStyle("greenBright", "$1"))
      .replace(/^## (.*)/gm, addStyle("green", "$1"))
      .replace(/^### (.*)/gm, addStyle("cyanBright", "$1"))
      .replace(/(https?:\/\/\S*)/gm, addStyle("blue.bold.underline", "$1"))
      .replace(/__(.*)__/gm, addStyle("italic", "$1"))
      .replace(/^>(.*)/gm, addStyle("cyan", "  $1"))
      .replace(/^!(.*)/gm, addStyle("red.bold", "  $1"))
      .replace(/^(ERROR) (.*?):(.*)/gm, `\n${addStyle("red.bold", "$1")} ${addStyle("green", "$2")}:$3`)
      .replace(/^(WARNING) (.*?):(.*)/gm, `\n${addStyle("yellow.bold", "$1")} ${addStyle("green", "$2")}:$3`)
      .replace(
        /^(\s* - \w*:\/\/\S*):(\d*):(\d*) (.*)/gm,
        `${addStyle("cyan", "$1")}:${addStyle("cyan.bold", "$2")}:${addStyle("cyan.bold", "$3")} $4`,
      )
      .replace(/`(.+?)`/gm, addStyle("gray", "$1"))
      .replace(/"(.*?)"/gm, addStyle("gray", '"$1"'))
      .replace(/'(.*?)'/gm, addStyle("gray", "'$1'")),
  );
}
