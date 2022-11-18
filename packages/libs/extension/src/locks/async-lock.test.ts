import { Delay, ExclusiveLockUnavailableException } from "@azure-tools/tasks";
import { AsyncLock } from "./async-lock";

describe("AsyncLock", () => {
  it("request to acquire locks in sequence", async () => {
    const asyncLock = new AsyncLock();
    async function run() {
      const release = await asyncLock.acquire();
      await Delay(200);
      await release();
    }

    await run();
    await run();
  });

  it("request to acquire locks in parallel", async () => {
    const asyncLock = new AsyncLock();
    async function run() {
      const release = await asyncLock.acquire();
      await Delay(200);
      release();
    }

    const r1 = run();
    const r2 = run();
    await Promise.all([r1, r2]);
  });

  it("timeout if lock not acquired in time", async () => {
    const asyncLock = new AsyncLock();
    async function run() {
      const release = await asyncLock.acquire(100);
      await Delay(200);
      release();
    }

    const r1 = run();
    await expect(asyncLock.acquire(100)).rejects.toThrow(ExclusiveLockUnavailableException);
    await r1;
  });
});
