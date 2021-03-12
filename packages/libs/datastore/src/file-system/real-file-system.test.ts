import { ResolveUri, CreateFileOrFolderUri } from "@azure-tools/uri";
import { join } from "path";
import { UriNotFoundError } from "./errors";
import { RealFileSystem } from "./real-file-system";

const baseDir = CreateFileOrFolderUri(join(__dirname, "../../test/resources/fake-fs"));

describe("MemoryFileSystem", () => {
  const fs = new RealFileSystem();

  it("should list files", async () => {
    const files = await fs.list(baseDir);
    expect(files).toHaveLength(2);
  });

  it("should read local file content", async () => {
    expect(await fs.read(ResolveUri(baseDir + "/", "foo.txt"))).toEqual("bar\n");
  });

  it("should throw error if the local file doesn't exists", async () => {
    const uri = ResolveUri(baseDir + "/", "unkown-file.md");
    await expect(() => fs.read(uri)).rejects.toThrowError(UriNotFoundError);
  });
});
