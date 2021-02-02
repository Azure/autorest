import { Style } from "./formatter";

const testMapping = (convert: (x: string) => string, mapping: Array<[string, string]>) => {
  for (const [input, expected] of mapping) {
    it(`convert ${input} -> ${expected}`, () => {
      expect(convert(input)).toEqual(expected);
    });
  }
};

describe("Formatter", () => {
  // Disabled some test as part of reverting change https://github.com/Azure/perks/pull/148
  describe("snake_case", () => {
    testMapping((x) => Style.snake(x), [
      ["snake_case", "snake_case"],
      ["snakeCase", "snake_case"],
      ["SnakeCase", "snake_case"],
      ["snake_Case", "snake_case"],
      ["Snake", "snake"],
      ["s_nake", "s_nake"],
      // ["SNaKEr", "sna_ker"],
      // ["SNaKE", "sna_ke"],
      ["s_na_k_er", "s_na_k_er"],
      // ["snakeSnakECase", "snake_snak_ecase"],
      ["MikhailGorbachevUSSR", "mikhail_gorbachev_ussr"],
      ["MAX_of_MLD", "max_of_mld"],
      ["someSQLConnection", "some_sql_connection"],
      // ["diskMBpsReadWrite", "disk_mbps_read_write"],
      // ["instanceIDs", "instance_ids"],
    ]);
  });

  describe("PascalCase", () => {
    testMapping((x) => Style.pascal(x), [
      ["pascal", "Pascal"],
      ["pascalCase", "PascalCase"],
      ["PascalCase", "PascalCase"],
      ["pascalcase", "Pascalcase"],
      ["Pascalcase", "Pascalcase"],
      ["pascal_case", "PascalCase"],
      ["pascal_case_", "PascalCase"],
      ["_pascal_case", "PascalCase"],
      ["___pascal____case6666", "PascalCase6666"],
      ["MAX_of_MLD", "MaxOfMld"],
      ["someSQLConnection", "SomeSqlConnection"],
      // ["diskMBpsReadWrite", "DiskMbpsReadWrite"],
      // ["instanceIDs", "InstanceIds"],
    ]);
  });
});
