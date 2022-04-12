import { SpawnOptions, ChildProcess, spawn } from "child_process";

interface MoreOptions extends SpawnOptions {
  onCreate?(cp: ChildProcess): void;
  onStdOutData?(chunk: any): void;
  onStdErrData?(chunk: any): void;
}

export interface ExecResult {
  stdout: string;
  stderr: string;

  /**
   * Union of stdout and stderr.
   */
  log: string;
  error: Error | null;
  code: number | null;
}

export const execute = (
  command: string,
  cmdlineargs: Array<string>,
  options: MoreOptions = {},
): Promise<ExecResult> => {
  return new Promise((resolve, reject) => {
    const cp = spawn(command, cmdlineargs, { ...options, stdio: "pipe" });
    if (options.onCreate) {
      options.onCreate(cp);
    }

    options.onStdOutData ? cp.stdout.on("data", options.onStdOutData) : cp;
    options.onStdErrData ? cp.stderr.on("data", options.onStdErrData) : cp;

    let err = "";
    let out = "";
    let all = "";
    cp.stderr.on("data", (chunk) => {
      err += chunk;
      all += chunk;
    });
    cp.stdout.on("data", (chunk) => {
      out += chunk;
      all += chunk;
    });

    cp.on("error", (err) => {
      reject(err);
    });
    cp.on("close", (code, signal) =>
      resolve({
        stdout: out,
        stderr: err,
        log: all,
        error: code ? new Error("Process Failed.") : null,
        code,
      }),
    );
  });
};
