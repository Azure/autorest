import { join } from "path";
import { AutorestTestLogger } from "@autorest/test-utils";
import { serialize } from "../../codegen/dist/yaml";
import { ConfigurationLoader } from "../src";

const defaultConfigUri = `file:///${join(__dirname, "../resources/default-configuration.md")}`;

async function testScenario(name: string) {
  const logger = new AutorestTestLogger();
  const file = `file:///${join(__dirname, "inputs", name, "main.md")}`;
  const loader = new ConfigurationLoader(logger, defaultConfigUri, file);
  const config = await loader.load([], false);

  // Cleanup.
  delete config.config.raw.__parents;

  const raw = serialize(config.config.raw);
  expect(raw).toMatchRawFileSnapshot(join(__dirname, "expected", `${name}.yaml`));
}

describe("Configuration scenarios", () => {
  it("require", async () => {
    await testScenario("require");
  });

  it("nested-flag", async () => {
    await testScenario("nested-flag");
  });
});
