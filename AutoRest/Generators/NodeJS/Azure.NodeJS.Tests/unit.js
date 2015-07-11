// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var fs = require('fs');
var reporter = 'list';
var args = (process.ARGV || process.argv);
if (args.length > 3) {
  reporter = args.pop();
}
var testList = args.pop();

var fileContent;

if  (!fs.existsSync) {
  fs.existsSync = require('path').existsSync;
}

fileContent = fs.readFileSync('./AcceptanceTests/' + testList).toString();
var files = fileContent.split('\n');
args.push('-u');
args.push('tdd');
args.push('-t');
args.push('500000');
files.forEach(function (file) {
  if (file.length > 0 && file.trim()[0] !== '#') {
    // trim trailing \r if it exists
    file = file.replace('\r', '');
    args.push('AcceptanceTests/' + file);
  }
});

args.push('-R');
args.push(reporter);
require('./node_modules/mocha/bin/mocha');