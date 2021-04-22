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
  total: number;
  longRunning: number;
  pageable: number;
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
