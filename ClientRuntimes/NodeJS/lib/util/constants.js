// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

// Expose 'HeaderConstants'.
exports = module.exports;

var Constants = {
  /**
  * Buffer width used to copy data to output streams.
  *
  * @const
  * @type {string}
  */
  BUFFER_COPY_LENGTH: 8 * 1024,

  /**
  * Default client request time out
  */
  DEFAULT_CLIENT_REQUEST_TIMEOUT : 5 * 60 * 1000,

  /**
  * Specifies HTTP.
  *
  * @const
  * @type {string}
  */
  HTTP: 'http:',

  /**
  * Specifies HTTPS.
  *
  * @const
  * @type {string}
  */
  HTTPS: 'https:',

  /**
  * Specifies HTTP Proxy.
  *
  * @const
  * @type {string}
  */
  HTTP_PROXY: 'HTTP_PROXY',

  /**
  * Specifies HTTPS Proxy.
  *
  * @const
  * @type {string}
  */
  HTTPS_PROXY: 'HTTPS_PROXY',

  HttpConstants: {
    /**
    * Http Verbs
    *
    * @const
    * @enum {string}
    */
    HttpVerbs: {
      PUT: 'PUT',
      GET: 'GET',
      DELETE: 'DELETE',
      POST: 'POST',
      MERGE: 'MERGE',
      HEAD: 'HEAD',
      PATCH: 'PATCH'
    },

    /**
    * Response codes.
    *
    * @const
    * @enum {int}
    */
    HttpResponseCodes: {
      Ok: 200,
      Created: 201,
      Accepted: 202,
      NoContent: 204,
      PartialContent: 206,
      BadRequest: 400,
      Unauthorized: 401,
      Forbidden: 403,
      NotFound: 404,
      Conflict: 409,
      LengthRequired: 411,
      PreconditionFailed: 412
    }
  },

  /**
  * Defines constants for use with HTTP headers.
  */
  HeaderConstants: {
    /**
    * The Authorization header.
    *
    * @const
    * @type {string}
    */
    AUTHORIZATION: 'authorization'
  }
};

module.exports = Constants;
