import chalk from "chalk";
import { PrettyLogFormatter } from ".";

process.uptime = jest.fn(() => 1.23);

describe("Formatter", () => {
  describe("Pretty formatter", () => {
    let formatter: PrettyLogFormatter;
    describe("with colors", () => {
      beforeEach(() => {
        formatter = new PrettyLogFormatter();
      });

      it("color message", () => {
        expect(formatter.log({ level: "information", message: "Some 'quote'" })).toEqual(
          `${chalk.green("info   ")} | Some ${chalk.gray("'quote'")}`,
        );
      });

      it("color code", () => {
        expect(formatter.log({ level: "information", code: "SomeError", message: "Message for error" })).toEqual(
          `${chalk.green("info   ")} | ${chalk.green("SomeError")} | Message for error`,
        );
      });

      it("color timestamp", () => {
        expect(formatter.log({ level: "debug", message: "Debugging" })).toEqual(
          `${chalk.blue("debug  ")} | ${chalk.yellow("[1.23 s]")} Debugging`,
        );
      });

      it("color sources", () => {
        expect(
          formatter.log({
            level: "information",
            message: "Tracing source",
            source: [{ document: "foo.json", position: { line: 12, column: 5 } }],
          }),
        ).toEqual(
          [
            `${chalk.green("info   ")} | Tracing source`,
            `    - ${chalk.cyan("foo.json")}:${chalk.cyan.bold("12")}:${chalk.cyan.bold("5")}`,
          ].join("\n"),
        );
      });
    });
  });
});
