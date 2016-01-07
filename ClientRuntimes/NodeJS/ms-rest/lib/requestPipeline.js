// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

var request = require('request');
var through = require('through');
var duplexer = require('duplexer');
var _ = require('underscore');
var Constants = require('./constants');

var HttpVerbs = Constants.HttpVerbs;

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
exports.createWithSink = function(sink) {
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
  var verbs = _.values(HttpVerbs);
  verbs.forEach(function (method) {
    runFilteredRequest[method] = (function (m) {
      return function (options, callback) {
        options.method = m;
        return pipeline(options, callback);
      };
    })(method);
  });

  // If user passed any other parameters, assume they're filters
  // and add them.
  for(var i = 1; i < arguments.length; ++i) {
    runFilteredRequest.add(arguments[i]);
  }

  return runFilteredRequest;
};

/**
 * This function acts as the final sink for a request, actually
 * going out over the wire.
 *
 * @param {Object} [requestOptions] - The request options
 * {@link https://github.com/request/request#requestoptions-callback Options doc}
 *
 * @private
 * @param options The request to perform
 * @param callback function(err, result, response, body) callback function that
 * will be called at completion of the request.
 */
exports.requestLibrarySink = function (requestOptions) {

  return function (options, callback) {
    request = request.defaults(requestOptions);
    var requestStream;
    var bodyStream;
    if (options.headersOnly) {
      var requestHeaderStream = request(options);
      requestHeaderStream.on('error', function (err) {
        return callback(err);
      });
      requestHeaderStream.on('response', function (response) {
        requestHeaderStream.on('end', function () {
          return callback(null, response);
        });
      });      
      return requestHeaderStream;
    } else if (options.streamedResponse) {
      if (options.body && typeof options.body.pipe === 'function') {
        bodyStream = options.body;
        options.body = null;
        requestStream = bodyStream.pipe(request(options));
      } else {
        requestStream = request(options);
      }
      requestStream.on('error', function (err) {
        return callback(err);
      });
      requestStream.on('response', function (response) {
        return callback(null, response);
      });
      return requestStream;
    } else if (options.body && typeof options.body.pipe === 'function') {
      bodyStream = options.body;
      options.body = null;
      return bodyStream.pipe(request(options, function (err, response, body) {
        if (err) { return callback(err); }
        return callback(null, response, body);
      }));
    } else {
      return request(options, function (err, response, body) {
        if (err) { return callback(err); }
        return callback(null, response, body);
      });
    }
  };
};

/**
 *
 * create a new http client pipeline that ends with a call to the
 * request library.
 *
 * @param {Object} [requestOptions] - The request options
 * {@link https://github.com/request/request#requestoptions-callback Options doc}
 *
 * @return function(request, callback) - function to make a request.
 *
 */
exports.create = function (requestOptions) {
  return function () {
    if (arguments.length === 0) {
      return exports.createWithSink(exports.requestLibrarySink);
    }
    // User passed filters to add to the pipeline.
    // build up appropriate arguments and call exports.createWithSink
    return exports.createWithSink.apply(null, [exports.requestLibrarySink(requestOptions)].concat(_.toArray(arguments)));
  };
};

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
exports.createCompositeFilter = function() {
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
};

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
exports.interimStream = function(setPipes) {
  var input = through();
  var output = through();
  var duplex = duplexer(input, output);
  setPipes(input, output);
  return duplex;
};

exports = module.exports;