import { AutorestSyncLogger, FilterLogger, FilterLoggerOptions } from ".";

describe("FilterLogger", () => {
  const sink = {
    log: jest.fn(),
    startProgress: jest.fn(),
  };

  beforeEach(() => {
    jest.resetAllMocks();
  });

  function createFilterLogger(options: FilterLoggerOptions) {
    return new AutorestSyncLogger({
      sinks: [sink],
      processors: [new FilterLogger(options)],
    });
  }

  it("does not log level below configured level", () => {
    const logger = createFilterLogger({ level: "verbose" });
    logger.debug("This is some debug");
    expect(sink.log).not.toHaveBeenCalled();
  });

  it("log same level as configured level", () => {
    const logger = createFilterLogger({ level: "verbose" });

    logger.verbose("This is some verbose");
    expect(sink.log).toHaveBeenCalledTimes(1);
    expect(sink.log).toHaveBeenCalledWith({ level: "verbose", message: "This is some verbose" });
  });

  it("log level above configured level", () => {
    const logger = createFilterLogger({ level: "verbose" });
    logger.info("This is some information");
    expect(sink.log).toHaveBeenCalledTimes(1);
    expect(sink.log).toHaveBeenCalledWith({ level: "information", message: "This is some information" });
  });
});
