import { CodeModel } from "@autorest/codemodel";
import { Model } from "@azure-tools/openapi";
import { ModelerFour } from "../../src/modeler/modelerfour";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { createTestSessionFromModel } from "../utils";

const modelerfourOptions: ModelerFourOptions = {
  "flatten-models": true,
  "flatten-payloads": true,
  "group-parameters": true,
  "resolve-schema-name-collisons": true,
  "additional-checks": true,
  "always-create-accept-parameter": true,
  //'always-create-content-type-parameter': true,
  naming: {
    override: {
      $host: "$host",
      cmyk: "CMYK",
    },
    local: "_ + camel",
    constantParameter: "pascal",
  },
};

const cfg = {
  modelerfour: modelerfourOptions,
  "payload-flattening-threshold": 2,
};

export async function runModeler(spec: any, config: { modelerfour: ModelerFourOptions } = cfg): Promise<CodeModel> {
  const { session, errors } = await createTestSessionFromModel<Model>(config, spec);
  const modeler = await new ModelerFour(session).init();

  expect(errors.length).toBe(0);

  return modeler.process();
}
