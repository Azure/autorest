import { AutorestSimpleLogger } from ".";

global.console = { log: jest.fn() } as any;

describe("SimpleLogger", () => {
  let logger: AutorestSimpleLogger;
  beforeEach(() => {
    jest.resetAllMocks();
  });

  describe("pretty format", () => {
    beforeEach(() => {
      logger = new AutorestSimpleLogger({
        color: false,
        timestamp: false,
      });
    });

    it("log debug", () => {
      logger.debug("This is some debug");
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("DEBUG: This is some debug");
    });

    it("log verbose", () => {
      logger.verbose("This is some verbose");
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("VERBOSE: This is some verbose");
    });

    it("log information", () => {
      logger.info("This is some information");
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("INFORMATION: This is some information");
    });

    it("log warning", () => {
      logger.trackWarning({
        code: "TestWarning",
        message: "This is some warning",
      });
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("WARNING (TestWarning): This is some warning");
    });

    it("log error", () => {
      logger.trackError({
        code: "TestError",
        message: "This is some error",
      });
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("ERROR (TestError): This is some error");
    });

    it("log fatal", () => {
      logger.fatal("This is some fatal error");
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith("FATAL: This is some fatal error");
    });
  });

  describe("json format", () => {
    beforeEach(() => {
      logger = new AutorestSimpleLogger({
        format: "json",
        timestamp: false,
      });
    });

    it("log debug", () => {
      logger.debug("This is some debug");
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith('{"level":"debug","message":"This is some debug"}');
    });

    it("log warning", () => {
      logger.trackWarning({
        code: "TestWarning",
        message: "This is some warning",
      });
      expect(console.log).toHaveBeenCalledTimes(1);
      expect(console.log).toHaveBeenCalledWith(
        '{"level":"warning","code":"TestWarning","message":"This is some warning"}',
      );
    });
  });
});
