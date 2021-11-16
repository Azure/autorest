/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createSandbox, deserialize, ShadowedNodePath } from "@azure-tools/codegen";
import { Schema, DEFAULT_SCHEMA } from "js-yaml";
import { AutorestExtensionHost, WriteFileOptions } from "./autorest-extension-host";
import { LogLevel } from "./extension-logger";
import { Channel, Message, SourceLocation, LogSource } from "./types";

const safeEval = createSandbox();

async function getModel<T>(service: AutorestExtensionHost, yamlSchema: Schema = DEFAULT_SCHEMA, artifactType?: string) {
  const files = await service.listInputs(artifactType);
  const filename = files[0];
  if (files.length === 0) {
    throw new Error("Inputs missing.");
  }
  const content = await service.readFile(filename);

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

  /* @internal */ constructor(public readonly service: AutorestExtensionHost) {}

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
      $config: await this.service.getValue(""),
      $project: project,
      $lib: {
        path: require("path"),
      },
    };
    return this;
  }

  async readFile(filename: string): Promise<string> {
    return this.service.readFile(filename);
  }

  async getValue<V>(key: string, defaultValue?: V): Promise<V> {
    // check if it's in the model first
    const m = <any>this.model;
    let value = m && m.language && m.language.default ? m.language.default[key] : undefined;

    // fall back to the configuration
    if (value == null || value === undefined) {
      value = await this.service.getValue(key);
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

  async listInputs(artifactType?: string | undefined): Promise<string[]> {
    return this.service.listInputs(artifactType);
  }

  async protectFiles(path: string): Promise<void> {
    return this.service.protectFiles(path);
  }

  public writeFile(options: WriteFileOptions): void {
    return this.service.writeFile(options);
  }

  public message(message: Message): void {
    if (message.Channel === Channel.Debug && this._debug === false) {
      return;
    }
    if (message.Channel === Channel.Verbose && this._verbose === false) {
      return;
    }
    return this.service.message(message);
  }

  protected errorCount = 0;

  protected static async getModel<T>(service: AutorestExtensionHost) {
    const files = await service.listInputs();
    const filename = files[0];
    if (files.length === 0) {
      throw new Error("Inputs missing.");
    }
    return {
      filename,
      model: deserialize<T>(await service.readFile(filename), filename),
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

  protected msg(level: LogLevel, message: string, key?: string[], source?: LogSource, details?: any) {
    const sourcePosition = source ? getPosition(this.filename, source) : undefined;
    this.service.logger.log({
      level,
      message,
      key,
      source: sourcePosition,
      details,
    });
  }

  public debug(message: string) {
    this.msg("debug", message);
  }

  public verbose(message: string) {
    this.msg("verbose", message);
  }

  public info(message: string) {
    this.msg("info", message);
  }

  public warning(message: string, key: string[], source?: LogSource, details?: any) {
    this.msg("warning", message, key, source, details);
  }

  public error(message: string, key: string[], source?: LogSource, details?: any) {
    this.errorCount++;
    this.msg("error", message, key, source, details);
  }

  public fatal(message: string, key: string[], source?: LogSource, details?: any) {
    this.errorCount++;
    this.msg("fatal", message, key, source, details);
  }
}

export async function startSession<TInputModel>(
  service: AutorestExtensionHost,
  project?: any,
  schema: Schema = DEFAULT_SCHEMA,
  artifactType?: string,
) {
  return await new Session<TInputModel>(service).init(project, schema, artifactType);
}

function getPosition(document: string, source: LogSource): SourceLocation | undefined {
  if (typeof source === "string") {
    return { Position: { path: source }, document };
  }

  if (source[ShadowedNodePath]) {
    return { Position: { path: source[ShadowedNodePath] }, document };
  }

  if ("path" in source || "line" in source) {
    return { Position: source as any, document };
  }
  return undefined;
}
