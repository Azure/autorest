import assert from "assert";
import { validateSystemRequirements } from "./system-requirements";

describe.only("System requirements", () => {
  it("works", async () => {
    const response = await validateSystemRequirements({
      dotnet: { message: "Dotnet required", version: ">4" },
    });

    console.log("Response", response);
  });

  it("returns error when requesting an executable that is not present", async () => {
    const errors = await validateSystemRequirements({
      unkownCommandThatShouldNotExists: { message: "That command is misssing" },
    });

    assert.deepStrictEqual(errors, [
      {
        name: "unkownCommandThatShouldNotExists",
        message: "That command is misssing",
      },
    ]);
  });
});
