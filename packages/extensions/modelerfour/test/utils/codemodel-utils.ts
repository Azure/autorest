export interface NamedItem {
  language: {
    default: {
      name: string;
    };
  };
}

export function findByName<T extends NamedItem>(name: string, items: T[] | undefined): T | undefined {
  return items && items.find((x) => x.language.default.name === name);
}

export function assertSchema(
  schemaName: string,
  schemaList: Array<any> | undefined,
  accessor: (schema: any) => any,
  expected: any,
) {
  expect(schemaList).not.toBeFalsy();

  // We've already asserted, but make the compiler happy
  if (schemaList) {
    const schema = findByName(schemaName, schemaList);
    expect(schema).not.toBeFalsy();
    expect(accessor(schema)).toEqual(expected);
  }
}
