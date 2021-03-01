/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Value } from "./value";
import { DeepPartial } from "@azure-tools/codegen";
import { Schema } from "./schema";
import { Property } from "./property";

export enum ImplementationLocation {
  /** should be exposed as a method parameter in the operation */
  Method = "Method",

  /** should be exposed as a client parameter (not exposed in the operation directly) */
  Client = "Client",

  /** should be used as input to constructing the context of the client (ie, 'profile') */
  Context = "Context",
}

/** a definition of an discrete input for an operation */
export interface Parameter extends Value {
  /** suggested implementation location for this parameter */
  implementation?: ImplementationLocation;

  /** When a parameter is flattened, it will be left in the list, but marked hidden (so, don't generate those!) */
  flattened?: boolean;

  /** When a parameter is grouped into another, this will tell where the parameter got grouped into. */
  groupedBy?: Parameter;

  /**
   * If this parameter is only part of the body request(for multipart and form bodies.)
   */
  isPartialBody?: boolean;
}

export class Parameter extends Value implements Parameter {
  constructor(name: string, description: string, schema: Schema, initializer?: DeepPartial<Parameter>) {
    super(name, description, schema);

    this.apply(initializer);
  }
}

export interface VirtualParameter extends Parameter {
  /** the original body parameter that this parameter is in effect replacing  */
  originalParameter: Parameter;

  /** if this parameter is for a nested property, this is the path of properties it takes to get there */
  pathToProperty: Array<Property>;

  /** the target property this virtual parameter represents */
  targetProperty: Property;
}

export class VirtualParameter extends Parameter implements VirtualParameter {
  constructor(name: string, description: string, schema: Schema, initializer?: DeepPartial<VirtualParameter>) {
    super(name, description, schema);

    this.applyWithExclusions(["schema"], initializer);
  }
}

export function isVirtualParameter(parameter: Parameter): parameter is VirtualParameter {
  return !!(<any>parameter).originalParameter;
}
