// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var fs = require('fs');
var args = (process.ARGV || process.argv);
//'xunit-file' reporter does not show failures correctly. Hence we should always use the list reporter
var reporter = 'list';
var testList = args.pop();
var fileContent;
var root = false;

if  (!fs.existsSync) {
  fs.existsSync = require('path').existsSync;
}

if (fs.existsSync(testList)) {
  fileContent = fs.readFileSync(testList).toString();
} else {
  fileContent = fs.readFileSync('./test/' + testList).toString();
  root = true;
}

var files = fileContent.split('\n');
args.push('-u');
args.push('tdd');
args.push('-t');
args.push('500000');
files.forEach(function (file) {
  if (file.length > 0 && file.trim()[0] !== '#') {
    // trim trailing \r if it exists
    file = file.replace('\r', '');

    if (root) {
      args.push('test/' + file);
    } else {
      args.push(file);
    }
  }
});

args.push('-R');
args.push(reporter);

require('../node_modules/mocha/bin/mocha');