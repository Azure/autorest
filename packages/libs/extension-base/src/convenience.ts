/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createSandbox, deserialize } from "@azure-tools/codegen";
import { Host } from "./exports";
import { Channel, Message, Mapping, RawSourceMap, JsonPath, Position } from "./types";
import { Schema, DEFAULT_SCHEMA } from "js-yaml";

const safeEval = createSandbox();

async function getModel<T>(service: Host, yamlSchema: Schema = DEFAULT_SCHEMA, artifactType?: string) {
  const files = await service.ListInputs(artifactType);
  const filename = files[0];
  if (files.length === 0) {
    throw new Error("Inputs missing.");
  }
  const content = await service.ReadFile(filename);

  return {
    filename,
    model: deserialize<T>(content, filename, yamlSchema),
  };
}

export class Session<TInputModel> {
  private context!: any;
  private _debug = false;
  private _verbose = false;
  model!: TInputModel;
  filename!: string;

  /* @internal */ constructor(public readonly service: Host) {}

  /* @internal */ async init<TProject>(project?: TProject, schema: Schema = DEFAULT_SCHEMA, artifactType?: string) {
    const m = await getModel<TInputModel>(this.service, schema, artifactType);
    this.model = m.model;
    this.filename = m.filename;

    void this.initContext(project);
    this._debug = await this.getValue("debug", false);
    this._verbose = await this.getValue("verbose", false);
    return this;
  }

  /* @internal */ async initContext<TP>(project?: TP) {
    this.context = this.context || {
      $config: await this.service.GetValue(""),
      $project: project,
      $lib: {
        path: require("path"),
      },
    };
    return this;
  }

  async readFile(filename: string): Promise<string> {
    return this.service.ReadFile(filename);
  }

  async getValue<V>(key: string, defaultValue?: V): Promise<V> {
    // check if it's in the model first
    const m = <any>this.model;
    let value = m && m.language && m.language.default ? m.language.default[key] : undefined;

    // fall back to the configuration
    if (value == null || value === undefined) {
      value = await this.service.GetValue(key);
    }

    // try as a safe eval execution.
    if (value === null || value === undefined) {
      try {
        value = safeEval(key, this.context);
      } catch {
        value = null;
      }
    }

    if (defaultValue === undefined && value === null) {
      throw new Error(`No value for configuration key '${key}' was provided`);
    }

    if (typeof value === "string") {
      value = await this.resolveVariables(value);
    }

    // ensure that any content variables are resolved at the end.
    return <V>(value !== null ? value : defaultValue);
  }

  async setValue<V>(key: string, value: V) {
    (<any>this.model).language.default[key] = value;
  }

  async listInputs(artifactType?: string | undefined): Promise<Array<string>> {
    return this.service.ListInputs(artifactType);
  }

  async protectFiles(path: string): Promise<void> {
    return this.service.ProtectFiles(path);
  }
  writeFile(
    filename: string,
    content: string,
    sourceMap?: Array<Mapping> | RawSourceMap | undefined,
    artifactType?: string | undefined,
  ): void {
    return this.service.WriteFile(filename, content, sourceMap, artifactType);
  }

  message(message: Message): void {
    if (message.Channel === Channel.Debug && this._debug === false) {
      return;
    }
    if (message.Channel === Channel.Verbose && this._verbose === false) {
      return;
    }
    return this.service.Message(message);
  }

  updateConfigurationFile(filename: string, content: string): void {
    return this.service.UpdateConfigurationFile(filename, content);
  }
  async getConfigurationFile(filename: string): Promise<string> {
    return this.service.GetConfigurationFile(filename);
  }
  protected errorCount = 0;

  protected static async getModel<T>(service: Host) {
    const files = await service.ListInputs();
    const filename = files[0];
    if (files.length === 0) {
      throw new Error("Inputs missing.");
    }
    return {
      filename,
      model: deserialize<T>(await service.ReadFile(filename), filename),
    };
  }

  cache = new Array<any>();
  replacer(key: string, value: any) {
    if (typeof value === "object" && value !== null) {
      if (this.cache.indexOf(value) !== -1) {
        // Duplicate reference found
        try {
          // If this value does not reference a parent it can be deduped
          return JSON.parse(JSON.stringify(value));
        } catch (error) {
          // discard key if value cannot be deduped
          return;
        }
      }
      // Store value in our collection
      this.cache.push(value);
    }
    return value;
  }

  async resolveVariables(input: string): Promise<string> {
    let output = input;
    for (const rx of [/\$\((.*?)\)/g, /\$\{(.*?)\}/g]) {
      /* eslint-disable */
      for (let match; (match = rx.exec(input)); ) {
        const text = match[0];
        const inner = match[1];
        let value = await this.getValue<any>(inner, null);

        if (value !== undefined && value !== null) {
          if (typeof value === "object") {
            value = JSON.stringify(value, this.replacer, 2);
          }
          if (value === "{}") {
            value = "true";
          }
          output = output.replace(text, value);
        }
      }
    }
    return output;
  }

  public checkpoint() {
    if (this.errorCount > 0) {
      throw new Error(`${this.errorCount} errors occured -- cannot continue.`);
    }
  }

  protected msg(channel: Channel, message: string, key: Array<string>, objectOrPath?: string | Object, details?: any) {
    const sourcePosition = objectOrPath ? (<any>objectOrPath)["_#get-position#_"] || String(objectOrPath) : undefined;
    if (objectOrPath && (<any>objectOrPath)["_#get-position#_"])
      this.message({
        Channel: channel,
        Key: key,
        Source: [sourcePosition],
        Text: message,
        Details: details,
      });
    else {
      this.message({
        Channel: channel,
        Key: key,
        Source: [],
        Text: message,
        Details: details,
      });
    }
  }

  public warning(message: string, key: Array<string>, objectOrPath?: string | Object, details?: any) {
    this.msg(Channel.Warning, message, key, objectOrPath, details);
  }
  public hint(message: string, key: Array<string>, objectOrPath?: string | Object, details?: any) {
    this.msg(Channel.Hint, message, key, objectOrPath, details);
  }

  public error(message: string, key: Array<string>, objectOrPath?: string | Object, details?: any) {
    this.errorCount++;
    this.msg(Channel.Error, message, key, objectOrPath, details);
  }
  public fatal(message: string, key: Array<string>, objectOrPath?: string | Object, details?: any) {
    this.errorCount++;
    this.msg(Channel.Fatal, message, key, objectOrPath, details);
  }

  protected output(channel: Channel, message: string, details?: any) {
    this.message({
      Channel: channel,
      Text: message,
      Details: details,
    });
  }

  public debug(message: string, details: any) {
    this.output(Channel.Debug, message, details);
  }
  public verbose(message: string, details: any) {
    this.output(Channel.Verbose, message, details);
  }
  public log(message: string, details: any) {
    this.output(Channel.Information, message, details);
  }
}

export async function startSession<TInputModel>(
  service: Host,
  project?: any,
  schema: Schema = DEFAULT_SCHEMA,
  artifactType?: string,
) {
  return await new Session<TInputModel>(service).init(project, schema, artifactType);
}
