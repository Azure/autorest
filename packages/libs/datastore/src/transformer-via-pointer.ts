import { Node } from "./json-pointer";
import { AnyObject, Transformer, typeOf } from "./processor";

export abstract class TransformerViaPointer<
  TInput extends object = AnyObject,
  TOutput extends object = AnyObject
> extends Transformer<TInput, TOutput> {
  public async process(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (!(await this.visitLeaf(target, value, key, pointer, children))) {
        await this.defaultCopy(target, value, key, pointer, children);
      }
    }
  }

  /**
   * Visit each node in the tree.
   * @param target Target node
   * @param value Value at the node
   * @param key Key of the property for the node.
   * @param pointer Pointer of the node in the document.
   * @param originalNodes Children nodes.
   * @returns false to automatically copy the leaf and navigate deeper. true to say it has been handled and will not be copied.
   */
  abstract visitLeaf(
    target: AnyObject,
    value: AnyObject,
    key: string,
    pointer: string,
    originalNodes: Iterable<Node>,
  ): Promise<boolean>;

  public async defaultCopy(
    target: AnyObject,
    ivalue: AnyObject,
    ikey: string,
    ipointer: string,
    originalNodes: Iterable<Node>,
  ) {
    switch (typeOf(ivalue)) {
      case "object":
        {
          // objects recurse
          const newTarget = this.newObject(target, ikey, ipointer);
          for (const { value, key, pointer, children } of originalNodes) {
            if (!(await this.visitLeaf(newTarget, value, key, pointer, children))) {
              await this.defaultCopy(newTarget, value, key, pointer, children);
            }
          }
        }
        break;
      case "array":
        {
          const newTarget = this.newArray(target, ikey, ipointer);
          for (const { value, key, pointer, children } of originalNodes) {
            if (!(await this.visitLeaf(newTarget, value, key, pointer, children))) {
              await this.defaultCopy(newTarget, value, key, pointer, children);
            }
          }
        }
        break;
      default:
        // everything else, just clone.
        this.clone(target, ikey, ipointer, ivalue);
    }
  }
}
