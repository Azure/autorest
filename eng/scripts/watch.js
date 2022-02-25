const { repoRoot, run, tsc } = require("./helpers.js");
run(tsc, ["--build", "--watch"], { cwd: repoRoot, sync: false });
