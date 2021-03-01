import { createTestSessionFromFiles } from "../utils";
import { ModelerFour } from "../../src/modeler/modelerfour";
import { readdirSync } from "fs";
import { serialize } from "@azure-tools/codegen";
import { Model } from "@azure-tools/openapi";
import { codeModelSchema } from "@autorest/codemodel";

const cfg = {
  "modelerfour": {
    "flatten-models": true,
    "flatten-payloads": true,
    "group-parameters": true,
    "resolve-schema-name-collisons": true,
    "additional-checks": true,
    "always-create-content-type-parameter": true,
    "naming": {
      override: {
        $host: "$host",
        cmyk: "CMYK",
      },
      local: "_ + camel",
      constantParameter: "pascal",
      /*
        for when playing with python style settings :

        parameter: 'snakecase',
        property: 'snakecase',
        operation: 'snakecase',
        operationGroup: 'pascalcase',
        choice: 'pascalcase',
        choiceValue: 'uppercase',
        constant: 'uppercase',
        type: 'pascalcase',
        // */
    },
  },
  "payload-flattening-threshold": 2,
};

const inputsFolder = `${__dirname}/inputs/`;
const expectedFolder = `${__dirname}/expected/`;

describe("Testing rendering specific scenarios", () => {
  const folders = readdirSync(inputsFolder);

  for (const folder of folders) {
    it(`generate model for '${folder}'`, async () => {
      const { session, errors } = await createTestSessionFromFiles<Model>(cfg, `${inputsFolder}/${folder}`, [
        "openapi-document.json",
      ]);

      expect(errors.length).toBe(0);

      const modeler = await new ModelerFour(session).init();
      const codeModel = modeler.process();

      const yaml = serialize(codeModel, codeModelSchema);
      expect(yaml).toMatchRawFileSnapshot(`${expectedFolder}/${folder}/modeler.yaml`);
    });
  }
});
