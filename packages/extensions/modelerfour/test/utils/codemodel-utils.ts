export function findByName<T>(name: string, items: Array<T> | undefined): T | undefined {
  return (items && items.find((i) => (<any>i).language.default.name === name)) || undefined;
}
