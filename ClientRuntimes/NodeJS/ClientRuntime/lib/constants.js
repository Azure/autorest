// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var Constants = {
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

exports = module.exports = Constants;
