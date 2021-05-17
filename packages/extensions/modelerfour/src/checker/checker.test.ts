import { CodeModel, ObjectSchema, Operation, OperationGroup, Response } from "@autorest/codemodel";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { error } from "node:console";
import { createTestSessionFromModel } from "../../test/utils";
import { Checker } from "./checker";

const runChecker = async (model: CodeModel, options: ModelerFourOptions = {}) => {
  const { session, errors } = await createTestSessionFromModel<CodeModel>({ modelerfour: options }, model);
  const checker = new Checker(session);
  await checker.init();
  checker.process();
  return errors;
};

describe("Checker", () => {
  let model: CodeModel;

  beforeEach(() => {
    model = new CodeModel("TestChecker");
  });

  describe("validate operations responses", () => {
    let operation: Operation;

    beforeEach(() => {
      const group = new OperationGroup("FooGroup");
      model.operationGroups.push(group);
      operation = new Operation("Bar", "Desc");
      group.addOperation(operation);
    });

    it("log errors if operation only has exceptions", async () => {
      operation.addException(
        new Response({
          protocol: { http: { statusCodes: ["default"] } },
        }),
      );

      const errors = await runChecker(model);
      expect(errors).toEqual([
        {
          Channel: "error",
          Key: ["OperationNoSuccessResponse"],
          Source: [],
          Text: "Operation 'FooGroup' > 'Bar' only has error responses:\n" + " -  (statusCodes: default)",
          Details: undefined,
        },
      ]);
    });

    it("log errors if operation has no responses", async () => {
      const errors = await runChecker(model);
      expect(errors).toEqual([
        {
          Channel: "error",
          Key: ["OperationNoSuccessResponse"],
          Source: [],
          Text: "Operation 'FooGroup' > 'Bar' doesn't have any responses.",
          Details: undefined,
        },
      ]);
    });

    it("log no errors if operation has at least one success response", async () => {
      operation.addResponse(
        new Response({
          protocol: { http: { statusCodes: ["200"] } },
        }),
      );
      const errors = await runChecker(model);
      expect(errors).toHaveLength(0);
    });
  });
});
