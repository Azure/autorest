import { MemoryFileSystem } from "@azure-tools/datastore";
import * as assert from "assert";

describe("FileSystemTests", () => {
  it("does async iterable work", async () => {
    const f = new MemoryFileSystem(
      new Map<string, string>([
        ["readme.md", "# this is a test\n see https://aka.ms/autorest"],
        ["other.md", "#My Doc."],
      ]),
    );
    let n = 0;
    for (const name of await f.EnumerateFileUris()) {
      n++;
    }
    assert.equal(n, 2);
    assert.equal(await f.ReadFile(MemoryFileSystem.DefaultVirtualRootUri + "other.md"), "#My Doc.");
  });
});
