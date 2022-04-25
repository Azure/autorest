import { defineKnownRequirement } from "./common";
import { execute } from "./exec-cmd";

export const DotnetExeName = "dotnet";

export const resolveDotnetRequirement = defineKnownRequirement(DotnetExeName, async (cmd) => {
  try {
    const result = await execute(cmd, ["--version"]);
    return result.stdout;
  } catch (e) {
    return undefined;
  }
});
