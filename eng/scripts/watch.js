const { repoRoot, run, tsc } = require("./helpers.js");
run(tsc, ["--build", "tsconfig.ws.json", "--watch"], { cwd: repoRoot, sync: false });
