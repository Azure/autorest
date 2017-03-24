/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export class Logger {
  private _writer: (message: string) => void;
  private _prefix: string;

  private _indentLevel: number = 0;
  private _indentSize: number = 4;
  private _atLineStart: boolean = false;

  constructor(writer: (message: string) => void, prefix?: string) {
    this._writer = writer;
    this._prefix = prefix;
  }

  private _appendCore(message: string): void {
    if (this._atLineStart) {
      if (this._indentLevel > 0) {
        const indent = " ".repeat(this._indentLevel * this._indentSize);
        this._writer(indent);
      }

      if (this._prefix) {
        this._writer(`[${this._prefix}] `);
      }

      this._atLineStart = false;
    }

    this._writer(message);
  }

  public increaseIndent(): void {
    this._indentLevel += 1;
  }

  public decreaseIndent(): void {
    if (this._indentLevel > 0) {
      this._indentLevel -= 1;
    }
  }

  public append(message?: string): void {
    message = message || "";
    this._appendCore(message);
  }

  public appendLine(message?: string): void {
    message = message || "";
    this._appendCore(message + '\n');
    this._atLineStart = true;
  }
}