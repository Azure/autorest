const { spawn } = require("child_process");

const onExit = (childProcess) => {
  let messages = [];
  return new Promise((resolve, reject) => {
    if (childProcess.stdout) {
      childProcess.stdout.on("data", (message) => messages.push(message));
    }
    childProcess.once("exit", (code, signal) => {
      if (code === 0) {
        resolve(messages);
      }
      reject(new Error(`Exit with code: ${code}`));
    });

    childProcess.once("error", (error) => {
      reject(error);
    });
  });
};

async function check_tree() {
  await onExit(
    spawn("git", ["add", "-A"], {
      stdio: [process.stdin, process.stdout, process.stderr],
    }),
  );

  // If there is any output from this command it means that
  // there are non committed changes so we need to handle
  // stout
  const messages = await onExit(spawn("git", ["diff", "--staged", "--compact-summary"]));

  if (messages.length !== 0) {
    // Once we have verified that there are non committed changes
    // run git diff again, this time forwarding the stout to present
    // a readable hint to the user
    await onExit(
      spawn("git", ["diff", "--staged", "--compact-summary"], {
        stdio: [process.stdin, process.stdout, process.stderr],
      }),
    );

    throw new Error(
      "Git tree is dirty, regenerate all test swaggers and make sure that there are no un-intended changes",
    );
  }
}

check_tree().catch((error) => {
  console.error(error);
  throw error;
});
