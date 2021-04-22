import { AutorestLogger } from "@autorest/common";
import { ConfigurationSchemaProcessor, ProcessingErrorCode } from "./processor";
import { RawConfiguration } from "./types";

const TestSchema = {
  simpleNumber: {
    type: "number",
  },
  simpleBoolean: {
    type: "boolean",
  },
  simpleString: {
    type: "string",
  },
  simpleEnum: {
    type: "string",
    enum: ["one", "two", "three"],
  },
  numberArray: {
    type: "number",
    array: true,
  },
  numberDict: {
    type: "number",
    dictionary: true,
  },
  nested: {
    nestedNumber: { type: "number" },
  },
} as const;

const processor = new ConfigurationSchemaProcessor(TestSchema);

const logger: AutorestLogger = {
  info: jest.fn(),
  verbose: jest.fn(),
  fatal: jest.fn(),
  trackWarning: jest.fn(),
  trackError: jest.fn(),
};

function processConfig(config: RawConfiguration<typeof TestSchema>) {
  return processor.processConfiguration(config, { logger });
}

describe("ConfigurationProcessor", () => {
  it("validate simple number", () => {
    const result = processConfig({
      simpleNumber: "fooNotANumber" as any,
    });

    expect(result).toEqual({
      errors: [
        {
          code: ProcessingErrorCode.InvalidType,
          message: "Expected a number but got string: 'fooNotANumber'",
          path: ["simpleNumber"],
        },
      ],
    });
  });

  it("process simple number", () => {
    const result = processConfig({
      simpleNumber: 123,
    });

    expect(result).toEqual({
      value: { simpleNumber: 123 },
    });
  });

  it("validate simple boolean", () => {
    const result = processConfig({
      simpleBoolean: "fooNotABoolean" as any,
    });

    expect(result).toEqual({
      errors: [
        {
          code: ProcessingErrorCode.InvalidType,
          message: "Expected a boolean but got string: 'fooNotABoolean'",
          path: ["simpleBoolean"],
        },
      ],
    });
  });

  it("process simple boolean", () => {
    const result = processConfig({
      simpleBoolean: true,
    });

    expect(result).toEqual({
      value: { simpleBoolean: true },
    });
  });

  it("validate simple string", () => {
    const result = processConfig({
      simpleString: 123 as any,
    });

    expect(result).toEqual({
      errors: [
        {
          code: ProcessingErrorCode.InvalidType,
          message: "Expected a string but got number: 123",
          path: ["simpleString"],
        },
      ],
    });
  });

  it("process simple string", () => {
    const result = processConfig({
      simpleString: "foo",
    });

    expect(result).toEqual({
      value: { simpleString: "foo" },
    });
  });

  it("validate simple enum not correct type", () => {
    const result = processConfig({
      simpleEnum: 123 as any,
    });

    expect(result).toEqual({
      errors: [
        {
          code: ProcessingErrorCode.InvalidType,
          message: "Expected a string but got number: 123",
          path: ["simpleEnum"],
        },
      ],
    });
  });

  it("validate simple enum match one of allowed values", () => {
    const result = processConfig({
      simpleEnum: "four" as any,
    });

    expect(result).toEqual({
      errors: [
        {
          code: ProcessingErrorCode.InvalidType,
          message: "Expected a value to be in ['one','two','three'] but got 'four'",
          path: ["simpleEnum"],
        },
      ],
    });
  });

  it("process simple enum", () => {
    const result = processConfig({
      simpleEnum: "two",
    });

    expect(result).toEqual({
      value: { simpleEnum: "two" },
    });
  });

  describe("Array validation", () => {
    it("validate array of number", () => {
      const result = processConfig({
        numberArray: ["notANumber" as any, 456],
      });

      expect(result).toEqual({
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: "Expected a number but got string: 'notANumber'",
            path: ["numberArray", "0"],
          },
        ],
      });
    });

    it("validate array of number passed as single value", () => {
      const result = processConfig({
        numberArray: "notANumber" as any,
      });

      expect(result).toEqual({
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: "Expected a number but got string: 'notANumber'",
            path: ["numberArray"],
          },
        ],
      });
    });

    it("process array of number", () => {
      const result = processConfig({
        numberArray: [123, 456],
      });

      expect(result).toEqual({
        value: { numberArray: [123, 456] },
      });
    });

    it("process array of number (passing single value)", () => {
      const result = processConfig({
        numberArray: 123,
      });

      expect(result).toEqual({
        value: { numberArray: [123] },
      });
    });
  });

  describe("Dictionary validation", () => {
    it("validate dictionary of number", () => {
      const result = processConfig({
        numberDict: {
          foo: "notANumber" as any,
        },
      });

      expect(result).toEqual({
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: "Expected a number but got string: 'notANumber'",
            path: ["numberDict", "foo"],
          },
        ],
      });
    });

    it("process dictionary of number", () => {
      const result = processConfig({
        numberDict: {
          foo: 123,
          bar: 456,
        },
      });

      expect(result).toEqual({
        value: {
          numberDict: {
            foo: 123,
            bar: 456,
          },
        },
      });
    });
  });

  describe("Nestsed config validation", () => {
    it("validate nested entry", () => {
      const result = processConfig({
        nested: { nestedNumber: "notANumber" as any },
      });

      expect(result).toEqual({
        errors: [
          {
            code: ProcessingErrorCode.InvalidType,
            message: "Expected a number but got string: 'notANumber'",
            path: ["nested", "nestedNumber"],
          },
        ],
      });
    });

    it("process a nested entry", () => {
      const result = processConfig({
        nested: { nestedNumber: 123 },
      });

      expect(result).toEqual({
        value: { nested: { nestedNumber: 123 } },
      });
    });
  });
});
