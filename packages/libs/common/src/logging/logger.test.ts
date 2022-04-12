import { AutorestAsyncLogger, AutorestSyncLogger } from "./logger";
import { LoggingSession } from "./logging-session";
import { LoggerAsyncProcessor, LoggerProcessor, LoggerSink } from "./types";

describe("Logger", () => {
  let sink: LoggerSink;

  beforeEach(() => {
    sink = {
      log: jest.fn(),
      startProgress: jest.fn(),
    };
  });

  describe("AutorestSyncLogger", () => {
    it("sends message to sink", () => {
      const logger = new AutorestSyncLogger({
        sinks: [sink],
      });

      logger.verbose("My message");
      expect(sink.log).toHaveBeenCalledTimes(1);
      expect(sink.log).toHaveBeenCalledWith({
        level: "verbose",
        message: "My message",
      });
    });

    it("sends message to each sink", () => {
      const otherSink = {
        log: jest.fn(),
        startProgress: jest.fn(),
      };

      const logger = new AutorestSyncLogger({
        sinks: [sink, otherSink],
      });

      logger.debug("My message");
      expect(sink.log).toHaveBeenCalledTimes(1);
      expect(sink.log).toHaveBeenCalledWith({
        level: "debug",
        message: "My message",
      });
      expect(otherSink.log).toHaveBeenCalledTimes(1);
      expect(otherSink.log).toHaveBeenCalledWith({
        level: "debug",
        message: "My message",
      });
    });

    it("sends process messages", () => {
      const processor: LoggerProcessor = {
        process: (log) => {
          return { ...log, message: `${log.message} [Processed]` };
        },
      };
      const logger = new AutorestSyncLogger({
        sinks: [sink],
        processors: [processor],
      });

      logger.info("My message");
      expect(sink.log).toHaveBeenCalledTimes(1);
      expect(sink.log).toHaveBeenCalledWith({
        level: "information",
        message: "My message [Processed]",
      });
    });
  });

  describe("AutorestASyncLogger", () => {
    let session: LoggingSession;
    beforeEach(() => {
      session = new LoggingSession();
    });

    it("sends message to sink async", async () => {
      const logger = new AutorestAsyncLogger({
        sinks: [sink],
        asyncSession: session,
      });

      logger.verbose("My message");
      expect(sink.log).toHaveBeenCalledTimes(0);
      await session.waitForMessages();
      expect(sink.log).toHaveBeenCalledTimes(1);
      expect(sink.log).toHaveBeenCalledWith({
        level: "verbose",
        message: "My message",
      });
    });

    it("sends async process messages", async () => {
      const processor: LoggerAsyncProcessor = {
        process: async (log) => {
          return Promise.resolve({ ...log, message: `${log.message} [Processed]` });
        },
      };
      const logger = new AutorestAsyncLogger({
        sinks: [sink],
        asyncSession: session,
        processors: [processor],
      });

      logger.info("My message");
      expect(sink.log).toHaveBeenCalledTimes(0);
      await session.waitForMessages();

      expect(sink.log).toHaveBeenCalledTimes(1);
      expect(sink.log).toHaveBeenCalledWith({
        level: "information",
        message: "My message [Processed]",
      });
    });
  });
});
