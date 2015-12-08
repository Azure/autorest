var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var parameterGrouping = function(coverage) {
  coverage['postParameterGroupingOptionalParameters'] = 0;
  coverage['postParameterGroupingRequiredParameters'] = 0;
  coverage['postParameterGroupingMultipleParameterGroups'] = 0;
  coverage['postParameterGroupingSharedParameterGroupObject'] = 0;

    router.post('/postRequired/:path', function(req, res, next) {
        if (req.body === 1234 && req.params.path === 'path' && 
            (req.get('customHeader') === 'header' || req.get('customHeader') === undefined) && 
            (req.query['query'] === '21' || req.query['query'] === undefined)) {
            coverage['postParameterGroupingRequiredParameters']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the values in the req. Body: " + util.inspect(req.body) + 
                ", Path: " + req.params.path + ", customHeader: " + req.get('customHeader') + ", query: " + req.query['query']);
        }
    });

    router.post('/postOptional', function(req, res, next) {
        if ((req.get('customHeader') === 'header' || req.get('customHeader') === undefined) && 
            (req.query['query'] === '21' || req.query['query'] === undefined)) {
            coverage['postParameterGroupingOptionalParameters']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the values in the req. header: " + req.get('customHeader') + ", query: " + req.query['query']);
        }
    });
    
    router.post('/postMultipleParameterGroups', function(req, res, next) {
        if ((req.get('headerOne') === 'header' || req.get('headerOne') === undefined) && 
            (req.query['queryOne'] === '21' || req.query['queryOne'] === undefined) && 
            (req.query['headerTwo'] === 'header2' || req.query['headerTwo'] === undefined) && 
            (req.query['queryTwo'] === '42' || req.query['queryTwo'] === undefined)
            ) {
            coverage['postParameterGroupingMultipleParameterGroups']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the values in the req. headerOne: " + req.get('headerOne') + ", queryOne: " + req.query['queryOne'] + 
              ", headerTwo: " + req.get('headerTwo') + ", queryTwo: " + req.get('queryTwo'));
        }
    });
    
    router.post('/sharedParameterGroupObject', function(req, res, next) {
        if ((req.get('headerOne') === 'header' || req.get('headerOne') === undefined) && 
            (req.query['queryOne'] === '21' || req.query['queryOne'] === undefined)) {
            coverage['postParameterGroupingSharedParameterGroupObject']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the values in the req. headerOne: " + req.get('headerOne') + ", queryOne: " + req.query['queryOne']);
        }
    });
}

parameterGrouping.prototype.router = router;

module.exports = parameterGrouping;