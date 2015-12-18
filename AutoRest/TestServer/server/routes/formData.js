var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils');
var Busboy = require('busboy');

var formData = function (coverage) {
  
  coverage['FormdataStreamUploadFile'] = 0;
  router.post('/stream/uploadfile', function (req, res, next) {
    var busboy = new Busboy({ headers: req.headers });
    busboy.on('file', function (fieldname, file, filename, encoding, mimetype) {
      console.log('File [' + fieldname + ']: filename: ' + filename + ', encoding: ' + encoding + ', mimetype: ' + mimetype);
      file.on('data', function (data) {
        coverage['FormdataStreamUploadFile']++;
        res.send(data);
      });
    });
    busboy.on('field', function (fieldname, val, fieldnameTruncated, valTruncated, encoding, mimetype) {
      console.log('Field [' + fieldname + ']: value: ' + val);
      if (fieldname === "fileContent") {
        coverage['FormdataStreamUploadFile']++;
        res.send(val);
      }
    });
    busboy.on('finish', function () {
      console.log('Done parsing form!');
      res.send();
    });
    
    req.pipe(busboy);
  });
  
  coverage['StreamUploadFile'] = 0;
  router.put('/stream/uploadfile', function (req, res, next) {
    coverage['StreamUploadFile']++;
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    req.pipe(res);
  });
}

formData.prototype.router = router;

module.exports = formData;