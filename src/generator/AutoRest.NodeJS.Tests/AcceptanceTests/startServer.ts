// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var util = require('util');
var fs = require('fs');

import child_process = require('child_process');

var child: child_process.ChildProcess;

before(function (done) {
  var isWin = /^win/.test(process.platform);
  var nodeCmd = 'node.exe';
  if(!isWin){
    nodeCmd = 'node'
  }
  var started = false;
  var out = fs.openSync('./server.log', 'w');
  fs.writeSync(out, 'Test run started at ' + new Date().toISOString() + '\n');
  child = child_process.spawn(nodeCmd, [__dirname + '/../../../dev/TestServer/server/startup/www']);

  child.stdout.on('data', function (data: Buffer) {
    fs.writeSync(out, data.toString('UTF-8'));
    if (data.toString().indexOf('started') > 0) {
      started = true;
      done();
    }
  });

  child.on('close', function () {
    if (!started) {
      done();
    }
  });
});

after(function (done) {
  child.kill();
  done();
});
