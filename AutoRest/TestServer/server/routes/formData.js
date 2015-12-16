var express = require('express');
var multer = require('multer');
var upload = multer().single('fileUpload');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils');

var formData = function (coverage) {

  coverage['FormdataStreamUploadFile'] = 0;
  router.post('/stream/uploadfile', function (req, res, next) {
    upload(req, res, function(err) {
        if(err) {
            console.log(req.file);
            console.log(err);
            utils.send400(err);
        }
        console.log(req.file);
        coverage['FormdataStreamUploadFile']++;
        res.send(req.file.buffer);        
    });
  });
  
  coverage['StreamUploadFile'] = 0;
  router.put('/stream/uploadfile', function (req, res, next) {
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      req.pipe(res); 
  });
}

formData.prototype.router = router;

module.exports = formData;