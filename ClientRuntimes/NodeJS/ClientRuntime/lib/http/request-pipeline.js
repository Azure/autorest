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

'use strict';

var request = require('request');
var through = require('through');
var duplexer = require('duplexer');

var _ = require('underscore');

//
// Request pipelines are functions that allow you to
// add filters to modify requests and responses
// before / after the actual HTTP request.
//

/**
 *
 * create a new http client pipeline that ends with a call to the
 * request library using the given sink function to actually make
 * the http request.
 *
 * @return function(request, callback) - function to make a request.
 *
 */
function createWithSink(sink) {
  var pipeline = sink;

  // The function that actually runs the pipeline. It starts simple
  function runFilteredRequest(options, callback) {
    return pipeline(options, callback);
  }

  function makeFilteredPipeline(filter) {
    var currentPipeline = pipeline;
    return function (options, callback) {
      return filter(options, currentPipeline, callback);
    };
  }

  // Add 'add' method so we can add filters.
  runFilteredRequest.add = function () {
    _.each(arguments, function (filter) {
      pipeline = makeFilteredPipeline(filter);
    });
  };

  // Add verb specific helper methods
  var verbs = ['get', 'post', 'delete', 'put', 'merge', 'head'];
  verbs.forEach(function (method) {
    runFilteredRequest[method] = (function (m) {
      return function (options, callback) {
        options.method = m;
        return pipeline(options, callback);
      };
    })(method.toUpperCase());
  });

  // If user passed any other parameters, assume they're filters
  // and add them.
  for(var i = 1; i < arguments.length; ++i) {
    runFilteredRequest.add(arguments[i]);
  }

  return runFilteredRequest;
}

/**
 * This function acts as the final sink for a request, actually
 * going out over the wire.
 *
 * @private
 * @param options The request to perform
 * @param callback function(err, result, response, body) callback function that
 * will be called at completion of the request.
 */

function requestLibrarySink(options, callback) {
  if (options.headersOnly) {
    var requestStream = request(options);
    requestStream.on('error', function (err) {
      return callback(err);
    });

    requestStream.on('response', function (response) {
      requestStream.on('end', function () {
        return callback(null, response);
      });
    });

    return requestStream;
  } else {
    return request(options, function (err, response, body) {
      if (err) { return callback(err); }
      return callback(null, response, body);
    });
  }
}

/**
 *
 * create a new http client pipeline that ends with a call to the
 * request library.
 *
 * @return function(request, callback) - function to make a request.
 *
 */
function create() {
  if (arguments.length === 0 ) {
    return createWithSink(requestLibrarySink);
  }
  // User passed filters to add to the pipeline.
  // build up appropriate arguments and call createWithSink
  return createWithSink.apply(null, [requestLibrarySink].concat(_.toArray(arguments)));
}

/**
 * Create a new filter that's a combination of all the filters
 * given on the arguments list.
 *
 * @param {varargs} filters to run. First filter in the list is closest to
 * the sink, so last to run before the request, first to run on the response:
 * exactly the same as if you called pipeline.add or passed the list to
 * pipeline.create.
 *
 * @return the new filter.
 */
function createCompositeFilter() {
  var filter = arguments[0];

  function makePairedFilter(filterA, filterB) {
    return function(options, next, callback) {
      function callFilterA(o, cb) {
        return filterA(o, next, cb);
      }
      return filterB(options, callFilterA, callback);
    };
  }

  for(var i = 1; i < arguments.length; ++i) {
    filter = makePairedFilter(filter, arguments[i]);
  }
  return filter;
}

/**
 * Creates an interim stream which can be returned to the
 * caller synchronously, so that async operations can still
 * hook up to the streaming output afterwards. Used when
 * filters need to do async work before they can call the rest
 * of the pipeline.
 *
 * @param setPipe function(input, output)
 *    this function is invoked synchronously, to pass the two
 *    underlying streams. input should be piped to the result of
 *    the next filter. The result of next should be piped to output.
 *    It's common to pause the input stream to prevent data loss
 *    before actually returning the real stream to hook up to.
 *
 * @returns a duplex stream that writes to the input stream and
 * produces data from the output stream.
 */
function interimStream(setPipes) {
  var input = through();
  var output = through();
  var duplex = duplexer(input, output);
  setPipes(input, output);
  return duplex;
}

_.extend(exports, {
  create: create,
  createWithSink: createWithSink,
  createCompositeFilter: createCompositeFilter,
  interimStream: interimStream
});