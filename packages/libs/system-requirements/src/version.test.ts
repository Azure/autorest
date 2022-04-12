import { validateVersionRequirement, versionIsSatisfied } from "./version";

describe("System requirements version", () => {
  describe("versionIsSatisfied", () => {
    describe("when requirement is >=", () => {
      it("is valid match exactly", () => {
        expect(versionIsSatisfied("3.1.0", ">=3.1.0")).toBe(true);
        expect(versionIsSatisfied("1.2.3", ">=1.2.3")).toBe(true);
      });

      it("is invalid if version is less", () => {
        expect(versionIsSatisfied("3.0.0", ">=3.1.2")).toBe(false);
        expect(versionIsSatisfied("3.1.0", ">=3.1.2")).toBe(false);
      });

      it("is valid if version is more", () => {
        expect(versionIsSatisfied("3.2.0", ">=3.1.2")).toBe(true);
        expect(versionIsSatisfied("3.1.3", ">=3.1.2")).toBe(true);
      });

      it("is valid if version contains tags and is more", () => {
        expect(versionIsSatisfied("3.1.2-beta.19", ">=3.1.2")).toBe(true);
        expect(versionIsSatisfied("3.2.0-rc.1", ">=3.1.2")).toBe(true);
      });

      it("is invalid if version contains tags but is less", () => {
        expect(versionIsSatisfied("3.1.0-beta.19", ">=3.1.2")).toBe(false);
        expect(versionIsSatisfied("3.0.0-rc.1", ">=3.1.2")).toBe(false);
        expect(versionIsSatisfied("2.0.0-alpha.1", ">=3.1.2")).toBe(false);
      });
    });
  });

  describe("validateVersionRequirement", () => {
    it("is valid when version has beta flags", () => {
      const resolution = { name: "test", command: "test" };
      expect(validateVersionRequirement(resolution, "3.1.0-rc.2", { version: ">=3.1.0" })).toEqual({
        command: "test",
        name: "test",
      });
      expect(validateVersionRequirement(resolution, "3.1.0-beta.19", { version: ">=3.1.0" })).toEqual({
        command: "test",
        name: "test",
      });
    });
  });
});
