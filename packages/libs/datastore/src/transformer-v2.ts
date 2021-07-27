import { clone, values } from "@azure-tools/linq";
import { Mapping } from "source-map";
import { Node, ProxyNode, visit } from "./main";
import { cloneDeep } from "lodash";
import { DataHandle } from "./data-store";
import { createMappingTree, MappingTreeItem, MappingTreeObject } from "./mapping-tree";

type Real<T> = T extends null | undefined | never ? never : T;

export class TransformerV2<TInput extends object = any, TOutput extends object = any> {
  protected generated: MappingTreeItem<TOutput>;
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

  // public process(input: string, parent: MappingTreeObject<TOutput>, nodes: Iterable<NodeT<TInput, keyof TInput>>) {
  public async process(target: MappingTreeItem<TOutput>, nodes: Iterable<Node>) {
    /* override this method */
  }

  public async init() {
    /* override this method */
  }

  public async finish() {
    /* override this method */
  }
  public getOrCreateObject<TParent extends object, K extends keyof TParent>(
    target: MappingTreeObject<TParent>,
    member: K,
    pointer: string,
  ) {
    return target[member] === undefined ? this.newObject(target, member, pointer) : target[member];
  }

  public getOrCreateArray<TParent extends object, K extends keyof TParent>(
    target: MappingTreeObject<TParent>,
    member: K,
    pointer: string,
  ) {
    return target[member] === undefined ? this.newArray(target, member, pointer) : target[member];
  }

  public newObject<TParent extends object, K extends keyof TParent>(
    target: MappingTreeObject<TParent>,
    member: K,
    sourcePointer: string,
  ): MappingTreeItem<Required<TParent[K]>> {
    target.__set__(member, {
      value: {} as any,
      sourceFilename: this.currentInputFilename,
      sourcePointer,
    });

    return target[member] as any;
  }

  public newArray<TParent extends object, K extends keyof TParent>(
    target: MappingTreeObject<TParent>,
    member: K,
    sourcePointer: string,
  ) {
    target.__set__(member, {
      value: [] as any,
      sourceFilename: this.currentInputFilename,
      sourcePointer,
    });

    return target[member] as any;
  }

  // protected copy<TParent extends object, K extends keyof TParent>(
  //   target: MappingTreeObject<TParent>,
  //   member: K,
  //   pointer: string,
  //   value: TParent[K],
  //   recurse = true,
  // ) {
  //   return (target[member] = <ProxyNode<TParent[K]>>{ value, pointer, recurse, filename: this.currentInputFilename });
  // }

  protected clone<TParent extends object, K extends keyof TParent>(
    target: MappingTreeObject<TParent>,
    member: K,
    sourcePointer: string,
    value: TParent[K],
  ) {
    target.__set__(member, {
      value: cloneDeep(value),
      sourcePointer,
      sourceFilename: this.currentInputFilename,
    });
    return target[member];
  }

  protected inputs: Array<DataHandle>;
  protected currentInput!: DataHandle;

  constructor(inputs: Array<DataHandle> | DataHandle) {
    this.generated = createMappingTree<TOutput>("", {}, this.mappings);
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
