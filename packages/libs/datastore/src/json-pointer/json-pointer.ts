import * as jp from "@azure-tools/json";
import { JsonPointer, JsonPointerTokens } from "@azure-tools/json";

export interface Node<T = any> {
  value: T;
  key: string;
  pointer: JsonPointer;
  children: Iterable<Node<T[keyof T]>>;
  childIterator: () => Iterable<Node<T[keyof T]>>;
}

export function* visit(obj: any | undefined, parentReference: JsonPointerTokens = new Array<string>()): Iterable<Node> {
  if (!obj) {
    return;
  }

  for (const [key, value] of Object.entries(obj)) {
    const reference = [...parentReference, key];
    yield {
      value,
      key,
      pointer: jp.serializeJsonPointer(reference),
      children: visit(value, reference),
      childIterator: () => visit(value, reference),
    };
  }
}
