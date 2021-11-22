import { readFile } from "fs/promises";
import { deserialize, fail } from "@azure-tools/codegen";
import { WriteFileOptions } from "../extension-host";
import { AutorestExtensionLogger } from "../extension-logger";
import { Session, startSession } from "../session";

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
    const buffer = await readFile(`${folder}/${filename}`);
    const content = buffer.toString();
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

/**
 * Create a Test session to use for testing extension.
 * @param config Autorest configuration to use in this session.
 * @param inputs List of inputs.
 * @returns Test session
 */
export async function createTestSession<TInputModel>(
  config: any,
  inputs: Array<TestSessionInput> | Map<string, TestSessionInput>,
): Promise<TestSession<TInputModel>> {
  const models = Array.isArray(inputs) ? inputs.reduce((m, x) => m.set(x.filename, x), new Map()) : inputs;
  const errors: Array<any> = [];

  const sendMessage = (message: any): void => {
    if (message.Channel === "warning" || message.Channel === "error" || message.Channel === "verbose") {
      if (message.Channel === "error") {
        errors.push(message);
      }
    }
  };

  const session = await startSession<TInputModel>({
    logger: new AutorestExtensionLogger(sendMessage),
    readFile: (filename: string) =>
      Promise.resolve(models.get(filename)?.content ?? fail(`missing input '${filename}'`)),
    getValue: (key: string) => Promise.resolve(key ? config[key] : config),
    listInputs: (artifactType?: string) => Promise.resolve([...models.values()].map((x) => x.filename)),
    protectFiles: (path: string) => Promise.resolve(),
    writeFile: (options: WriteFileOptions) => Promise.resolve(),
    message: sendMessage,
    UpdateConfigurationFile: (filename: string, content: string) => {},
    GetConfigurationFile: (filename: string) => Promise.resolve(""),
  } as any);
  return { session, errors };
}
