import assert from "assert";
import { CodeModel, Operation } from "@autorest/codemodel";
import oai3, { Model } from "@azure-tools/openapi";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { Flattener } from "../../src/flattener/flattener";
import { ModelerFour } from "../../src/modeler/modelerfour";
import { addOperation, createTestSessionFromModel, createTestSpec } from "../utils";

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

  expect(errors).toHaveLength(0);

  const result = modeler.process();
  expect(errors).toHaveLength(0);
  return result;
}

export async function runFlattener(
  codemodel: CodeModel,
  config: { modelerfour: ModelerFourOptions } = cfg,
): Promise<CodeModel> {
  const { session, errors } = await createTestSessionFromModel<CodeModel>(config, codemodel);
  session.model = codemodel;
  const flattener = await new Flattener(session).init();

  expect(errors).toHaveLength(0);

  const result = flattener.process();
  expect(errors).toHaveLength(0);
  return result;
}

export async function runModelerWithOperation(
  method: string,
  path: string,
  operation: oai3.HttpOperation,
): Promise<Operation> {
  const spec = createTestSpec();

  addOperation(spec, path, {
    [method]: { operationId: "test", ...operation },
  });

  const codeModel = await runModeler(spec);
  const m4Operation = codeModel.operationGroups[0]?.operations[0];
  assert(m4Operation);
  return m4Operation;
}
