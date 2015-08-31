var express = require('express');
var router = express.Router();
var util = require('util');

var report = function(coverage, azurecoverage) {

  router.get('/', function(req, res, next) {
    res.status(200).end(JSON.stringify(coverage));
  });

  router.get('/azure', function(req, res, next) {
    res.status(200).end(JSON.stringify(azurecoverage));
  });
}

report.prototype.router = router;

module.exports = report;
