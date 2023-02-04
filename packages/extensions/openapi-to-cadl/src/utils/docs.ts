import { WithSummary } from "../interfaces";

interface WithDocs {
  doc?: string | string[];
}

export function generateDocs({ doc }: WithDocs): string {
  if (isEmptyDoc(doc)) {
    return ``;
  }

  let docString = Array.isArray(doc) ? doc.join("\n") : doc;
  docString = docString.replace(/\r\n/g, "\n");
  docString = docString.replace(/\\/g, "\\\\");
  docString = docString.replace(/"/g, '\\"');
  docString = lineWrap(docString);

  return `@doc(${docString})`;
}

export function generateSummary({ summary }: WithSummary): string {
  if (isEmptyDoc(summary)) {
    return "";
  }

  return `@summary(${lineWrap(summary)})`;
}

function lineWrap(doc: string) {
  const maxLength = 80;

  if (doc.length <= maxLength && !doc.includes("\n")) {
    return `"${doc}"`;
  }

  const lines: string[] = [`"""`];
  const words = doc.split(" ");
  let line = ``;
  for (const word of words) {
    if (word.length + 1 > maxLength - line.length) {
      // Don't add the leading space
      lines.push(line.substring(0, line.length - 1));

      // Start a new line
      line = `${word} `;
    } else {
      line = `${line}${word} `;
    }
  }
  lines.push(`${line.substring(0, line.length - 1)}`);
  lines.push(`"""`);

  return lines.join("\n");
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
