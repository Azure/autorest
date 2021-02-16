import { validateSystemRequirements } from "./system-requirements";

describe("System requirements", () => {
  it("returns no error when requirements are matched", async () => {
    const errors = await validateSystemRequirements({
      node: { version: ">10" },
    });
    expect(errors).toEqual([]);
  });

  it("returns error when requesting an executable that is not present", async () => {
    const errors = await validateSystemRequirements({
      unkownCommandThatShouldNotExists: { message: "That command is misssing" },
    });

    expect(errors).toEqual([
      {
        error: true,
        name: "unkownCommandThatShouldNotExists",
        command: "unkownCommandThatShouldNotExists",
        message: "That command is misssing",
      },
    ]);
  });
});
