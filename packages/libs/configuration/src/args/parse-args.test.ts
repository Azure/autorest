import { homedir } from "os";
import { join } from "path";
import { parseArgs } from "./parse-args";

const cwd = process.cwd();

describe("ParseArgs", () => {
  it("defaults to undefined", () => {
    expect(parseArgs([""]).rawOptions.debug).toBe(undefined);
  });

  it("parse flags", () => {
    expect(parseArgs(["--debug"]).rawOptions.debug).toBe(true);
  });

  it("parse flags with explicity value=true", () => {
    expect(parseArgs(["--debug=true"]).rawOptions.debug).toBe(true);
  });

  it("parse flags with explicity value:true", () => {
    expect(parseArgs(["--debug:true"]).rawOptions.debug).toBe(true);
  });

  it("parse flags with explicity value=false", () => {
    expect(parseArgs(["--debug=false"]).rawOptions.debug).toBe(false);
  });

  it("parse flags with explicity value:false", () => {
    expect(parseArgs(["--debug:false"]).rawOptions.debug).toBe(false);
  });

  it("parse args with absolute path using : seperator", () => {
    expect(parseArgs(["--input-file:/path/to/folder"]).rawOptions["input-file"]).toEqual("/path/to/folder");
  });

  it("parse args with absolute path using = seperator", () => {
    expect(parseArgs(["--input-file=/path/to/folder"]).rawOptions["input-file"]).toEqual("/path/to/folder");
  });

  it("parse args with relative path", () => {
    expect(parseArgs(["--input-file:./path/to/folder"]).rawOptions["input-file"]).toEqual(join(cwd, "path/to/folder"));
  });

  it("parse args with ~ path", () => {
    expect(join(parseArgs(["--input-file:~/path/to/folder"]).rawOptions["input-file"])).toEqual(
      join(homedir(), "path/to/folder"),
    );
  });

  it("parse args with quotes", () => {
    expect(parseArgs([`--input-file:"/path/to/folder"`]).rawOptions["input-file"]).toEqual("/path/to/folder");
  });

  it("parse multipe args", () => {
    expect(parseArgs(["--debug", "--input-file=/path/to/folder", "--preview:false"]).rawOptions).toEqual({
      "debug": true,
      "input-file": "/path/to/folder",
      "preview": false,
    });
  });
});
