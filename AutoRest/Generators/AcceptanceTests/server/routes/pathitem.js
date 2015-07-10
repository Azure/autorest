var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var pathitem = function(coverage) {
    router.get('/nullable/globalStringPath/:globalPath/pathItemStringPath/:pathItemPath/localStringPath/:localPath/:globalQuery/:pathItemQuery/:localQuery', function(req, res, next) {
        var local = req.params.localQuery;
        var pathItem = req.params.pathItemQuery;
        var global = req.params.globalQuery;
        console.log('Inside pathItem handler with local "' + local + '", pathItem "' + pathItem + '", global "' + global + '"\n');
        if (local === 'localStringQuery' && pathItem === 'pathItemStringQuery' && global === 'globalStringQuery') {
            if (req.query.localStringQuery === local && req.query.pathItemStringQuery === pathItem && req.query.globalStringQuery === global) {
                coverage['UrlPathItemGetAll']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, 'Failed scenario UrlPathItemGetAll with query parameters "' + util.inspect(req.query) + '"');
            }
        } else if (local === 'localStringQuery' && pathItem === 'pathItemStringQuery' && global === 'null') {
            if (req.query.localStringQuery === local && req.query.pathItemStringQuery === pathItem && Object.keys(req.query).length == 2) {
                coverage['UrlPathItemGetGlobalNull']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, 'Failed scenario UrlPathItemGetGlobalNull with query parameters "' + util.inspect(req.query) + '"');
            }
        } else if (pathItem === 'pathItemStringQuery' && local === 'null' && global === 'null') {
            if (req.query.pathItemStringQuery === pathItem && Object.keys(req.query).length == 1) {
                coverage['UrlPathItemGetGlobalAndLocalNull']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, 'Failed scenario UrlPathItemGetGlobalAndLocalNull with query parameters "' + util.inspect(req.query) + '"');
            }
        } else if (local === 'null' && pathItem === 'null' && global === 'globalStringQuery') {
            if (req.query.globalStringQuery === global && Object.keys(req.query).length == 1) {
                coverage['UrlPathItemGetPathItemAndLocalNull']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, 'Failed scenario UrlPathItemGetPathItemAndLocalNull with query parameters "' + util.inspect(req.query) + '"');
            }
        } else {
            console.log('Could not find pathitem scenario\n');
            utils.send400(res, next, 'Unable to find matching pathitem scenario for local "' + local + '", pathItem "' + pathItem + '", global "' + global + '"');
        }
    });
}

pathitem.prototype.router = router;

module.exports = pathitem;