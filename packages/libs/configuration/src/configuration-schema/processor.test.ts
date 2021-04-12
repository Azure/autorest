import { ConfigurationSchemaProcessor, ProcessingErrorCode } from "./processor";

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

describe("ConfigurationProcessor", () => {
  it("validate simple number", () => {
    const result = processor.processConfiguration({
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
    const result = processor.processConfiguration({
      simpleNumber: 123,
    });

    expect(result).toEqual({
      value: { simpleNumber: 123 },
    });
  });

  it("validate simple boolean", () => {
    const result = processor.processConfiguration({
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
    const result = processor.processConfiguration({
      simpleBoolean: true,
    });

    expect(result).toEqual({
      value: { simpleBoolean: true },
    });
  });

  it("validate simple string", () => {
    const result = processor.processConfiguration({
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
    const result = processor.processConfiguration({
      simpleString: "foo",
    });

    expect(result).toEqual({
      value: { simpleString: "foo" },
    });
  });

  it("validate simple enum not correct type", () => {
    const result = processor.processConfiguration({
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
    const result = processor.processConfiguration({
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
    const result = processor.processConfiguration({
      simpleEnum: "two",
    });

    expect(result).toEqual({
      value: { simpleEnum: "two" },
    });
  });

  describe("Array validation", () => {
    it("validate array of number", () => {
      const result = processor.processConfiguration({
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
      const result = processor.processConfiguration({
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
      const result = processor.processConfiguration({
        numberArray: [123, 456],
      });

      expect(result).toEqual({
        value: { numberArray: [123, 456] },
      });
    });

    it("process array of number (passing single value)", () => {
      const result = processor.processConfiguration({
        numberArray: 123,
      });

      expect(result).toEqual({
        value: { numberArray: [123] },
      });
    });
  });

  describe("Dictionary validation", () => {
    it("validate dictionary of number", () => {
      const result = processor.processConfiguration({
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
      const result = processor.processConfiguration({
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
      const result = processor.processConfiguration({
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
      const result = processor.processConfiguration({
        nested: { nestedNumber: 123 },
      });

      expect(result).toEqual({
        value: { nested: { nestedNumber: 123 } },
      });
    });
  });
});
