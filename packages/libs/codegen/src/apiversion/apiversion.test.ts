import { toSemver } from "./apiversion";

describe("ApiVersion", () => {
  it("to semver conversion", () => {
    const actual1 = toSemver("6.2.0.9");
    const expected1 = "6.2.0";
    expect(actual1).toEqual(expected1);

    const actual2 = toSemver("2017-10-12");
    const expected2 = "2017.10.12";
    expect(actual2).toEqual(expected2);

    const actual3 = toSemver("2017-10-12-preview");
    const expected3 = "2017.10.12-preview";
    expect(actual3).toEqual(expected3);

    const actual4 = toSemver("v2.1");
    const expected4 = "2.1.0";
    expect(actual4).toEqual(expected4);

    const actual5 = toSemver("1.1");
    const expected5 = "1.1.0";
    expect(actual5).toEqual(expected5);

    const actual6 = toSemver("2016-07-01.3.1");
    const expected6 = "1467331200000.3.1";
    expect(actual6).toEqual(expected6);

    const actual7 = toSemver("1.3.1");
    const expected7 = "1.3.1";
    expect(actual7).toEqual(expected7);

    const actual8 = toSemver("2020-09");
    const expected8 = "2020.9.0";
    expect(actual8).toEqual(expected8);

    const actual9 = toSemver("2020-09-preview");
    const expected9 = "2020.9.0-preview";
    expect(actual9).toEqual(expected9);

    expect(toSemver("v1")).toEqual("1.0.0");

    expect(toSemver("3.0-preview.1")).toEqual("3.0.0-preview.1");
  });
});
