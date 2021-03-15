import { ResolveUri, CreateFileOrFolderUri } from "@azure-tools/uri";
import { join } from "path";
import { UriNotFoundError } from "./errors";
import { RealFileSystem } from "./real-file-system";

const baseDir = CreateFileOrFolderUri(join(__dirname, "../../test/resources/fake-fs"));

describe("MemoryFileSystem", () => {
  const fs = new RealFileSystem();

  describe("accessing load files", () => {
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

  describe("accessing remote files", () => {
    it("should looks for readme.md when listing files", async () => {
      const files = await fs.list("https://github.com/Azure/autorest/blob/master/");
      expect(files).toHaveLength(1);
      expect(files[0]).toEqual("https://github.com/Azure/autorest/blob/master/readme.md");
    });

    it("should read local file content", async () => {
      expect(await fs.read("https://github.com/Azure/autorest/blob/master/readme.md")).toContain("Autorest");
    });

    it("should throw error if the local file doesn't exists", async () => {
      await expect(() =>
        fs.read("https://github.com/Azure/autorest/blob/master/this-file-doesnot-exists.md"),
      ).rejects.toThrowError(UriNotFoundError);
    });
  });
});
