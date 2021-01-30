import { Protocol } from "./metadata";

/** custom extensible metadata for individual protocols (ie, HTTP, etc) */
export interface Protocols {
  http?: Protocol;
  amqp?: Protocol;
  mqtt?: Protocol;
  jsonrpc?: Protocol;
}

export class Protocols implements Protocols {}
