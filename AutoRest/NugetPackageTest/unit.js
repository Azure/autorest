// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var fs = require('fs');
var reporter = 'list';
var args = (process.ARGV || process.argv);
var testList = args.pop();

var fileContent = fs.readFileSync(testList).toString();
var files = fileContent.split('\n');
args.push('-u');
args.push('tdd');
args.push('-t');
args.push('500000');
files.forEach(function (file) {
  if (file.length > 0) {
    file = file.replace('\r', '');
    args.push(file);
  }
});

args.push('-R');
args.push(reporter);
require('./node_modules/mocha/bin/mocha');