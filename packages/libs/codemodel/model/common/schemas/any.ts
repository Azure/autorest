import { Schema } from '../schema';
import { SchemaType } from '../schema-type';
import { DeepPartial } from '@azure-tools/codegen';

export interface AnySchema extends Schema {
}

export class AnySchema extends Schema implements AnySchema {
  constructor(description: string, objectInitializer?: DeepPartial<AnySchema>) {
    super('any', description, SchemaType.Any);
    this.apply(objectInitializer);
  }
}
