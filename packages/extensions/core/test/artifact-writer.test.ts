jest.mock("@azure-tools/uri");

import { AutorestRawConfiguration } from "@autorest/configuration";
import { writeString, writeBinary } from "@azure-tools/uri";
import { ArtifactWriter } from "../src/artifact-writer";

const TestStrings = {
  mixed: "some\ndifferent\r\nline\nendings\r\n",
  lf: "some\ndifferent\nline\nendings\n",
  crlf: "some\r\ndifferent\r\nline\r\nendings\r\n",
};

async function writeArtifact(
  content: string,
  { eol, type }: { eol?: AutorestRawConfiguration["eol"]; type?: string } = {},
) {
  const writer = new ArtifactWriter({ eol } as any);
  writer.writeArtifact({
    uri: "foo.txt",
    type: type ?? "foo",
    content: content,
  });
  await writer.wait();
}

describe("ArtifactWriter", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  describe("line endings", () => {
    it("keeps it as it is by default", async () => {
      await writeArtifact(TestStrings.mixed);
      expect(writeString).toHaveBeenCalledTimes(1);
      expect(writeString).toHaveBeenCalledWith("foo.txt", TestStrings.mixed);
    });
    it("keeps it as it is if eol=default", async () => {
      await writeArtifact(TestStrings.mixed, { eol: "default" });
      expect(writeString).toHaveBeenCalledTimes(1);
      expect(writeString).toHaveBeenCalledWith("foo.txt", TestStrings.mixed);
    });

    it("change line endings to \n it as it is if eol=lf", async () => {
      await writeArtifact(TestStrings.mixed, { eol: "lf" });
      expect(writeString).toHaveBeenCalledTimes(1);
      expect(writeString).toHaveBeenCalledWith("foo.txt", TestStrings.lf);
    });

    it("change line endings to \r\n it as it is if eol=crlf", async () => {
      await writeArtifact(TestStrings.mixed, { eol: "crlf" });
      expect(writeString).toHaveBeenCalledTimes(1);
      expect(writeString).toHaveBeenCalledWith("foo.txt", TestStrings.crlf);
    });

    it("keeps it as it is by default if file is binary", async () => {
      await writeArtifact(TestStrings.mixed, { eol: "lf", type: "binary-file" });
      expect(writeString).toHaveBeenCalledTimes(0);
      expect(writeBinary).toHaveBeenCalledTimes(1);
      expect(writeBinary).toHaveBeenCalledWith("foo.txt", TestStrings.mixed);
    });
  });
});
