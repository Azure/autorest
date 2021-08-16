import { FilterLogger } from ".";

describe("FilterLogger", () => {
  const innerLogger = {
    info: jest.fn(),
    verbose: jest.fn(),
    fatal: jest.fn(),
    trackWarning: jest.fn(),
    trackError: jest.fn(),
    log: jest.fn(),
    diagnostics: [],
  };

  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("does not log level below configured level", () => {
    const logger = new FilterLogger({ level: "verbose", logger: innerLogger });
    logger.debug("This is some debug");
    expect(innerLogger.log).not.toHaveBeenCalled();
  });

  it("log same level as configured level", () => {
    const logger = new FilterLogger({ level: "verbose", logger: innerLogger });

    logger.verbose("This is some verbose");
    expect(innerLogger.log).toHaveBeenCalledTimes(1);
    expect(innerLogger.log).toHaveBeenCalledWith({ level: "verbose", message: "This is some verbose" });
  });

  it("log level above configured level", () => {
    const logger = new FilterLogger({ level: "verbose", logger: innerLogger });
    logger.info("This is some information");
    expect(innerLogger.log).toHaveBeenCalledTimes(1);
    expect(innerLogger.log).toHaveBeenCalledWith({ level: "information", message: "This is some information" });
  });
});
