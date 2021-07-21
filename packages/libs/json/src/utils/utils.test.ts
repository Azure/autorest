import { validateJson } from "./utils";

describe("JsonUtils", () => {
  describe("validate json is valid", () => {
    it("returns undefined when valid", () => {
      expect(validateJson("{}")).toBeUndefined();
    });

    it("returns error when invalid", () => {
      expect(validateJson(`{ missingQuote": 123}`)).toEqual({ message: "Unexpected token m in JSON", position: 2 });
    });
  });
});
