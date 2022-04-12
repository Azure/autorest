import { createTestSession, TestSession } from "@autorest/extension-base/testing";

export async function createTestSessionFromModel<TInputModel>(
  config: any,
  model: any,
): Promise<TestSession<TInputModel>> {
  return createTestSession(config, [
    {
      model: model,
      filename: "openapi-3.json",
      content: JSON.stringify(model),
    },
  ]);
}
