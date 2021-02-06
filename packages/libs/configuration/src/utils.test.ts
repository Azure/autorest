import { type } from "os";
import { arrayOf } from "./utils";

describe("Utils", () => {
  describe("arrayOf", () => {
    it("returns as it is if its already an array", () => {
      expect(arrayOf(["abc", "def"])).toEqual(["abc", "def"]);
    });

    it("wraps it in an array if it is only a primitive type", () => {
      expect(arrayOf("abc")).toEqual(["abc"]);
      expect(arrayOf(123)).toEqual([123]);
      expect(arrayOf(true)).toEqual([true]);
    });

    it("wraps it in an array if it is only an object type", () => {
      expect(arrayOf({ foo: "bar" })).toEqual([{ foo: "bar" }]);
    });

    // This test is just for types. The processed input should be assignable to the output variable.
    it("has correct type", () => {
      const input: string[] | string | undefined = <any>"foo";
      const output: string[] = arrayOf(input);
      expect(output).toBeDefined();
    });
  });
});
