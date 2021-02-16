import { execute } from "../exec-cmd";
import { defineKnownRequirement } from "./common";

export const JavaExeName = "java";

export const resolveJavaRequirement = defineKnownRequirement(JavaExeName, async () => {
  try {
    const result = await execute(JavaExeName, ["-version"]);
    return parseJavaVersionFromStdout(result.stdout);
  } catch (e) {
    return undefined;
  }
});

const JAVA_VERSION_REGEX = /java version "(.*)"/;

const parseJavaVersionFromStdout = (stdout: string): string | undefined => {
  const match = JAVA_VERSION_REGEX.exec(stdout);
  return match?.[1];
};
