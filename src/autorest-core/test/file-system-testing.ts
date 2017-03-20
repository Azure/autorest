require('source-map-support').install({ hookRequire: true });

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import { IFileSystem, MemoryFileSystem } from "../lib/file-system"
import * as assert from "assert";
require("./polyfill.min.js");

@suite class FileSystemTests {
  @test async "does async iterable work"() {
    let f: IFileSystem = new MemoryFileSystem("c:\\foo", new Map<string, string>([['readme.md', '# this is a test\n see https://aka.ms/autorest'], ['other.md', '#My Doc.']]));
    let n = 0;
    for await (const name of f.EnumerateFiles()) {
      n++;
    }
    assert.equal(n, 2);

    assert.equal(await f.ReadFile("other.md"), "#My Doc.");
  }
}