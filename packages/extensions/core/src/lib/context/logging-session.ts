import EventEmitter from "events";
import { Message } from "../message";

/**
 * Class processing the logger and disatching async.
 */
export class LoggingSession {
  private events = new EventEmitter();

  private pendingMessage: Promise<unknown> | undefined;

  public on(event: "message", callback: (message: Message) => void) {
    this.events.addListener(event, callback);
  }

  public registerLog(sendMessage: () => Promise<Message | undefined>): void {
    this.pendingMessage = (this.pendingMessage ?? Promise.resolve()).then(async () => {
      try {
        const message = await sendMessage();
        if (message) {
          this.events.emit("message", message);
        }
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
