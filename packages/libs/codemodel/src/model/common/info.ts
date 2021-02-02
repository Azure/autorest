/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Extensions } from "./extensions";
import { uri } from "./uri";
import { ExternalDocumentation } from "./external-documentation";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

export type email = string;

/** contact information  */
export interface Contact extends Extensions {
  name?: string;
  url?: uri; // uriref
  email?: email; // email
}

/** license information  */
export interface License extends Extensions {
  /** the nameof the license */
  name: string;

  /** an uri pointing to the full license text */
  url?: uri; // uriref
}

/** code model information */
export interface Info extends Extensions {
  /** the title of this service. */
  title: string;

  /** a text description of the service  */
  description?: string;

  /** an uri to the terms of service specified to access the service */
  termsOfService?: uri; // uriref

  /** contact information for the service */
  contact?: Contact;

  /** license information for th service */
  license?: License;

  /** External Documentation  */
  externalDocs?: ExternalDocumentation;
}

export class Contact extends Initializer implements Contact {
  constructor(initializer?: DeepPartial<Contact>) {
    super();
    this.apply(initializer);
  }
}

export class Info extends Initializer implements Info {
  constructor(public title: string, initializer?: DeepPartial<Info>) {
    super();
    this.apply(initializer);
  }
}

export class License extends Initializer implements License {
  constructor(public name: string, initializer?: DeepPartial<License>) {
    super();
    this.apply(initializer);
  }
}
