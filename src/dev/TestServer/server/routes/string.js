var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')

var string = function (coverage) {
  var base64String    = "YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjQ=";
  var base64UrlString = "YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw";
  var RefColorConstant = { "field1": "Sample String" };
  
  router.put('/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null') {
      if (req.body === undefined || (req.body && Object.keys(req.body).length === 0 && req.headers['content-length'] === '0')) {
        coverage['putStringNull']++;
        res.status(200).end(); 
      } else {
        utils.send400(res, next, "Did not like null req '" + util.inspect(req) + "'");
      }
    } else if (req.params.scenario === 'empty') {
      if (req.body !== '') {
        utils.send400(res, next, "Did not like empty req '" + util.inspect(req.body) + "'");
      } else {
        coverage['putStringEmpty']++;
        res.status(200).end();
      }
    } else if (req.params.scenario === 'mbcs') {
      if (req.body !== constants.MULTIBYTE_BUFFER_BODY) {
        utils.send400(res, next, "Did not like mbcs req '" + util.inspect(req.body) + "'");
      } else {
        coverage['putStringMultiByteCharacters']++;
        res.status(200).end();
      }
    } else if (req.params.scenario === 'whitespace') {
      if (req.body !== '    Now is the time for all good men to come to the aid of their country    ') {
        utils.send400(res, next, "Did not like whitespace req '" + util.inspect(req.body) + "'");
      } else {
        coverage['putStringWithLeadingAndTrailingWhitespace']++;
        res.status(200).end();
      }
    } else if (req.params.scenario === 'base64UrlEncoding') {
      if (req.body !== 'YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw') {
        utils.send400(res, next, "Did not like base64url req '" + util.inspect(req.body) + "'");
      } else {
        coverage['putStringBase64UrlEncoded']++;
        res.status(200).end();
      }
    }
    else {
      utils.send400(res, next, 'Request path must contain true or false');
    }
  });
  
  router.get('/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null') {
      coverage['getStringNull']++;
      res.status(200).end();
    } else if (req.params.scenario === 'base64Encoding') {
      coverage['getStringBase64Encoded']++;
      res.status(200).end('"' + base64String + '"');
    } else if (req.params.scenario === 'base64UrlEncoding') {
      coverage['getStringBase64UrlEncoded']++;
      res.status(200).end('"' + base64UrlString + '"');
    } else if (req.params.scenario === 'nullBase64UrlEncoding') {
      coverage['getStringNullBase64UrlEncoding']++;
      res.status(200).end();
    } else if (req.params.scenario === 'notProvided') {
      coverage['getStringNotProvided']++;
      res.status(200).end();
    } else if (req.params.scenario === 'empty') {
      coverage['getStringEmpty']++;
      res.status(200).end('\"\"');
    } else if (req.params.scenario === 'mbcs') {
      coverage['getStringMultiByteCharacters']++;
      res.status(200).end('"' + constants.MULTIBYTE_BUFFER_BODY + '"');
    } else if (req.params.scenario === 'whitespace') {
      coverage['getStringWithLeadingAndTrailingWhitespace']++;
      res.status(200).end('\"    Now is the time for all good men to come to the aid of their country    \"');
    } else {
      res.status(400).end('Request path must contain null or empty or mbcs or whitespace');
    }

  });
  
  router.get('/enum/notExpandable', function (req, res, next) {
    coverage['getEnumNotExpandable']++;
    res.status(200).end('"red color"');
  });
  
  router.put('/enum/notExpandable', function (req, res, next) {
    if (req.body === 'red color') {
      coverage['putEnumNotExpandable']++;
      res.status(200).end();
    } else {
      utils.send400(res, next, "Did not like enum in the req '" + util.inspect(req.body) + "'");
    }
	});
   router.get('/enum/notExpandable', function (req, res, next) {
    coverage['getEnumNotExpandable']++;
    res.status(200).end('"red color"');
  });
  
  router.put('/enum/notExpandable', function (req, res, next) {
    if (req.body === 'red color') {
      coverage['putEnumNotExpandable']++;
      res.status(200).end();
    } else {
      utils.send400(res, next, "Did not like enum in the req '" + util.inspect(req.body) + "'");
    }
    });
    router.get('/enum/Referenced', function (req, res, next) {
      coverage['getEnumReferenced']++;
      res.status(200).end('"red color"');
    });

    router.put('/enum/Referenced', function (req, res, next) {
      if (req.body === 'red color') {
        coverage['putEnumReferenced']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like enum in the req '" + util.inspect(req.body) + "'");
      }
    });
    router.get('/enum/ReferencedConstant', function (req, res, next) {
      coverage['getEnumReferencedConstant']++;
      res.status(200).end(JSON.stringify(RefColorConstant));
    });

    router.put('/enum/ReferencedConstant', function (req, res, next) {
      if (req.body.ColorConstant === 'green-color') {
        coverage['putEnumReferencedConstant']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like constant in the req '" + util.inspect(req.body) + "'");
      }
    });
}

string.prototype.router = router;

module.exports = string;