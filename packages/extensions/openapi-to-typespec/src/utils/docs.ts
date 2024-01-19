import { WithSummary } from "../interfaces";
import { getOptions } from "../options";

interface WithDocs {
  doc?: string | string[];
}

export function generateDocs({ doc }: WithDocs): string {
  if (isEmptyDoc(doc)) {
    return ``;
  }

  const wrapped = lineWrap(doc);

  return `/**\n* ${wrapped.join("\n* ")}\n*/`;
}

export function generateSummary({ summary }: WithSummary): string {
  if (isEmptyDoc(summary)) {
    return "";
  }

  const wrapped = lineWrap(summary);

  if (wrapped.length === 1) {
    return `@summary("${summary}")`;
  }
  return `@summary("""\n${wrapped.join("\n")}\n""")`;
}

function lineWrap(doc: string | string[]): string[] {
  const { isArm } = getOptions();
  const maxLength = isArm ? Number.POSITIVE_INFINITY : 80;

  let docString = Array.isArray(doc) ? doc.join("") : doc;
  docString = docString.replace(/\r\n/g, "\n");
  docString = docString.replace(/\r/g, "\n");

  if (docString.length <= maxLength && !docString.includes("\n")) {
    return [docString];
  }

  const lines: string[] = [];
  const words = docString.split(" ");
  let line = ``;
  for (const word of words) {
    if (word === "\n") {
      lines.push(line.substring(0, line.length - 1));
      line = "";
    } else if (word.length + 1 > maxLength - line.length) {
      lines.push(line.substring(0, line.length - 1));
      line = `${word} `;
    } else {
      line = `${line}${word} `;
    }
  }
  lines.push(`${line.substring(0, line.length - 1)}`);

  return lines;
}

function isEmptyDoc(doc?: string | string[]): doc is undefined {
  if (!doc) {
    return true;
  }

  if (Array.isArray(doc) && !doc.length) {
    return true;
  }

  return false;
}
