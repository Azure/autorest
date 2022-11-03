export function transformValue(value: string | number | boolean) {
  if (typeof value === "string") {
    return `"${value}"`;
  }

  return value;
}
