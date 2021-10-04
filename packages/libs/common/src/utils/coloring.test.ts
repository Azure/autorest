import chalk from "chalk";
import { color } from "./coloring";

describe("Coloring", () => {
  it("bold text", () => {
    expect(color("some **bold**")).toEqual(`some ${chalk.bold("bold")}`);
  });

  it("color title 1", () => {
    expect(color("# title")).toEqual(chalk.greenBright("title"));
  });

  it("color title 2", () => {
    expect(color("## title")).toEqual(chalk.green("title"));
  });

  it("color title 3", () => {
    expect(color("### title")).toEqual(chalk.cyanBright("title"));
  });

  it("highlight urls", () => {
    expect(color("some content https://example.com with url")).toEqual(
      `some content ${chalk.blue.bold.underline("https://example.com")} with url`,
    );

    expect(color("some content https://example.com/some/path with url and path")).toEqual(
      `some content ${chalk.blue.bold.underline("https://example.com/some/path")} with url and path`,
    );
  });

  it("italic text", () => {
    expect(color("some _italic_")).toEqual(`some ${chalk.italic("italic")}`);
  });

  it("gray ' quoted text", () => {
    expect(color(`some 'single quote text'`)).toEqual(`some ${chalk.gray("'single quote text'")}`);
  });

  it(`gray " quoted text`, () => {
    expect(color(`some "double quote text"`)).toEqual(`some ${chalk.gray(`"double quote text"`)}`);
  });

  it("gray ` quoted text", () => {
    expect(color("some `backtick quote text`")).toEqual(`some ${chalk.gray("backtick quote text")}`);
  });

  it("color [] wrapped text", () => {
    expect(color("some [arg] with [option]")).toEqual(
      `some ${chalk.yellow.bold("[arg]")} with ${chalk.yellow.bold("[option]")}`,
    );
  });

  it("color [] wrapped text with bold elements", () => {
    expect(color("**some** [arg] with [option]")).toEqual(
      `${chalk.bold("some")} ${chalk.yellow.bold("[arg]")} with ${chalk.yellow.bold("[option]")}`,
    );
  });
});
