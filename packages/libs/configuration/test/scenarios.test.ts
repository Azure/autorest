import { join } from "path";
import { serialize } from "../../codegen/dist/yaml";
import { ConfigurationLoader } from "../src";

const defaultConfigUri = `file:///${join(__dirname, "../resources/default-configuration.md")}`;

async function testScenario(name: string) {
  const errors = [];
  const logger = {
    verbose: jest.fn(),
    info: jest.fn(),
    fatal: jest.fn((x) => errors.push(x)),
    trackError: jest.fn((x) => errors.push(x)),
    trackWarning: jest.fn((x) => errors.push(x)),
  };
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
});
