import { readFileSync } from "fs";
import { tmpdir } from "os";
import { join, resolve } from "path";
import { isFile, writeFile } from "@azure-tools/async-io";
import { execute } from "./exec-cmd";
import { DEFAULT_NPM_REGISTRY } from "./npm";
import {
  ensurePackageJsonExists,
  InstallOptions,
  PackageInstallationResult,
  PackageManager,
  PackageManagerLogEntry,
  PackageManagerProgress,
} from "./package-manager";

let _cli: string | undefined;
const getPathToYarnCli = async () => {
  const nodeModulesYarn = resolve(`${__dirname}/../node_modules/yarn/lib/cli.js`);
  if (await isFile(nodeModulesYarn)) {
    _cli = nodeModulesYarn;
    return _cli;
  }

  const fname = resolve(`${__dirname}/../yarn/cli.js`);
  if (await isFile(fname)) {
    _cli = fname;
  } else {
    // otherwise, we might be in a 'static-linked' library and
    // we should try to load it and put a copy in $tmp somewhere.
    _cli = join(tmpdir(), "yarn-cli.js");

    // did we copy it already?
    if (await isFile(_cli)) {
      return _cli;
    }
    // no, let's copy it now.
    await writeFile(_cli, readFileSync(fname));
  }
  return _cli;
};

export class Yarn implements PackageManager {
  public constructor(private pathToYarnCli: string | undefined = undefined) {}

  public async install(
    directory: string,
    packages: string[],
    options?: InstallOptions,
    reportProgress?: (progress: PackageManagerProgress) => void,
  ): Promise<PackageInstallationResult> {
    await ensurePackageJsonExists(directory);

    let total = 1;
    const logs: PackageManagerLogEntry[] = [];
    const handleYarnEvent = (event: YarnEvent) => {
      switch (event.type) {
        case "progressStart":
          if (event.data.total !== 0) {
            reportProgress?.({ current: 0, total, id: event.data.id });
            total = event.data.total;
          }
          break;
        case "progressFinish":
          reportProgress?.({ current: 100, total, id: event.data.id });
          break;
        case "progressTick":
          reportProgress?.({ current: Math.min(event.data.current, total), total, id: event.data.id });
          break;
        case "error":
        case "info":
        case "warning":
          logs.push({ severity: event.type, message: event.data });
          break;
        case "step":
          logs.push({ severity: "info", message: ` Step: ${event.data.message}` });
          break;
      }
    };
    const output = await this.execYarn(
      directory,
      ["add", "--global-folder", directory.replace(/\\/g, "/"), ...(options?.force ? ["--force"] : []), ...packages],
      handleYarnEvent,
    );
    if (output.error) {
      return {
        success: false,
        error: {
          message: `Failed to install package '${packages}' -- ${output.error}`,
          logs,
        },
      };
    } else {
      return { success: true };
    }
  }

  public async clean(directory: string): Promise<void> {
    await this.execYarn(directory, ["cache", "clean", "--force"]);
  }

  public async execYarn(cwd: string, args: string[], onYarnEvent?: (event: YarnEvent) => void) {
    const procArgs = [
      this.pathToYarnCli ?? (await getPathToYarnCli()),
      "--no-node-version-check",
      "--no-lockfile",
      "--json",
      "--registry",
      process.env.autorest_registry || DEFAULT_NPM_REGISTRY,
      ...args,
    ];

    const newEnv = {
      ...process.env,
      YARN_IGNORE_PATH: "1", // Prevent yarn from using a different version if configured in ~/.yarnrc
    };

    const handleYarnLog = (buffer: Buffer) => {
      const str = buffer.toString();
      for (const line of str.split(/\r?\n/).filter((x) => x !== "")) {
        try {
          const data = JSON.parse(line);
          onYarnEvent?.(data);
        } catch (e) {
          // NOOP
        }
      }
    };
    return await execute(process.execPath, procArgs, {
      cwd,
      env: newEnv,
      onStdOutData: handleYarnLog,
      onStdErrData: handleYarnLog,
    });
  }
}

type YarnEvent = YarnProgressTick | YarnProgressStart | YarnProgressFinish | YarnStep | YarnLog;

interface YarnProgressTick {
  type: "progressTick";
  data: { id: number; current: number };
}

interface YarnProgressStart {
  type: "progressStart";
  data: { id: number; total: number };
}
interface YarnProgressFinish {
  type: "progressFinish";
  data: { id: number };
}

interface YarnStep {
  type: "step";
  data: { message: string; current: number; total: number };
}
interface YarnLog {
  type: "info" | "warning" | "error";
  data: string;
}
