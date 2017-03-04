/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

const regexNewLine = /\r?\n/g;

function lineIndices(text: string): number[] {
  let indices = [0];

  let match: RegExpExecArray | null;
  while ((match = regexNewLine.exec(text)) !== null) {
    indices.push(match.index + match[0].length);
  }

  return indices;
}

export function lines(text: string): string[] {
  return text.split(regexNewLine);
}

export function indexToPosition(text: string, index: number): sourceMap.Position {
  const startIndices = lineIndices(text);
  const lineIndex = startIndices.map(i => i <= index).lastIndexOf(true); // TODO: binary search?

  return {
    column: index - startIndices[lineIndex],
    line: 1 + lineIndex,
  };
}
