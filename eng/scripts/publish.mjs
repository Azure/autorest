import { execSync } from "child_process";

const branchName = "publish/auto-release";

execSync(`node common/scripts/install-run-rush.js publish --apply`);
const stdout = execSync(`git status --porcelain`).toString();

if (stdout.trim() !== "") {
  console.log("Commiting the following changes:\n", stdout);

  execSync(
    `git -c user.email=autochangesetbot@microsoft.com -c user.name="Microsoft Auto Changeset Bot" commit -am "Bump versions"`,
  );
  execSync(`git push origin HEAD:${branchName} --force`);

  console.log();
  console.log("-".repeat(160));
  console.log("|  Link to create the PR");
  console.log(`|  https://github.com/Azure/autorest/pull/new/${branchName}  `);
  console.log("-".repeat(160));
} else {
  console.log("No changes to publish");
}
