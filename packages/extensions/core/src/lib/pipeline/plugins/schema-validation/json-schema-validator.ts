import { CompilePosition, DataHandle, JsonPath, parseJsonPointer } from "@azure-tools/datastore";
import Ajv, { AnySchemaObject, ErrorObject } from "ajv";
import ajvErrors from "ajv-errors";
import { Position } from "source-map";

export interface ValidationError extends ErrorObject {
  path: JsonPath;
}

export interface PositionedValidationError extends ValidationError {
  position: Position;
}

export abstract class JsonSchemaValidator {
  protected ajv: Ajv;

  public constructor() {
    this.ajv = new Ajv({ allErrors: true, strict: false });
    ajvErrors(this.ajv, {});
  }

  public abstract get schema(): AnySchemaObject;

  public validate(spec: unknown): ValidationError[] {
    const validate = this.ajv.compile(this.schema);
    const valid = validate(spec);
    if (valid || !validate.errors) {
      return [];
    } else {
      return condenseErrors(validate.errors).map((x) => ({ ...x, path: parseJsonPointer(x.dataPath) }));
    }
  }

  public async validateFile(file: DataHandle): Promise<PositionedValidationError[]> {
    const spec = await file.ReadObject();
    const errors = this.validate(spec);
    const mappedErrors = errors.map((x) => extendWithPosition(x, file));
    return Promise.all(mappedErrors);
  }
}

async function extendWithPosition(error: ValidationError, file: DataHandle): Promise<PositionedValidationError> {
  return {
    ...error,
    position: await CompilePosition({ path: error.path }, file),
  };
}

const IGNORE_ERROR = new Set(["if"]);
export function condenseErrors(errors: ErrorObject[]): ErrorObject[] {
  const tree: any = {};

  function countFor(dataPath: string, message: string) {
    return tree[dataPath][message].length;
  }

  for (const err of errors.filter((x) => !IGNORE_ERROR.has(x.keyword))) {
    const { dataPath, message } = err;
    if (!message) {
      continue;
    }
    if (tree[dataPath] && tree[dataPath][message]) {
      tree[dataPath][message].push(err);
    } else if (tree[dataPath]) {
      tree[dataPath][message] = [err];
    } else {
      tree[dataPath] = {
        [message]: [err],
      };
    }
  }

  const dataPaths = Object.keys(tree);

  return dataPaths.reduce((res: ValidationError[], path) => {
    const messages = Object.keys(tree[path]);

    const mostFrequentMessageNames = messages.reduce(
      (obj, msg) => {
        const count = countFor(path, msg);

        if (count > obj.max) {
          return {
            messages: [msg],
            max: count,
          };
        } else if (count === obj.max) {
          obj.messages.push(msg);
          return obj;
        } else {
          return obj;
        }
      },
      { max: 0, messages: [] as string[] },
    ).messages;

    const mostFrequentMessages = mostFrequentMessageNames.map((name) => tree[path][name]);

    const condensedErrors = mostFrequentMessages.map((messages) => {
      return messages.reduce((prev: any, err: ValidationError) => {
        const obj = Object.assign({}, prev, {
          params: mergeParams(prev.params, err.params),
        });

        if (!prev.params && !err.params) {
          delete obj.params;
        }
        return obj;
      });
    });

    return res.concat(condensedErrors);
  }, []);
}

function mergeParams(objA: any = {}, objB: any = {}) {
  if (!objA && !objB) {
    return undefined;
  }

  const res: any = {};

  for (const k in objA) {
    if (Object.prototype.hasOwnProperty.call(objA, k)) {
      res[k] = arrayify(objA[k]);
    }
  }

  for (const k in objB) {
    if (Object.prototype.hasOwnProperty.call(objB, k)) {
      if (res[k]) {
        const curr = res[k];
        res[k] = curr.concat(arrayify(objB[k]));
      } else {
        res[k] = arrayify(objB[k]);
      }
    }
  }

  return res;
}

function arrayify(thing: any) {
  if (thing === undefined || thing === null) {
    return thing;
  }
  if (Array.isArray(thing)) {
    return thing;
  } else {
    return [thing];
  }
}
