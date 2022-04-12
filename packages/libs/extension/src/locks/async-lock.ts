import { ExclusiveLockUnavailableException } from "@azure-tools/tasks";

/**
 * Lock using promises to await on lock.
 */
export class AsyncLock {
  private promise: Promise<void> | undefined;

  /**
   * @constructor - Creates an instance of a CriticalSection
   *
   * @param name - a cosmetic name for the 'resource'. Note: multiple CriticalSection instances with the same do not offer exclusivity, it's tied to the object instance.
   */
  public constructor(private name: string = "unnamed") {}

  /**
   * Asynchronously acquires the lock. Will wait for up {@link timeoutMS} milliseconds
   * @throws ExclusiveLockUnavailableException - if the timeout is reached before the lock can be acquired.
   * @param timeoutMS - the length of time in miliiseconds to wait for a lock.
   * @returns - the release function to release the lock.
   */
  public async acquire(timeoutMS = 20000, name?: string): Promise<() => void> {
    const timeout = createTimeout(timeoutMS);

    if (this.promise !== undefined) {
      const waitForPromise = async () => {
        while (this.promise !== undefined) {
          await this.promise;
        }
      };

      await Promise.race([waitForPromise(), timeout.promise]);
    }

    // check to see if the promise is still around, which indicates
    // that we must have timed out.
    if (this.promise) {
      throw new ExclusiveLockUnavailableException(this.name, timeoutMS);
    }
    // Stop the timeout so it doesn't keep a pending Promise around.
    timeout.cancel();

    let resolvePromise: () => void;
    let released = false;
    this.promise = new Promise<void>((resolve) => {
      resolvePromise = resolve;
    });

    // the release function is returned to the consumer
    return () => {
      if (!released) {
        released = true;
        this.promise = undefined;
        resolvePromise();
      }
    };
  }
}

export interface PromiseTimeout {
  promise: Promise<void>;
  cancel(): void;
}

function createTimeout(delayMS: number): PromiseTimeout {
  let timeout: NodeJS.Timeout;

  const promise = new Promise<void>((res) => {
    timeout = setTimeout(res, delayMS);
  });
  return {
    promise,
    cancel: () => {
      clearTimeout(timeout);
    },
  };
}
