import { execFile, ExecFileException } from "child_process";
import { join } from "path";

const root = join(__dirname, "..");
const coreRoot = join(root, "../../extensions/core");
const cliEntrypoint = join(root, "./entrypoints/app.js");

interface AutorestResult {
  stderr: string;
  stdout: string;
  exitCode: number;
  error?: ExecFileException;
}
async function runAutorest(args: string[]): Promise<AutorestResult> {
  return new Promise((resolve, reject) => {
    execFile("node", [cliEntrypoint, `--version=${coreRoot}`, ...args], (error, stdout, stderr) => {
      resolve({ stdout, stderr, exitCode: error?.code ?? 0, error: error === null ? undefined : error });
    });
  });
}

describe("Failures", () => {
  it("returns zero exit code on success", async () => {
    const { exitCode, stdout, stderr } = await runAutorest(["--help"]);
    console.log(stdout, stderr);
    expect(exitCode).toEqual(0);
  });

  it("returns non-zero exit code on failure", async () => {
    const { exitCode } = await runAutorest(["--input-file=doesnotexists.yaml"]);
    expect(exitCode).not.toEqual(0);
  });
});
