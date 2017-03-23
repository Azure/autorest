require('source-map-support').install({ hookRequire: true });

import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import { IFileSystem, MemoryFileSystem } from "../lib/file-system"
import * as assert from "assert";
require("./polyfill.min.js");

@suite class FileSystemTests {
  @test async "does async iterable work"() {
    let f = new MemoryFileSystem(new Map<string, string>([['readme.md', '# this is a test\n see https://aka.ms/autorest'], ['other.md', '#My Doc.']]));
    let n = 0;
    for await (const name of f.EnumerateFileUris()) {
      n++;
    }
    assert.equal(n, 2);

    assert.equal(await f.ReadFile(MemoryFileSystem.DefaultVirtualRootUri + "other.md"), "#My Doc.");
  }
}