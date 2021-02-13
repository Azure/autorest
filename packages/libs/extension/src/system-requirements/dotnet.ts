import { execute } from "../exec-cmd";
import { defineKnownRequirement } from "./common";

export const DotnetExeName = "dotnet";

export const validateDotnetRequirement = defineKnownRequirement(DotnetExeName, async (cmd) => {
  try {
    const result = await execute(cmd, ["--version"]);
    return result.stdout;
  } catch (e) {
    return undefined;
  }
});
