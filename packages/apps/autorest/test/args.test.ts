import { homedir } from "os";
import { join } from "path";
import { parseArgs } from "../src/args";

const cwd = process.cwd();

describe("Args", () => {
  it("defaults to undefined", () => {
    expect(parseArgs([""]).debug).toBe(undefined);
  });

  it("parse flags", () => {
    expect(parseArgs(["--debug"]).debug).toBe(true);
  });

  it("parse flags with explicity value=true", () => {
    expect(parseArgs(["--debug=true"]).debug).toBe(true);
  });

  it("parse flags with explicity value:true", () => {
    expect(parseArgs(["--debug:true"]).debug).toBe(true);
  });

  it("parse flags with explicity value=false", () => {
    expect(parseArgs(["--debug=false"]).debug).toBe(false);
  });

  it("parse flags with explicity value:false", () => {
    expect(parseArgs(["--debug:false"]).debug).toBe(false);
  });

  it("parse args with absolute path using : seperator", () => {
    expect(parseArgs(["--configFileOrFolder:/path/to/folder"]).configFileOrFolder).toEqual("/path/to/folder");
  });

  it("parse args with absolute path using = seperator", () => {
    expect(parseArgs(["--configFileOrFolder=/path/to/folder"]).configFileOrFolder).toEqual("/path/to/folder");
  });

  it("parse args with relative path", () => {
    expect(parseArgs(["--configFileOrFolder:./path/to/folder"]).configFileOrFolder).toEqual(
      join(cwd, "path/to/folder"),
    );
  });

  it("parse args with ~ path", () => {
    expect(join(parseArgs(["--configFileOrFolder:~/path/to/folder"]).configFileOrFolder)).toEqual(
      join(homedir(), "path/to/folder"),
    );
  });

  it("parse args with quotes", () => {
    expect(parseArgs([`--configFileOrFolder:"/path/to/folder"`]).configFileOrFolder).toEqual("/path/to/folder");
  });

  it("parse multipe args", () => {
    expect(parseArgs(["--debug", "--configFileOrFolder=/path/to/folder", "--preview:false"])).toEqual({
      debug: true,
      configFileOrFolder: "/path/to/folder",
      preview: false,
    });
  });
});
