import { HttpMethod } from "@azure-tools/openapi";

export type StatGroup = { [key: string]: Stat };
export type Stat = number | StatGroup;

/**
 * Statistics around schemas in files.
 */
export interface SchemaStats extends StatGroup {
  namedSchema: number;
  namedSchemaInline: number;
  anonymous: number;
  total: number;
}

export interface OperationStats extends StatGroup {
  /**
   * Total number of operations(Number of path * operation per path)
   */
  total: number;

  /**
   * Number of paths in the spec
   */
  paths: number;

  /**
   * Number of operation that are defined as Long running operations.
   */
  longRunning: number;

  /**
   * Number of operation that are defined as pageable.
   */
  pageable: number;

  methods: Required<Record<HttpMethod, number>>;
}

export interface OpenAPIPerSpecStats extends StatGroup {
  schemas: SchemaStats;
  operations: SchemaStats;
}

export interface AutorestStats extends StatGroup {
  openapi: {
    inputCount: number;
    specs: { [spec: string]: OpenAPIPerSpecStats };
    overall: StatGroup;
  } & StatGroup;
}
