import { UriNotFoundError } from "./errors";
import { MemoryFileSystem } from "./memory-file-system";

describe("MemoryFileSystem", () => {
  const fs = new MemoryFileSystem(
    new Map<string, string>([
      ["readme.md", "# this is a test\n see https://aka.ms/autorest"],
      ["other.md", "#My Doc."],
    ]),
  );

  it("should list files", async () => {
    const files = await fs.list();
    expect(files).toHaveLength(2);
  });

  it("should read file content", async () => {
    expect(await fs.read(MemoryFileSystem.DefaultVirtualRootUri + "other.md")).toEqual("#My Doc.");
  });

  it("should throw error if the file doesn't exists", async () => {
    const uri = MemoryFileSystem.DefaultVirtualRootUri + "unkown-file.md";
    await expect(() => fs.read(uri)).rejects.toThrowError(UriNotFoundError);
  });
});
