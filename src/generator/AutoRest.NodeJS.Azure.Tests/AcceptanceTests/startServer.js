// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var util = require('util');
var fs = require('fs');
var child_process = require('child_process');

var child;

before(function (done) {
  var started = false;
  var isWin = /^win/.test(process.platform);
  var nodeCmd = 'node.exe';
  if(!isWin){
    nodeCmd = 'node'
  }
  var out = fs.openSync('./server.log', 'w');
  fs.writeSync(out, 'Test run started at ' + new Date().toISOString() + '\n');
  process.env.PORT = 3000;
  child = child_process.spawn(nodeCmd, [__dirname + '/../../../dev/TestServer/server/startup/www.js']);

  child.stdout.on('data', function (data) {
    fs.writeSync(out, data.toString('UTF-8'));
    if (data.toString().indexOf('started') > 0) {
      started = true;
      done();
    }
  });

  child.on('close', function (code) {
    if (!started) {
      done();
    }
  });
});

after(function (done) {
  child.kill();
  done();
});
