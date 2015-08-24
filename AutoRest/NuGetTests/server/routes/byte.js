var express = require('express');
var router = express.Router();
var util = require('util');
//var Buffer = require('buffer');
var utils = require('../util/utils')

var byte = function(coverage) {
    var bytes = new Buffer([255, 254, 253, 252, 251, 250, 249, 248, 247, 246]);

    router.put('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'nonAscii') {
            if (req.body !== bytes.toString('base64')) {
                utils.send400(res, next, "Did not like nonAscii req '" + util.inspect(req.body) + "'");
            } else {
                coverage['putByteNonAscii']++;
                res.status(200).end();
            }
        } else {
            utils.send400(res, next, 'Request path must contain nonAscii');
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getByteNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'empty') {
            coverage['getByteEmpty']++;
            res.status(200).end('\"\"');
        } else if (req.params.scenario === 'nonAscii') {
            coverage['getByteNonAscii']++;
            res.status(200).end('\"' + bytes.toString('base64') + '\"');
        } else if (req.params.scenario === 'invalid') {
            coverage['getByteInvalid']++;
            res.status(200).end('\"::::SWAGGER::::\"');
        } else {
            res.status(400).send('Request path must contain null or empty or nonAscii or invalid');
        }

    });
}

byte.prototype.router = router;
module.exports = byte;