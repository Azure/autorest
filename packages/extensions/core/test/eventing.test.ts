import assert from "assert";
import { IEvent, EventEmitter } from "../src/lib/events";

export class MyClass extends EventEmitter {
  @EventEmitter.Event public Debug!: IEvent<MyClass, string>;

  public go() {
    this.Debug.Dispatch("Hello");
  }
}

describe("Eventing", () => {
  it("Do Events Work", () => {
    const instance = new MyClass();
    let worksWithSubscribe = "no";
    let worksLikeNode = "no";

    instance.on("Debug", (inst: MyClass, s: string) => {
      worksLikeNode = s;
    });

    const unsub = instance.Debug.Subscribe((instance, args) => {
      worksWithSubscribe = args;
    });

    instance.go();

    // test out subscribe
    assert.equal(worksLikeNode, "Hello");
    assert.equal(worksWithSubscribe, "Hello");

    // test out unsubscribe
    worksWithSubscribe = "no";
    unsub();

    assert.equal(worksWithSubscribe, "no");
  });
});
