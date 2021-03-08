import { CancellationToken, DataStore } from "@azure-tools/datastore";

import { parse } from "./literate-yaml";
import { AutorestError } from "../logging";

describe("SyntaxValidation", () => {
  let errors: AutorestError[];

  const logger = {
    verbose: jest.fn(),
    info: jest.fn(),
    fatal: jest.fn((x) => errors.push(x)),
    trackError: jest.fn((x) => errors.push(x)),
    trackWarning: jest.fn((x) => errors.push(x)),
  };

  beforeEach(() => {
    errors = [];
    logger.trackError.mockClear();
  });

  const parseRaw = async (value: string) => {
    const dataStore = new DataStore({} as CancellationToken);
    const uri = "mem:///config";
    const h = await dataStore.WriteData(uri, value, "input-file", [uri]);
    const result = await parse(logger, h, dataStore.getDataSink());
    return await result.ReadObject();
  };

  describe("when configuration is raw yaml/json", () => {
    it("parse successfully when yaml is valid", async () => {
      expect(await parseRaw("{ a: 3 }")).toEqual({ a: 3 });
      expect(await parseRaw("a: 3")).toEqual({ a: 3 });
      expect(await parseRaw("a: [3]")).toEqual({ a: [3] });
    });

    it("reports errors if the yaml is invalid", async () => {
      await expect(() => parseRaw("{ a: 3 ")).rejects.toThrow(Error);
      expect(errors).not.toHaveLength(0);
      await expect(() => parseRaw("\n\n [{ a: '3 }]")).rejects.toThrow(Error);
    });

    it("report position for error", async () => {
      await expect(() => parseRaw("{ a: 3 ")).rejects.toThrow(Error);
      expect(errors[0].source?.[0].position).toEqual({ line: 1, column: 8 });
    });
  });
});
