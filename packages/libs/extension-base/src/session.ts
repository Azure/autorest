/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createSandbox, deserialize, ShadowedNodePath } from "@azure-tools/codegen";
import { Schema, DEFAULT_SCHEMA } from "js-yaml";
import { AutorestExtensionHost, WriteFileOptions } from "./extension-host";
import { LogLevel } from "./extension-logger";
import { Channel, Message, SourceLocation, LogSource } from "./types";

export interface SessionOptions<T> {
  host: AutorestExtensionHost;
  filename: string;
  model: T;
  configuration: any;
}

const safeEval = createSandbox();

export class Session<TInputModel> {
  public model: TInputModel;
  public filename: string;
  public configuration: Record<string, any>;

  private context: any;
  protected errorCount = 0;
  private _debug = false;
  private _verbose = false;
  private service: AutorestExtensionHost;

  /* @internal */ constructor(options: SessionOptions<TInputModel>) {
    this.service = options.host;
    this.filename = options.filename;
    this.model = options.model;

    this.configuration = options.configuration;
    this._debug = options.configuration.debug;
    this._verbose = options.configuration.verbose;
    this.context = {
      $config: options.configuration,
      $lib: {
        path: require("path"),
      },
    };
  }

  public async readFile(filename: string): Promise<string> {
    return this.service.readFile(filename);
  }

  public async getValue<V>(key: string, defaultValue?: V): Promise<V> {
    let value = await this.service.getValue(key);

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

    // ensure that any content variables are resolved at the end.
    return <V>(value !== null ? value : defaultValue);
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

  public checkpoint() {
    if (this.errorCount > 0) {
      throw new Error(`${this.errorCount} errors occured -- cannot continue.`);
    }
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

  /**
   * @deprecated use #info
   */
  public log(message: string) {
    this.info(message);
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
}

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

export async function startSession<TInputModel>(
  host: AutorestExtensionHost,
  schema: Schema = DEFAULT_SCHEMA,
  artifactType?: string,
) {
  // This is just to make it work with older version so the older method definition is also valid.
  if (artifactType?.constructor.name === "Schema") {
    schema = artifactType as any;
    artifactType = undefined;
  }
  const { model, filename } = await getModel<TInputModel>(host, schema, artifactType);
  const configuration = await host.getValue("");
  return new Session<TInputModel>({ host, filename, model, configuration });
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
