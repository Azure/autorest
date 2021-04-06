/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { AutoRest, Channel, Message } from "../src/exports";
import { RealFileSystem } from "@azure-tools/datastore";
import { join } from "path";
import { AppRoot } from "../src/lib/constants";
import { AutorestContextLoader } from "../src/lib/context";
import { createFileUri } from "@azure-tools/uri";

const generate = async (file: string): Promise<{ errors: Message[] }> => {
  const autoRest = new AutoRest(new RealFileSystem());
  autoRest.AddConfiguration({
    "verbose": true,
    "debug": true,
    "require": [file],
    "output-artifact": ["openapi-document"],
  });

  const messages: Message[] = [];
  const channels = new Set([
    Channel.Information,
    Channel.Warning,
    Channel.Error,
    Channel.Fatal,
    Channel.Debug,
    Channel.Verbose,
  ]);

  autoRest.Message.Subscribe((_, message) => {
    if (channels.has(message.Channel)) {
      messages.push(message);
    }
  });

  const success = await autoRest.Process().finish;
  await AutorestContextLoader.shutdown();

  if (success) {
    // eslint-disable-next-line no-console
    console.log("Messages", messages);
    throw new Error("Autorest complete with success but should have failed.");
  }

  const errors = messages.filter((x) => x.Channel === Channel.Error);

  if (errors.length === 0) {
    // eslint-disable-next-line no-console
    console.log("Messages", messages);
    throw new Error("Autorest should have logged errors");
  }
  return { errors };
};

describe("Blaming (e2e)", () => {
  it("Find original position of duplicate key error in config", async () => {
    const file = join(AppRoot, "test", "resources", "error-in-config/duplicate-key-yaml.md");
    const { errors } = await generate(file);
    expect(errors.length).toEqual(2);

    expect(errors[0].Text).toEqual("Syntax Error Encountered:  Syntax error: duplicate key");
    expect(errors[0].Source).toEqual([
      {
        Position: { column: 0, line: 10 },
        document: createFileUri(file),
      },
    ]);
  });

  it("Find original position of invalid yaml indent error in config", async () => {
    const file = join(AppRoot, "test", "resources", "error-in-config/invalid-indent-yaml.md");
    const { errors } = await generate(file);
    expect(errors.length).toEqual(3);
    expect(errors[0].Text).toEqual("Syntax Error Encountered:  Syntax error: bad indentation of a mapping entry");
    expect(errors[0].Source).toEqual([
      {
        Position: { column: 0, line: 11 },
        document: createFileUri(file),
      },
    ]);
  });
});
