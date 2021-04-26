import chalk from "chalk";
import { CompareMessage, MessageType } from "./comparers";

interface MessageVisual {
  prefix: string;
  color: chalk.ChalkFunction;
  prefixColor: chalk.ChalkFunction;
}

function getMessageVisual(messageType: MessageType): MessageVisual {
  let prefix = "•";
  let color: chalk.ChalkFunction = chalk;
  let prefixColor: chalk.ChalkFunction | undefined;

  switch (messageType) {
    case MessageType.Added:
      prefix = "+";
      color = chalk.green;
      break;
    case MessageType.Removed:
      prefix = "-";
      color = chalk.red;
      break;
    case MessageType.Outline:
      color = chalk.underline.whiteBright;
      prefixColor = chalk.whiteBright;
      break;
    case MessageType.Plain:
      prefix = " ";
      color = chalk.whiteBright;
      break;
    case MessageType.Changed:
      prefix = "~";
      color = chalk.yellowBright;
      break;
    default:
      // Default already handled
      break;
  }

  return {
    prefix,
    color,
    prefixColor: prefixColor || color,
  };
}

/**
 * Prints a CompareMessage and its children in a human-readable way
 */
export function printCompareMessage(compareMessage: CompareMessage, indentLevel = 0): void {
  const { message, type: messageType, children } = compareMessage;
  const messageVisual = getMessageVisual(messageType);
  const messageLines = message.trimRight().split("\n");

  messageLines.forEach((line) => {
    console.log(
      `${"".padEnd(indentLevel * 2)}`,
      messageVisual.prefixColor(messageVisual.prefix),
      messageVisual.color(line),
    );
  });

  if (children) {
    const childIndent = indentLevel + 1;
    children.forEach((child) => {
      printCompareMessage(child, childIndent);
    });
  }
}
