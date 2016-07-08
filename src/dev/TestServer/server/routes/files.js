var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils');

var files = function (coverage) {

  coverage['FileStreamNonempty'] = 0;
  router.get('/stream/nonempty', function (req, res, next) {
    console.log("inside router\n");
    coverage['FileStreamNonempty']++;
    var options = {
      root: __dirname,
    };
    res.sendFile('sample.png', options);
  });
  
  coverage['FileStreamVeryLarge'] = 0;
  router.get('/stream/verylarge', function (req, res, next) {
    console.log("inside router\n");
    coverage['FileStreamVeryLarge']++;
    
    var megabytes = 3000;
    var oneMegabyteBuffer = new Buffer(1024 * 1024);
    for (var i = 0; i < megabytes; i++) {
      res.write(oneMegabyteBuffer);
    }
    res.end();
  });

  coverage['FileStreamEmpty'] = 0;
  router.get('/stream/empty', function (req, res, next) {
    console.log("inside router\n");
    coverage['FileStreamEmpty']++;
    res.status(200).end();
  });
}

files.prototype.router = router;

module.exports = files;