import { Presets, SingleBar } from "cli-progress";
import { ConsoleLogger } from "./console-logger-sink";

class MockTTYStream {
  // class MockTTYStream implements NodeJS.WritableStream {
  public readonly isTTY = true;

  public currentOutput = "";
  private lines: string[] = [];
  private currentLine = Buffer.from("");
  private cursor = 0;

  public constructor() {}

  public clearLine(number: string) {
    this.lines.splice(-number);
    this.updateOutput();
  }

  public write(b: Buffer | string) {
    const content = b.toString();
    if (content.startsWith("\x1b")) {
      // Parse the reset cursor value. not really correct but does the job for now for testing.
      this.cursor = 0;
      return;
    }

    const [first, ...lines] = content.toString().split("\n");
    this.currentLine = Buffer.concat([this.currentLine.slice(0, this.cursor), Buffer.from(first)]);
    this.cursor = this.currentLine.length;
    for (const line of lines) {
      this.lines.push(this.currentLine.toString());
      this.currentLine = Buffer.from(line);
      this.cursor = this.currentLine.length;
    }
    this.updateOutput();
  }

  private updateOutput() {
    this.currentOutput = [...this.lines, this.currentLine.toString()].join("\n");
  }
}

describe("ConsoleLogger", () => {
  let logger: ConsoleLogger;
  let mockStream: MockTTYStream;
  beforeEach(() => {
    jest.resetAllMocks();
    mockStream = new MockTTYStream();
  });

  function expectStreamWrite(line: string) {
    expect(mockStream.currentOutput).toEqual(`${line}\n`);
  }

  describe("pretty format", () => {
    beforeEach(() => {
      logger = new ConsoleLogger({
        stream: mockStream as any,
        color: false,
        timestamp: false,
        progressNoTTYOutput: true,
      });
    });

    it("log debug", () => {
      logger.debug("This is some debug");
      expectStreamWrite("debug   | This is some debug");
    });

    it("log verbose", () => {
      logger.verbose("This is some verbose");
      expectStreamWrite("verbose | This is some verbose");
    });

    it("log information", () => {
      logger.info("This is some information");
      expectStreamWrite("info    | This is some information");
    });

    it("log warning", () => {
      logger.trackWarning({
        code: "TestWarning",
        message: "This is some warning",
      });
      expectStreamWrite("warning | TestWarning | This is some warning");
    });

    it("log error", () => {
      logger.trackError({
        code: "TestError",
        message: "This is some error",
      });
      expectStreamWrite("error   | TestError | This is some error");
    });

    it("log fatal", () => {
      logger.fatal("This is some fatal error");
      expectStreamWrite("fatal   | This is some fatal error");
    });

    it("log progress", async () => {
      const progress = logger.startProgress("MyProgress");
      progress.update({ current: 10, total: 200 });
      await new Promise((r) => setTimeout(r, 100));
      expect(mockStream.currentOutput).toEqual("MyProgress [==--------------------------------------] 5% | 10/200");
      progress.update({ current: 20, total: 200 });
      await new Promise((r) => setTimeout(r, 100));
      expect(mockStream.currentOutput).toEqual("MyProgress [====------------------------------------] 10% | 20/200");
      progress.stop();
    });

    it("append logs above progress", async () => {
      const progress = logger.startProgress("MyProgress");
      progress.update({ current: 10, total: 200 });
      await new Promise((r) => setTimeout(r, 100));
      expect(mockStream.currentOutput).toEqual("MyProgress [==--------------------------------------] 5% | 10/200");
      logger.info("Something happening during progress");
      await new Promise((r) => setTimeout(r, 100));
      expect(mockStream.currentOutput).toEqual(
        "info    | Something happening during progress\nMyProgress [==--------------------------------------] 5% | 10/200",
      );
      progress.stop();
    });
  });

  describe("json format", () => {
    beforeEach(() => {
      logger = new ConsoleLogger({
        stream: mockStream as any,
        format: "json",
        timestamp: false,
      });
    });

    it("log debug", () => {
      logger.debug("This is some debug");
      expectStreamWrite('{"level":"debug","message":"This is some debug"}');
    });

    it("log warning", () => {
      logger.trackWarning({
        code: "TestWarning",
        message: "This is some warning",
      });
      expectStreamWrite('{"level":"warning","code":"TestWarning","message":"This is some warning"}');
    });
  });
});
