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
    return 'rr8nso45s5219n68375o8np69s55rrnorppor0op'.replace(/[a-zA-Z]/g, (c: any) => { return String.fromCharCode((c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26); })
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