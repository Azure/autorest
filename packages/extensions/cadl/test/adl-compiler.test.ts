import { compileAdl } from "cadl-compiler";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const resourceFolder = join(dirname(fileURLToPath(import.meta.url)), "scenarios");

describe("Adl Compiler", () => {
  it("compile simple adl file", async () => {
    const result = await compileAdl(join(resourceFolder, "simple.adl"));
    expect(result).toEqual(undefined);
  });
});
