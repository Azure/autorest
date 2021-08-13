/**
 * Class processing the logger and disatching async.
 */
export class LoggingSession {
  private pendingMessage: Promise<unknown> | undefined;
  public registerLog(sendMessage: () => Promise<unknown>): void {
    this.pendingMessage = (this.pendingMessage ?? Promise.resolve()).then(async () => {
      try {
        await sendMessage();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error("Unexpected error while logging", error);
      }
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

export const AutorestLoggingSession = new LoggingSession();
