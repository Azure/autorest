// Use this script to publish packages 
import { execSync } from "child_process";

// Publish packages using pnpm and chronus
console.log("Running chronus publish process...");

try {
  // Create a releases using chronus
  execSync(`pnpm chronus version`, { stdio: "inherit" });
  const stdout = execSync(`git status --porcelain`).toString();

  if (stdout.trim() !== "") {
    console.log("Commiting the following changes:\n", stdout);

    execSync(`git add -A`);
    execSync(
      `git -c user.email=chronus@github.com -c user.name="Auto Chronus Bot" commit -am "Bump versions"`,
    );
    execSync(`git push origin HEAD:publish/auto-release --force`);

    console.log();
    console.log("-".repeat(160));
    console.log("|  Link to create the PR");
    console.log(`|  https://github.com/Azure/autorest/pull/new/publish/auto-release  `);
    console.log("-".repeat(160));
  } else {
    console.log("No changes to publish");
  }
} catch (error) {
  console.error("Error during publish process:", error);
  process.exit(1);
}