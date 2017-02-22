/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

function textLineStartIndices(text: string): number[] {
  let indices = [0];

  const regex = /\r?\n/g;
  let match: RegExpExecArray | null;
  while ((match = regex.exec(text)) !== null) {
    indices.push(match.index + match[0].length);
  }

  return indices;
}

export function textIndexToPosition(text: string, index: number): sourceMap.Position {
  const startIndices = textLineStartIndices(text);
  const lineIndex = startIndices.map(i => i <= index).lastIndexOf(true); // TODO: binary search?

  return {
    column: index - startIndices[lineIndex],
    line: 1 + lineIndex,
  };
}
