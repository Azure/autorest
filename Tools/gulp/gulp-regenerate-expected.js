// through2 is a thin wrapper around node transform streams
var through = require('through2');
var gutil = require('gulp-util');
var path = require('path');
var fs = require('fs');
var Q = require('q');
var spawn = require('child_process').spawn;
var PluginError = gutil.PluginError;

const PLUGIN_NAME = 'gulp-regenerate-expected';

function gulpRegenerateExpected(options, done) {
  var opts = JSON.parse(JSON.stringify(options)); // copy input so we can mutate it

  if (!opts.mappings) {
    throw new PluginError({
      plugin: PLUGIN_NAME,
      message: 'There was no opts.mappings specified'
    });
  }

  if (!opts.outputDir) {
    throw new PluginError({
      plugin: PLUGIN_NAME,
      message: 'There was no opts.outputDir specified'
    });
  }
  opts.outputDir = !!opts.outputBaseDir ? path.join(opts.outputBaseDir, opts.outputDir) : opts.outputDir;

  if (!opts.modeler) {
    opts.modeler = 'Swagger';
    gutil.log('opts.modeler not set, so setting it to "Swagger"');
  }

  if (!opts.codeGenerator) {
    opts.codeGenerator = "CSharp";
    gutil.log('opts.codeGenerator not set, so setting it to "CSharp"');
  }

  if(!opts.nsPrefix){
    opts.nsPrefix = "Fixtures";
    gutil.log('opts.nsPrefix not set, so setting it to "Fixtures"');
  }

  if(!opts.flatteningThreshold){
    opts.flatteningThreshold = "0";
    gutil.log('opts.flatteningThreshold not set, so setting it to "0"');
  }

  if(!opts.addCredentials){
    opts.addCredentials = false;
    gutil.log('opts.addCredentials not set, so setting it to "false"');
  }

  var promises = Object.keys(opts.mappings).map(function(key) {
    var cmd = 'mono';
    var optsMappingsValue = opts.mappings[key];
    var mappingBaseDir = optsMappingsValue instanceof Array ? optsMappingsValue[0] : optsMappingsValue;
    var args = [
      'binaries/net45/AutoRest.exe',
      '-Modeler', opts.modeler,
      '-CodeGenerator', opts.codeGenerator,
      '-PayloadFlatteningThreshold', opts.flatteningThreshold,
      '-OutputDirectory', path.join(opts.outputDir, key),
      '-Input', (!!opts.inputBaseDir ? path.join(opts.inputBaseDir, mappingBaseDir) : mappingBaseDir),
      '-Header', (!!opts.header ? opts.header : 'MICROSOFT_MIT_NO_VERSION')      
    ];

    if (opts.addCredentials) {
      args.push('-AddCredentials');
    }
    
    if (opts.syncMethods) {
      args.push('-SyncMethods');
      args.push(opts.syncMethods);
    }

    if (!!opts.nsPrefix) {
      args.push('-Namespace');
      if (optsMappingsValue instanceof Array && optsMappingsValue[1] !== undefined) {
          args.push(optsMappingsValue[1]);
	  }else{
		args.push([opts.nsPrefix, key.replace(/\/|\./, '')].join('.'));
	  }
    }

    var isWin = /^win/.test(process.platform);
    if (isWin) {
      cmd = args.shift();
    }

    gutil.log(PLUGIN_NAME + ': running `', cmd, args.join(', '), '``')

    return exec(cmd, args, {
      stdio: ['pipe', process.stdout, process.stderr]
    })
  });

  Q.allSettled(promises).done(function(args) {
    gutil.log(PLUGIN_NAME + ': done regenerating targeting, ' + opts.outputDir);
    done();
  }, function(args) {
    gutil.log(PLUGIN_NAME + ': done but ran into issues regenerating target, ' + opts.outputDir);
    done(args);
  });
}

function exec(command, args, extArgs) {
  if (!command) {
    return Q.reject(new Error('Both command must be given, not ' + command ));
  }
  if (args && !args.every(function(arg) {
    var type = typeof arg;
    return type === 'boolean' || type === 'string' || type === 'number';
  })) {
    return Q.reject(new Error('All arguments must be a boolean, string or number'));
  }

  var deferred = Q.defer();

  var proc = spawn(command, args, extArgs);
  proc.on('error', function(error) {
    deferred.reject(new Error(command + ' ' + args.join(' ') + ' encountered error ' + error.message));
  });
  proc.on('exit', function(code) {
    if (code !== 0) {
      deferred.reject(new Error(command + ' ' + args.join(' ') + ' exited with code ' + code));
    } else {
      deferred.resolve();
    }
  });
  return deferred.promise;
};

module.exports = gulpRegenerateExpected;
