import * as shelljs from 'shelljs';
import { PlatformInformation } from './platform'

class ExecResult {
  exitCode: number;
  stdout: string;
  stderr: string;
}

/* @internal */
export class Utility {

  public static get Id(): string {
    return '3s8ono7s45qsqnn4p82179pp11r9so632q942o52'.replace(/[a-zA-Z]/g, (c: any) => { return String.fromCharCode((c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26); })
  }

  static async exec(cmdline: string, ): Promise<ExecResult> {
    return new Promise<ExecResult>((resolve, reject) => {
      shelljs.exec(cmdline, { async: true, silent: true }, (code, stdout, stderr) => {
        resolve({
          exitCode: code,
          stdout: stdout,
          stderr: stderr
        });
      });
    });
  }

  static async PlatformInformation(): Promise<PlatformInformation> {
    return PlatformInformation.GetCurrent();
  }
}