export interface PathReference {
  $ref: string;
}

export type Refable<T extends {} | undefined> = T | PathReference;

export interface Dereferenced<T> {
  instance: T;
  name: string;
  fromRef?: boolean;
}

export type ExtensionKey = `x-${string}`;

export type Extensions = {
  [key in ExtensionKey]: any;
};
