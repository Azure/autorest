// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

// Module dependencies.
var request = require('request');
var url = require('url');
var util = require('util');
var xml2js = require('xml2js');
var events = require('events');
var _ = require('underscore');

var azureutil = require('../util/util');

var ServiceSettings = require('./servicesettings');
var Constants = require('../util/constants');
var ServiceClientConstants = require('./serviceclientconstants');

var HeaderConstants = Constants.HeaderConstants;
var HttpResponseCodes = Constants.HttpConstants.HttpResponseCodes;
var Logger = require('../diagnostics/logger');

var UserAgentFilter = require('./filters/useragentfilter');
var ProxyFilter = require('./filters/proxyfilter');

var Service = require('./service');
var requestPipeline = require('../http/request-pipeline');

/**
* Creates a new ServiceClient object.
* @ignore
* @constructor
* @param {string} host                    The host for the service.
* @param {object} authenticationProvider  The authentication provider object (e.g. sharedkey / sharedkeytable / sharedaccesssignature).
*/
function ServiceClient(host, authenticationProvider) {
  ServiceClient['super_'].call(this);

  this._initDefaultFilter();

  if (host) {
    this.setHost(host);
  } else if (!this.protocol) {
    this.protocol = ServiceSettings.DEFAULT_PROTOCOL;
  }

  this.authenticationProvider = authenticationProvider;
  this.logger = new Logger(Logger.LogLevels.INFO);

  if (process.env.AZURE_ENABLE_STRICT_SSL !== undefined) {
    this.strictSSL = process.env.AZURE_ENABLE_STRICT_SSL === 'true';
  } else {
    var nodeVersion = azureutil.getNodeVersion();

    if (nodeVersion.major > 0 || nodeVersion.minor > 8 || (nodeVersion.minor === 8 && nodeVersion.patch >= 18)) {
      this.strictSSL = true;
    } else {
      this.strictSSL = false;
    }
  }

  this._setDefaultProxy();

  this.xml2jsSettings = ServiceClient._getDefaultXml2jsSettings();
}

util.inherits(ServiceClient, events.EventEmitter);

/**
* Gets the default xml2js settings.
* @ignore
* @return {object} The default settings
*/
ServiceClient._getDefaultXml2jsSettings = function() {
  var xml2jsSettings = _.clone(xml2js.defaults['0.2']);
  xml2jsSettings.normalize = false;
  xml2jsSettings.trim = false;
  xml2jsSettings.attrkey = Constants.XML_METADATA_MARKER;
  xml2jsSettings.charkey = Constants.XML_VALUE_MARKER;
  xml2jsSettings.explicitArray = false;

  return xml2jsSettings;
};

/**
* Sets a host for the service.
* @ignore
* @param {string}     host                              The host for the service.
*/
ServiceClient.prototype.setHost = function (host) {
  var parsedHost = ServiceSettings.parseHost(host);
  this.host = parsedHost.hostname;

  if (parsedHost.port) {
    this.port = parsedHost.port;
  } else if (parsedHost.protocol === Constants.HTTPS) {
    this.port = 443;
  } else {
    this.port = 80;
  }

  if (!this.protocol) {
    this.protocol = parsedHost.protocol;
  }
};

/**
* Performs a REST service request through HTTP expecting an input stream.
* @ignore
*
* @param {WebResource} webResource                      The webresource on which to perform the request.
* @param {string}      outputData                       The outgoing request data as a raw string.
* @param {object}      [options]                        The request options.
* @param {int}         [options.timeoutIntervalInMs]    The timeout interval, in milliseconds, to use for the request.
* @param {function}    callback                         The chunked response callback function.
*/
ServiceClient.prototype.performChunkedRequest = function (webResource, outputData, options, chunkedCallback, callback) {
  this._performRequest(webResource, { outputData: outputData }, options, callback, chunkedCallback);
};

/**
* Performs a REST service request through HTTP expecting an input stream.
* @ignore
*
* @param {WebResource} webResource                      The webresource on which to perform the request.
* @param {string}      outputData                       The outgoing request data as a raw string.
* @param {object}      [options]                        The request options.
* @param {int}         [options.timeoutIntervalInMs]    The timeout interval, in milliseconds, to use for the request.
* @param {function}    callback                         The response callback function.
*/
ServiceClient.prototype.performRequest = function (webResource, outputData, options, callback) {
  this._performRequest(webResource, { outputData: outputData }, options, callback);
};

/**
* Performs a REST service request through HTTP expecting an input stream.
* @ignore
*
* @param {WebResource} webResource                      The webresource on which to perform the request.
* @param {Stream}      outputStream                     The outgoing request data as a stream.
* @param {object}      [options]                        The request options.
* @param {int}         [options.timeoutIntervalInMs]    The timeout interval, in milliseconds, to use for the request.
* @param {function}    callback                         The response callback function.
*/
ServiceClient.prototype.performRequestOutputStream = function (webResource, outputStream, options, callback) {
  this._performRequest(webResource, { outputStream: outputStream }, options, callback);
};

/**
* Performs a REST service request through HTTP expecting an input stream.
* @ignore
*
* @param {WebResource} webResource                      The webresource on which to perform the request.
* @param {string}      outputData                       The outgoing request data as a raw string.
* @param {Stream}      inputStream                      The ingoing response data as a stream.
* @param {object}      [options]                        The request options.
* @param {int}         [options.timeoutIntervalInMs]    The timeout interval, in milliseconds, to use for the request.
* @param {function}    callback                         The response callback function.
*/
ServiceClient.prototype.performRequestInputStream = function (webResource, outputData, inputStream, options, callback) {
  this._performRequest(webResource, { outputData: outputData, inputStream: inputStream }, options, callback);
};

/**
* Performs a REST service request through HTTP.
* @ignore
*
* @param {WebResource} webResource                      The webresource on which to perform the request.
* @param {object}      body                             The request body.
* @param {string}      [body.outputData]                The outgoing request data as a raw string.
* @param {Stream}      [body.outputStream]              The outgoing request data as a stream.
* @param {Stream}      [body.inputStream]               The ingoing response data as a stream.
* @param {object}      [options]                        The request options.
* @param {int}         [options.timeoutIntervalInMs]    The timeout interval, in milliseconds, to use for the request.
* @param {function}    callback                         The response callback function.
* @param {function}    chunkedCallback                  The chunked response callback function.
*/
ServiceClient.prototype._performRequest = function (webResource, body, options, callback, chunkedCallback) {
  var self = this;
  self._buildRequestOptions(webResource, body, options, function (err, requestOptions) {
    if (err) {
      callback({ error: err, response: null }, function (requestOptions, finalCallback) {
        finalCallback(requestOptions);
      });
    } else {
      UserAgentFilter._tagRequest(requestOptions, self.userAgent);

      self.logger.log(Logger.LogLevels.DEBUG, 'REQUEST OPTIONS:\n' + util.inspect(requestOptions));

      var operation = function (finalRequestOptions, next) {
        self.logger.log(Logger.LogLevels.DEBUG, 'FINAL REQUEST OPTIONS:\n' + util.inspect(finalRequestOptions));

        var processResponseCallback = function (error, response, body, cb) {
          var responseObject;

          if (error) {
            responseObject = { error: error, response: null };
          } else if (cb) {
            responseObject = { error: null, response: ServiceClient._buildResponse(false, response.body, response.headers, response.statusCode, response.md5) };
          } else {
            responseObject = self._processResponse(webResource, response);
          }

          if (cb) {
            cb(responseObject, next);
          } else {
            callback(responseObject, next);
          }
        };

        if (body && body.outputData) {
          finalRequestOptions.body = body.outputData;
        }

        if (!finalRequestOptions.agent) {
          finalRequestOptions.agent = self.agent;
        }

        var buildRequest = function (headersOnly) {
          // Build request (if body was set before, request will process immediately, if not it'll wait for the piping to happen)
          var requestStream;
          if (headersOnly || chunkedCallback) {
            requestStream = request(finalRequestOptions);
            requestStream.on('error', processResponseCallback);
            requestStream.on('response', function (response) {
              if (chunkedCallback) {
                response.on('data', function (chunk) {
                  response.body = chunk;
                  processResponseCallback(null, response, null, chunkedCallback);
                });
              }

              response.on('end', function () {
                processResponseCallback(null, response);
              });
            });
          } else {
            requestStream = request(finalRequestOptions, processResponseCallback);
          }

          // Workaround to avoid request from potentially setting unwanted (rejected) headers by the service
          var oldEnd = requestStream.end;
          requestStream.end = function () {
            if (finalRequestOptions.headers['content-length']) {
              requestStream.headers['content-length'] = finalRequestOptions.headers['content-length'];
            } else if (requestStream.headers['content-length']) {
              delete requestStream.headers['content-length'];
            }

            oldEnd.call(requestStream);
          };

          // Bubble events up
          requestStream.on('response', function (response) {
            self.emit('response', response);
          });

          return requestStream;
        };

        // Pipe any input / output streams
        if (body && body.inputStream) {
          buildRequest(true).pipe(body.inputStream);
        } else if (body && body.outputStream) {
          var sendUnchunked = function () {
            var size = finalRequestOptions.headers['content-length'] ?
              finalRequestOptions.headers['content-length'] :
              Constants.BlobConstants.MAX_SINGLE_UPLOAD_BLOB_SIZE_IN_BYTES;

            var concatBuf = new Buffer(size);
            var index = 0;

            body.outputStream.on('data', function (d) {
              d.copy(concatBuf, index, 0, d.length);
              index += d.length;
            }).on('end', function () {
              var requestStream = buildRequest();
              requestStream.write(concatBuf);
              requestStream.end();
            });
          };

          var sendStream = function () {
            // NOTE: workaround for an unexpected EPIPE exception when piping streams larger than 29 MB
            if (finalRequestOptions.headers['content-length'] && finalRequestOptions.headers['content-length'] < 29 * 1024 * 1024) {
              body.outputStream.pipe(buildRequest());
            } else {
              sendUnchunked();
            }
          };

          if (!body.outputStream.readable) {
            // This will wait until we know the readable stream is actually valid before piping
            body.outputStream.on('open', function () {
              sendStream();
            });
          } else {
            sendStream();
          }

          // This catches any errors that happen while creating the readable stream (usually invalid names)
          body.outputStream.on('error', function (error) {
            processResponseCallback(error);
          });
        } else {
          buildRequest();
        }
      };

      // The filter will do what it needs to the requestOptions and will provide a
      // function to be handled after the reply
      self.filter(requestOptions, function (postFiltersRequestOptions, nextPostCallback) {
        // If there is a filter, flow is:
        // filter -> operation -> process response -> next filter
        operation(postFiltersRequestOptions, nextPostCallback);
      });
    }
  });
};

/**
* Builds the request options to be passed to the http.request method.
* @ignore
* @param {WebResource} webResource The webresource where to build the options from.
* @param {object}      options     The request options.
* @param {function(error, requestOptions)}  callback  The callback function.
* @return {undefined}
*/
ServiceClient.prototype._buildRequestOptions = function (webResource, body, options, callback) {
  var self = this;

  if (!webResource.headers || webResource.headers[HeaderConstants.CONTENT_TYPE] === undefined) {
    webResource.withHeader(HeaderConstants.CONTENT_TYPE, '');
  } else if (webResource.headers && webResource.headers[HeaderConstants.CONTENT_TYPE] === null) {
    delete webResource.headers[HeaderConstants.CONTENT_TYPE];
  }

  if (!webResource.headers || webResource.headers[HeaderConstants.CONTENT_LENGTH] === undefined) {
    if (body && body.outputData) {
      webResource.withHeader(HeaderConstants.CONTENT_LENGTH, Buffer.byteLength(body.outputData, 'UTF8'));
    } else if (webResource.headers[HeaderConstants.CONTENT_LENGTH] === undefined) {
      webResource.withHeader(HeaderConstants.CONTENT_LENGTH, 0);
    }
  } else if (webResource.headers && webResource.headers[HeaderConstants.CONTENT_LENGTH] === null) {
    delete webResource.headers[HeaderConstants.CONTENT_LENGTH];
  }

  webResource.withHeader(HeaderConstants.ACCEPT_CHARSET_HEADER, 'UTF-8');
  webResource.withHeader(HeaderConstants.HOST_HEADER, self.host);

  // Sets the request url in the web resource.
  this._setRequestUrl(webResource);

  // Now that the web request is finalized, sign it
  this.authenticationProvider.signRequest(webResource, function (error) {
    var requestOptions = null;

    if (!error) {
      var targetUrl = {
        protocol: self._isHttps() ? 'https' : 'http',
        hostname: self.host,
        port: self.port,
        pathname: webResource.path,
        query: webResource.queryString
      };

      if (webResource.authentication && webResource.authentication.user) {
        targetUrl.auth = util.format('%s:%s', webResource.authentication.user, webResource.authentication.pass);
      }

      requestOptions = {
        url: url.format(targetUrl),
        method: webResource.method,
        headers: webResource.headers,
        strictSSL: self.strictSSL
      };

      if (webResource.authentication && webResource.authentication.keyvalue && webResource.authentication.certvalue) {
        requestOptions.key = webResource.authentication.keyvalue;
        requestOptions.cert = webResource.authentication.certvalue;
      }

      if (self.proxy) {
        ProxyFilter.setAgent(requestOptions, self.proxy);
      }

      if(options) {
        //set encoding of response data. If set to null, the body is returned as a Buffer
        requestOptions.encoding = options.responseEncoding;
        //set client request time out
        if(options.clientRequestTimeout && options.clientRequestTimeout > 0) {
          requestOptions.timeout = options.clientRequestTimeout;
        } else {
          requestOptions.timeout = Constants.DEFAULT_CLIENT_REQUEST_TIMEOUT;
        }
      }
    }

    callback(error, requestOptions);
  });
};

/**
* Process the response.
* @ignore
*
* @param {WebResource} webResource  The web resource that made the request.
* @param {Response}    response     The response object.
* @return The normalized responseObject.
*/
ServiceClient.prototype._processResponse = function (webResource, response) {
  var self = this;

  var rsp;
  var responseObject;

  if (webResource.validResponse(response.statusCode)) {
    rsp = ServiceClient._buildResponse(true, response.body, response.headers, response.statusCode, response.md5);

    if (webResource.rawResponse) {
      responseObject = { error: null, response: rsp };
    } else {
      responseObject = { error: null, response: ServiceClient._parseResponse(rsp, self.xml2jsSettings) };
    }
  } else {
    rsp = ServiceClient._parseResponse(ServiceClient._buildResponse(false, response.body, response.headers, response.statusCode, response.md5), self.xml2jsSettings);

    if (response.statusCode < 400 || response.statusCode >= 500) {
      this.logger.log(Logger.LogLevels.DEBUG,
          'ERROR code = ' + response.statusCode + ' :\n' + util.inspect(rsp.body));
    }

    var errorBody = rsp.body;
    if (!errorBody) {
      var code = Object.keys(HttpResponseCodes).filter(function (name) {
        if (HttpResponseCodes[name] === rsp.statusCode) {
          return name;
        }
      });

      errorBody = { error: { code: code[0] } };
    }

    var normalizedError = ServiceClient._normalizeError(errorBody, response);
    responseObject = { error: normalizedError, response: rsp };
  }

  this.logger.log(Logger.LogLevels.DEBUG, 'RESPONSE:\n' + util.inspect(responseObject));

  return responseObject;
};

/**
* Associate a filtering operation with this ServiceClient. Filtering operations
* can include logging, automatically retrying, etc. Filter operations are objects
* that implement a method with the signature:
*
*     "function handle (requestOptions, next)".
*
* After doing its preprocessing on the request options, the method needs to call
* "next" passing a callback with the following signature:
* signature:
*
*     "function (returnObject, finalCallback, next)"
*
* In this callback, and after processing the returnObject (the response from the
* request to the server), the callback needs to either invoke next if it exists to
* continue processing other filters or simply invoke finalCallback otherwise to end
* up the service invocation.
*
* @param {Object} filter The new filter object.
* @return {ServiceClient} A new service client with the filter applied.
*/
ServiceClient.prototype.withFilter = function (newFilter) {
  if (azureutil.objectIsNull(newFilter) || !newFilter.handle) {
    // TODO: this is a point in time filter solution while the API that uses the new filters
    // is not public. 
    if (_.isFunction(newFilter) && newFilter.length === 3 && this.pipeline) {
      this.pipeline = requestPipeline.createWithSink(this.pipeline, newFilter);
      return this;
    } else {
      throw new Error('Incorrect filter object.');
    }
  } else {
    // Create a new object with the same members as the current service
    var derived = _.clone(this);

    // If the current service has a filter, merge it with the new filter
    // (allowing us to effectively pipeline a series of filters)
    var parentFilter = this.filter;
    var mergedFilter = newFilter;
    if (parentFilter !== undefined) {
      // The parentFilterNext is either the operation or the nextPipe function generated on a previous merge
      // Ordering is [f3 pre] -> [f2 pre] -> [f1 pre] -> operation -> [f1 post] -> [f2 post] -> [f3 post]
      mergedFilter = function (originalRequestOptions, parentFilterNext) {
        newFilter.handle(originalRequestOptions, function (postRequestOptions, newFilterCallback) {
          // handle parent filter pre and get Parent filter post
          var next = function (postPostRequestOptions, parentFilterCallback) {
            // The parentFilterNext is the filter next to the merged filter.
            // For 2 filters, that'd be the actual operation.
            parentFilterNext(postPostRequestOptions, function (responseObject, responseCallback, finalCallback) {
              parentFilterCallback(responseObject, finalCallback, function (postResponseObject) {
                newFilterCallback(postResponseObject, responseCallback, finalCallback);
              });
            });
          };

          parentFilter(postRequestOptions, next);
        });
      };
    }

    // Store the filter so it can be applied in performRequest
    derived.filter = mergedFilter;
    return derived;
  }
};

/*
* Builds a response object with normalized key names.
* @ignore
*
* @param {Bool}     isSuccessful    Boolean value indicating if the request was successful
* @param {Object}   body            The response body.
* @param {Object}   headers         The response headers.
* @param {int}      statusCode      The response status code.
* @param {string}   md5             The response's content md5 hash.
* @return {Object} A response object.
*/
ServiceClient._buildResponse = function (isSuccessful, body, headers, statusCode, md5) {
  return {
    isSuccessful: isSuccessful,
    statusCode: statusCode,
    body: body,
    headers: headers,
    md5: md5
  };
};

/**
* Parses a server response body from XML into a JS object.
* This is done using the xml2js library.
* @ignore
*
* @param {object} response The response object with a property "body" with a XML string content.
* @return {object} The same response object with the body part as a JS object instead of a XML string.
*/
ServiceClient._parseResponse = function (response, xml2jsSettings) {
  function parseJSON(body) {
    return JSON.parse(azureutil.removeBOM(body.toString()));
  }

  function parseXml(body) {
    var parsed;
    var parser = new xml2js.Parser(xml2jsSettings);
    parser.parseString(azureutil.removeBOM(body.toString()), function (err, parsedBody) {
      if (err) { throw err; }
      else { parsed = parsedBody; }
    });

    return parsed;
  }

  function parseStringError(body) {
    body = azureutil.removeBOM(body.toString());

    var splitBody = body.split(/:|\r\n/g);
    var locateSplitBody = splitBody.map(function (el) {
      return el.toLowerCase();
    });

    var codeIndex = locateSplitBody.indexOf('code');
    if (codeIndex !== -1) {
      var resultObject = {
        code: splitBody[codeIndex + 1].trim()
      };

      var detailIndex = locateSplitBody.indexOf('detail');
      if (detailIndex !== -1) {
        resultObject.detail = splitBody[detailIndex + 1].trim();
      }

      return { error: resultObject };
    } else {
      throw new Error('Invalid string error');
    }
  }

  function parseUncategorizedResponse() {
    try {
      // Start by assuming XML
      response.body = parseXml(response.body);
    } catch (e) {
      // Try string if XML failed to parse a valid error xml
      try {
        response.body = parseStringError(response.body);
      } catch (e) {
        // Do nothing
      }
    }
  }

  if (response.body && Buffer.byteLength(response.body.toString()) > 0) {
    if (response.headers && response.headers['content-type']) {
      var contentType = response.headers['content-type'].toLowerCase();
      if (contentType.indexOf('application/json') !== -1) {
        try {
          response.body = parseJSON(response.body);
        } catch (e) {
          response.body = { error: e };
        }
      } else if (contentType.indexOf('application/xml') !== -1 || contentType.indexOf('application/atom+xml') !== -1) {
        try {
          response.body = parseXml(response.body);
        } catch (e) {
          response.body = { error: e };
        }
      } else {
        // Some Azure replies return response with incorrect content-type. E.g. 'text/plain' to a XML response in RDFE getNetworkConfig
        parseUncategorizedResponse();
      }
    } else {
      // Some azure errors are returned without content-type header (e.g. table storage TableAlreadyExists)
      // In this scenario they can either be XML or pure strings
      parseUncategorizedResponse();
    }
  }

  return response;
};

/**
* Sets the webResource's requestUrl based on the service client settings.
* @ignore
*
* @param {WebResource} webResource The web resource where to set the request url.
* @return {undefined}
*/
ServiceClient.prototype._setRequestUrl = function (webResource) {
  // Normalize the path
  webResource.path = this._getPath(webResource.path);

  // Build the full request url
  webResource.uri = url.format({
    protocol: this.protocol,
    hostname: this.host,
    port: this.port,
    pathname: webResource.path,
    query: webResource.queryString
  });
};

/**
* Retrieves the normalized path to be used in a request.
* It adds a leading "/" to the path in case
* it's not there before.
* @ignore
* @param {string} path The path to be normalized.
* @return {string} The normalized path.
*/
ServiceClient.prototype._getPath = function (path) {
  if (path === null || path === undefined) {
    path = '/';
  } else if (path.indexOf('/') !== 0) {
    path = '/' + path;
  }

  return path;
};

/**
* Initializes the default filter.
* This filter is responsible for chaining the pre filters request into the operation and, after processing the response,
* pass it to the post processing filters. This method should only be invoked by the ServiceClient constructor.
* @ignore
*
* @return {undefined}
*/
ServiceClient.prototype._initDefaultFilter = function () {
  this.filter = function (requestOptions, nextPreCallback) {
    if (nextPreCallback) {
      // Handle the next pre callback and pass the function to be handled as post call back.
      nextPreCallback(requestOptions, function (returnObject, finalCallback, nextPostCallback) {
        if (nextPostCallback) {
          nextPostCallback(returnObject);
        } else if (finalCallback) {
          finalCallback(returnObject);
        }
      });
    }
  };
};

/**
* Retrieves the metadata headers from the response headers.
* @ignore
*
* @param {object} headers The metadata headers.
* @return {object} An object with the metadata headers (without the "x-ms-" prefix).
*/
ServiceClient.prototype.parseMetadataHeaders = function (headers) {
  var metadata = {};

  if (!headers) {
    return metadata;
  }

  for (var header in headers) {
    if (header.indexOf(HeaderConstants.PREFIX_FOR_STORAGE_METADATA) === 0) {
      var key = header.substr(HeaderConstants.PREFIX_FOR_STORAGE_METADATA.length, header.length - HeaderConstants.PREFIX_FOR_STORAGE_METADATA.length);
      metadata[key] = headers[header];
    }
  }

  return metadata;
};

/**
* Gets the value of the environment variable for is emulated.
*
* @return {bool} True if the service client is running on an emulated environment; false otherwise.
*/
ServiceClient.isEmulated = function () {
  return (!azureutil.objectIsNull(process.env[ServiceClientConstants.EnvironmentVariables.EMULATED]) &&
    process.env[ServiceClientConstants.EnvironmentVariables.EMULATED] !== 'false');
};

// Other functions

/**
* Processes the error body into a normalized error object with all the properties lowercased.
*
* Error information may be returned by a service call with additional debugging information:
* http://msdn.microsoft.com/en-us/library/windowsazure/dd179382.aspx
*
* Table services returns these properties lowercased, example, "code" instead of "Code". So that the user
* can always expect the same format, this method lower cases everything.
*
* @ignore
*
* @param {Object} error The error object as returned by the service and parsed to JSON by the xml2json.
* @return {Object} The normalized error object with all properties lower cased.
*/
ServiceClient._normalizeError = function (error, response) {
  if (azureutil.objectIsString(error)) {
    return new Error(error);
  } else if (error) {
    var normalizedError = {};

    var odataErrorFormat = !!error['odata.error'];
    var errorProperties = error.Error || error.error || error['odata.error'] || error;
    if (odataErrorFormat) {
      for (var property in errorProperties) {
        if (errorProperties.hasOwnProperty(property)) {
          var value = null;
          if (property === Constants.ODATA_ERROR_MESSAGE && 
             !azureutil.objectIsString(errorProperties[Constants.ODATA_ERROR_MESSAGE])) {
            if (errorProperties[Constants.ODATA_ERROR_MESSAGE][Constants.ODATA_ERROR_MESSAGE_VALUE]) {
              value = errorProperties[Constants.ODATA_ERROR_MESSAGE][Constants.ODATA_ERROR_MESSAGE_VALUE];
            }
            else {
              value = 'missing value in the message property of the odata error format';
            }
          }
          else {
            value = errorProperties[property];
          }
          normalizedError[property.toLowerCase()] = value;
        }
      }
    }
    else {
      for (var property in errorProperties) {
        if (errorProperties.hasOwnProperty(property)) {
          var value = null;
          if (property !== Constants.XML_METADATA_MARKER) {
            if (errorProperties[property] && errorProperties[property][Constants.XML_VALUE_MARKER]) {
              value = errorProperties[property][Constants.XML_VALUE_MARKER];
            } 
            else {
              value = errorProperties[property];
            }
            normalizedError[property.toLowerCase()] = value;
          }
        }
      }
    }
    var errorMessage = normalizedError.code;
    if (normalizedError.detail) {
      errorMessage += ' - ' + normalizedError.detail;
    }

    if (response) {
      if (response.statusCode) {
        normalizedError.statusCode = response.statusCode;
      }

      if (response.headers && response.headers['x-ms-request-id']) {
        normalizedError.requestId = response.headers['x-ms-request-id'];
      }
    }

    var errorObject = new Error(errorMessage);
    _.extend(errorObject, normalizedError);
    return errorObject;
  }

  return null;
};

/*
* Sets proxy object specified by caller.
*
* @param {object}   proxy       proxy to use for tunneling
*                               {
*                                host: hostname
*                                port: port number
*                                proxyAuth: 'user:password' for basic auth
*                                headers: {...} headers for proxy server
*                                key: key for proxy server
*                                ca: ca for proxy server
*                                cert: cert for proxy server
*                               }
*                               if null or undefined, clears proxy
*/
ServiceClient.prototype.setProxy = function (proxy) {
  if (proxy) {
    this.proxy = proxy;
  } else {
    this.proxy = null;
  }
};

/*
 * Sets the http agent specified by caller.
 *
 * @param {object}   agent       http agent
 */
ServiceClient.prototype.setAgent = function (agent) {
  this.agent = agent;
};

/**
* Sets the service host default proxy from the environment.
* Can be overridden by calling _setProxyUrl or _setProxy
*
*/
ServiceClient.prototype._setDefaultProxy = function () {
  var proxyUrl = Service._loadEnvironmentProxyValue();
  if (proxyUrl) {
    var parsedUrl = url.parse(proxyUrl);
    if (!parsedUrl.port) {
      parsedUrl.port = 80;
    }
    this.setProxy(parsedUrl);
  } else {
    this.setProxy(null);
  }
};

/**
* Determines if the current protocol is https.
* @ignore
*
* @return {Bool} True if the protocol is https; false otherwise.
*/
ServiceClient.prototype._isHttps = function () {
  return (this.protocol.toLowerCase() === Constants.HTTPS);
};

module.exports = ServiceClient;