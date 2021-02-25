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
