/**
 * Class processing the logger and disatching async.
 */
export class AsyncLogManager {
  private pendingMessage: Promise<unknown> | undefined;

  public registerLog(messagePromise: Promise<unknown>): void {
    this.pendingMessage = Promise.resolve()
      .then(() => this.pendingMessage)
      .then(() => messagePromise)
      .catch((error) => {
        // eslint-disable-next-line no-console
        console.error("Unexpected error while logging", error);
      });
  }

  /**
   * Wait for any pending message to be sent.
   */
  public async waitForMessages(): Promise<void> {
    if (this.pendingMessage) {
      await this.pendingMessage;
    }
  }
}
