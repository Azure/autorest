export interface Disposable {
  /**
   * Dispose this object.
   */
  dispose(): void;
}
export declare namespace Disposable {
  function create(func: () => void): Disposable;
}
/**
 * Represents a typed event.
 */
export interface Event<T> {
  /**
   *
   * @param listener The listener function will be call when the event happens.
   * @param thisArgs The 'this' which will be used when calling the event listener.
   * @param disposables An array to which a {{IDisposable}} will be added. The
   * @return
   */
  (listener: (e: T) => any, thisArgs?: any, disposables?: Array<Disposable>): Disposable;
}
export declare namespace Event {
  const None: Event<any>;
}
export interface EmitterOptions {
  onFirstListenerAdd?: Function;
  onLastListenerRemove?: Function;
}
export declare class Emitter<T> {
  private _options;
  private static _noop;
  private _event;
  private _callbacks;
  constructor(_options?: EmitterOptions | undefined);
  /**
   * For the public to allow to subscribe
   * to events from this Emitter
   */
  readonly event: Event<T>;
  /**
   * To be kept private to fire an event to
   * subscribers
   */
  fire(event: T): any;
  dispose(): void;
}

/**
 * Defines a CancellationToken. This interface is not
 * intended to be implemented. A CancellationToken must
 * be created via a CancellationTokenSource.
 */
export interface CancellationToken {
  /**
   * Is `true` when the token has been cancelled, `false` otherwise.
   */
  readonly isCancellationRequested: boolean;
  /**
   * An [event](#Event) which fires upon cancellation.
   */
  readonly onCancellationRequested: Event<any>;
}
export declare namespace CancellationToken {
  const None: CancellationToken;
  const Cancelled: CancellationToken;
  function is(value: any): value is CancellationToken;
}
export declare class CancellationTokenSource {
  readonly token: CancellationToken;
  cancel(): void;
  dispose(): void;
}
