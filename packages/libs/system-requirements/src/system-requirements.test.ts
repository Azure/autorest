import { validateExtensionSystemRequirements } from "./system-requirements";

describe("System requirements", () => {
  it("returns no error when requirements are matched", async () => {
    const errors = await validateExtensionSystemRequirements({
      node: { version: ">10" },
    });
    expect(errors).toEqual([]);
  });

  it("returns error when requesting an executable that is not present", async () => {
    const errors = await validateExtensionSystemRequirements({
      unkownCommandThatShouldNotExists: {},
    });

    expect(errors).toEqual([
      {
        error: true,
        name: "unkownCommandThatShouldNotExists",
        command: "unkownCommandThatShouldNotExists",
        message: "Couldn't find executable 'unkownCommandThatShouldNotExists' in path. Make sure it is installed.",
      },
    ]);
  });
});
