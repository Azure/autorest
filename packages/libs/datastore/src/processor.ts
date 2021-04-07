import { clone, values } from "@azure-tools/linq";
import { Mapping } from "source-map";
import { ProxyObject } from "./graph-builder";
import { createGraphProxy, Node, ProxyNode, visit } from "./main";
import { parseJsonPointer, serializeJsonPointer } from "./json-pointer";

export interface AnyObject {
  [key: string]: any;
  [key: number]: any;
}

type Objects<T> = { [K in keyof T]: T[K] extends object ? K : never }[keyof T];
type ObjectMembers<T> = Pick<T, Objects<T>>;
type Real<T> = T extends null | undefined | never ? never : T;

export interface Source {
  ReadObject<T>(): Promise<T>;
  key: string;
}

export class Transformer<TInput extends object = AnyObject, TOutput extends object = AnyObject> {
  protected generated: TOutput;
  protected mappings = new Array<Mapping>();
  protected final?: TOutput;
  protected current!: TInput;
  private targetPointers = new Map<object, string>();

  public async getOutput(): Promise<TOutput> {
    await this.runProcess();
    return <TOutput>this.final;
  }

  public async getSourceMappings(): Promise<Array<Mapping>> {
    await this.runProcess();
    return this.mappings;
  }

  // public process(input: string, parent: ProxyObject<TOutput>, nodes: Iterable<NodeT<TInput, keyof TInput>>) {
  public async process(target: ProxyObject<TOutput>, nodes: Iterable<Node>) {
    /* override this method */
  }

  public async init() {
    /* override this method */
  }

  public async finish() {
    /* override this method */
  }
  public getOrCreateObject<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
  ) {
    return target[member] === undefined ? this.newObject(target, member, pointer) : target[member];
  }

  public getOrCreateArray<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
  ) {
    return target[member] === undefined ? this.newArray(target, member, pointer) : target[member];
  }

  public newObject<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
  ): AnyObject {
    const parentTargetPointer = parseJsonPointer(this.targetPointers.get(target) ?? "");
    const targetPointer = serializeJsonPointer([...parentTargetPointer, member as string]);
    const value = <ProxyObject<TParent[K]>>createGraphProxy(this.currentInputFilename, targetPointer, this.mappings);
    this.targetPointers.set(value, targetPointer);
    target[member] = {
      value: <TParent[typeof member]>value,
      filename: this.currentInputFilename,
      pointer,
    };

    return <Real<TParent[K]>>value;
  }

  public newArray<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
  ) {
    const parentTargetPointer = parseJsonPointer(this.targetPointers.get(target) ?? "");
    const targetPointer = serializeJsonPointer([...parentTargetPointer, member as string]);

    const value = <ProxyObject<TParent[K]>>(
      createGraphProxy(this.currentInputFilename, targetPointer, this.mappings, new Array<any>())
    );
    this.targetPointers.set(value, targetPointer);
    target[member] = {
      value: <TParent[typeof member]>value,
      filename: this.currentInputFilename,
      pointer,
    };

    return <Real<TParent[K]>>value;
  }

  protected copy<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
    value: TParent[K],
    recurse = true,
  ) {
    return (target[member] = <ProxyNode<TParent[K]>>{ value, pointer, recurse, filename: this.currentInputFilename });
  }
  protected clone<TParent extends object, K extends keyof TParent>(
    target: ProxyObject<TParent>,
    member: K,
    pointer: string,
    value: TParent[K],
    recurse = true,
  ) {
    // return target[member] = <ProxyNode<TParent[K]>>{ value: JSON.parse(JSON.stringify(value)), pointer, recurse, filename: this.key };
    return (target[member] = <ProxyNode<TParent[K]>>{
      value: clone(value),
      pointer,
      recurse,
      filename: this.currentInputFilename,
    });
  }

  protected inputs: Array<Source>;
  protected currentInput!: Source;

  constructor(inputs: Array<Source> | Source) {
    this.generated = <TOutput>createGraphProxy("", "", this.mappings);
    this.targetPointers.set(this.generated, "");
    this.inputs = Array.isArray(inputs) ? inputs : [inputs];
  }

  protected get currentInputFilename(): string {
    if (this.currentInput) {
      return this.currentInput.key;
    }
    // default to the first document if we haven't started processing yet.
    return this.inputs[0].key;
  }

  protected async runProcess() {
    if (!this.final) {
      await this.init();
      for (this.currentInput of values(this.inputs)) {
        this.current = await this.currentInput.ReadObject<TInput>();
        await this.process(this.generated, visit(this.current));
      }
      await this.finish();
    }
    this.final = clone(this.generated); // should we be freezing this?
  }
}

export class Processor<TInput extends object, TOutput extends object> extends Transformer<TInput, TOutput> {
  constructor(originalFile: Source) {
    super([originalFile]);
  }
}

export function typeOf(obj: any) {
  if (obj === null) {
    return "null";
  }
  const t = typeof obj;

  return t === "object" ? (Array.isArray(obj) ? "array" : "object") : t;
}
