import { MatcherState } from "expect";
import * as fs from "fs";
import SnapshotState from "jest-snapshot/build/State";
import * as path from "path";

declare global {
  namespace jest {
    interface Matchers<R> {
      toMatchRawFileSnapshot(snapshotFile: string): jest.CustomMatcherResult;
    }
  }
}

function getAbsolutePathToSnapshot(testPath: string, snapshotFile: string) {
  return path.isAbsolute(snapshotFile) ? snapshotFile : path.resolve(path.dirname(testPath), snapshotFile);
}

type Context = jest.MatcherUtils &
  MatcherState & {
    snapshotState: SnapshotState;
  };

/**
 * Helper
 */
function toMatchRawFileSnapshot(
  this: Context,
  received: object | Array<object>,
  filename: string,
): jest.CustomMatcherResult {
  if (typeof received !== "string") {
    throw new Error("toMatchRawFileSnapshot is only supported with raw text");
  }

  if (this.isNot) {
    return {
      pass: true, // Will get inverted because of the .not
      message: () => `.${this.utils.BOLD_WEIGHT("not")} cannot be used with snapshot matchers`,
    };
  }

  if (!this.testPath) {
    throw new Error("Unexpected matcher state, testPath is undefined");
  }
  const filepath = getAbsolutePathToSnapshot(this.testPath, filename);
  const content: string = received;
  const updateSnapshot: "none" | "all" | "new" = (this.snapshotState as any)._updateSnapshot;

  const coloredFilename = this.utils.DIM_COLOR(filename);
  const errorColor = this.utils.RECEIVED_COLOR;

  if (updateSnapshot === "none" && !fs.existsSync(filepath)) {
    // We're probably running in CI environment

    this.snapshotState.unmatched++;

    return {
      pass: false,
      message: () =>
        `New output file ${coloredFilename} was ${errorColor("not written")}.\n\n` +
        "The update flag must be explicitly passed to write a new snapshot.\n\n",
    };
  }

  if (fs.existsSync(filepath)) {
    const output = fs.readFileSync(filepath, "utf8").replace(/\r\n/g, "\n");
    // The matcher is being used with `.not`
    if (output === content) {
      this.snapshotState.matched++;
      return { pass: true, message: () => "" };
    } else {
      if (updateSnapshot === "all") {
        fs.mkdirSync(path.dirname(filepath), { recursive: true });
        fs.writeFileSync(filepath, content);

        this.snapshotState.updated++;

        return { pass: true, message: () => "" };
      } else {
        this.snapshotState.unmatched++;

        return {
          pass: false,
          message: () =>
            `Received content ${errorColor("doesn't match")} the file ${coloredFilename}.\n\n${this.utils.diff(
              output,
              content,
            )}`,
        };
      }
    }
  } else {
    if (updateSnapshot === "new" || updateSnapshot === "all") {
      fs.mkdirSync(path.dirname(filepath), { recursive: true });
      fs.writeFileSync(filepath, content);

      this.snapshotState.added++;

      return { pass: true, message: () => "" };
    } else {
      this.snapshotState.unmatched++;

      return {
        pass: true,
        message: () => `The output file ${coloredFilename} ${errorColor("doesn't exist")}.`,
      };
    }
  }
}

expect.extend({ toMatchRawFileSnapshot } as any);
