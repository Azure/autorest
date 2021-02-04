import { MemoryFileSystem } from "./file-system";

describe("Filesystem", () => {
  it("Simple memory filesystem test", async () => {
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
    expect(n).toEqual(2);
    expect(await f.ReadFile(MemoryFileSystem.DefaultVirtualRootUri + "other.md")).toEqual("#My Doc.");
  });
});
