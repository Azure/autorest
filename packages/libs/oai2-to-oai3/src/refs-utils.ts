/**
 * Clean a component name to use in OpenAPI 3.0.
 * @param name OpenApi2.0 component name to clean.
 */
export const cleanElementName = (name: string) => name.replace(/\$|\[|\]/g, "_");

/**
 * Convert a OpenAPI 2.0 $ref to its OpenAPI3.0 version.
 * @param oai2Ref OpenAPI 2.0 reference.
 * @param resolveReference Optional resolver for references pointing to a different file.
 * @param currentFile Current file to use with `resolveReference`
 */
export const convertOai2RefToOai3 = async (oai2Ref: string): Promise<string> => {
  const [file, path] = oai2Ref.split("#");
  return `${file}#${convertOai2PathToOai3(path)}`;
};

const oai2PathMapping = {
  "/definitions/": "/components/schemas/",
  "/parameters/": "/components/parameters/",
  "/responses/": "/components/responses/",
};

export const convertOai2PathToOai3 = (path: string) => {
  const parsed = parseOai2Path(path);
  if (parsed === undefined) {
    throw new Error(`Cannot parse ref path ${path} it is not a supported ref pattern.`);
  }

  return `${oai2PathMapping[parsed.basePath]}${cleanElementName(parsed.componentName)}`;
};

export interface Oai2ParsedPath {
  basePath: keyof typeof oai2PathMapping;
  componentName: string;
}

/**
 * Extract the component name and base path of a reference path.
 * @example
 *  parseOai2Path("/parameters/Foo") -> {basePath: "/parameters/", componentName: "Foo"}
 *  parseOai2Path("/definitions/Foo") -> {basePath: "/definitions/", componentName: "Foo"}
 *  parseOai2Path("/unknown/Foo") -> undefined
 */
export const parseOai2Path = (path: string): Oai2ParsedPath | undefined => {
  for (const oai2Path of Object.keys(oai2PathMapping)) {
    if (path.startsWith(oai2Path)) {
      return {
        basePath: oai2Path as keyof typeof oai2PathMapping,
        componentName: path.slice(oai2Path.length),
      };
    }
  }
  return undefined;
};

export interface Oai2ParsedRef extends Oai2ParsedPath {
  file: string;
  path: string;
}

/**
 * Parse a OpenAPI2.0 json ref.
 * @example
 *  parseOai2Path("#/parameters/Foo") -> {file: "", path: "/parameters/Foo", basePath: "/parameters/", componentName: "Foo"}
 *  parseOai2Path("bar.json#/definitions/Foo") -> {file: "bar.json", path: "/definitions/Foo", basePath: "/definitions/", componentName: "Foo"}
 *  parseOai2Path("other.json#/unknown/Foo") -> undefined
 */
export const parseOai2Ref = (oai2Ref: string): Oai2ParsedRef | undefined => {
  const [file, path] = oai2Ref.split("#");
  const parsedPath = parseOai2Path(path);
  if (parsedPath === undefined) {
    return undefined;
  }
  return {
    file,
    path,
    ...parsedPath,
  };
};
