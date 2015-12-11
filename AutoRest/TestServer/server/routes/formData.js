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
	    return;
	}
	console.log(req.file);
	coverage['FormdataStreamUploadFile']++;
	res.send(req.file);        
    });
  });
}

formData.prototype.router = router;

module.exports = formData;