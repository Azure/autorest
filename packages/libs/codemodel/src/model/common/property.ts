import { uid } from "./uid";

import { Initializer, DeepPartial } from "@azure-tools/codegen";
import { Value } from "./value";
import { Schema } from "./schema";

/** a property is a child value in an object */
export interface Property extends Value {
  /** if the property is marked read-only (ie, not intended to be sent to the service) */
  readOnly?: boolean;

  /** the wire name of this property */
  serializedName: string;

  /** when a property is flattened, the property will be the set of serialized names to get to that target property.
   *
   * If flattenedName is present, then this property is a flattened property.
   *
   * (ie, ['properties','name'] )
   *
   */
  flattenedNames?: Array<string>;

  // add addtional x-ms-mutability-style-stuff
  /** if this property is used as a discriminator for a polymorphic type */
  isDiscriminator?: boolean;
}

export class Property extends Value implements Property {
  constructor(name: string, description: string, schema: Schema, initializer?: DeepPartial<Property>) {
    super(name, description, schema);

    this.serializedName = name;
    this.applyWithExclusions(["schema"], initializer);
  }
}
