import { readFile } from "@azure-tools/async-io";
import { deserialize, fail } from "@azure-tools/codegen";
import { Session, startSession } from "@autorest/extension-base";
import { Model } from "@azure-tools/openapi";

export interface TestSessionInput {
  model: any;
  filename: string;
  content: string;
}

export interface TestSession<T> {
  session: Session<T>;
  errors: Array<any>;
}

async function readData(folder: string, ...files: Array<string>): Promise<Map<string, TestSessionInput>> {
  const results = new Map<string, { model: any; filename: string; content: string }>();

  for (const filename of files) {
    const content = await readFile(`${folder}/${filename}`);
    const model = deserialize<any>(content, filename);
    results.set(filename, {
      model,
      filename,
      content,
    });
  }
  return results;
}

export async function createTestSessionFromFiles<TInputModel>(
  config: any,
  folder: string,
  inputs: Array<string>,
): Promise<TestSession<TInputModel>> {
  const models = await readData(folder, ...inputs);
  return createTestSession(config, models);
}

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

export async function createTestSession<TInputModel>(
  config: any,
  inputs: Array<TestSessionInput> | Map<string, TestSessionInput>,
): Promise<TestSession<TInputModel>> {
  const models = Array.isArray(inputs) ? inputs.reduce((m, x) => m.set(x.filename, x), new Map()) : inputs;
  const errors: Array<any> = [];
  const session = await startSession<TInputModel>({
    ReadFile: (filename: string) =>
      Promise.resolve(models.get(filename)?.content ?? fail(`missing input '${filename}'`)),
    GetValue: (key: string) => Promise.resolve(key ? config[key] : config),
    ListInputs: (artifactType?: string) => Promise.resolve([...models.values()].map((x) => x.filename)),
    ProtectFiles: (path: string) => Promise.resolve(),
    WriteFile: (filename: string, content: string, sourceMap?: any, artifactType?: string) => Promise.resolve(),
    Message: (message: any): void => {
      if (message.Channel === "warning" || message.Channel === "error" || message.Channel === "verbose") {
        // console.error(`${message.Channel} ${message.Text}`);
        if (message.Channel === "error") {
          errors.push(message);
        }
      }
    },
    UpdateConfigurationFile: (filename: string, content: string) => {},
    GetConfigurationFile: (filename: string) => Promise.resolve(""),
  });
  return { session, errors };
}
