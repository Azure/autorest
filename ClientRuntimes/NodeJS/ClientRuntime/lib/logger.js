// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

function Logger(level, loggerFunction) {
  this.level = level;
  this.loggerFunction = loggerFunction;

  if (!this.loggerFunction) {
    this.loggerFunction = this.defaultLoggerFunction;
  }
}

Logger.LogLevels = {
  /**
  * Fatal condition.
  */
  FATAL : 'fatal',

  /**
  * Error condition.
  */
  ERROR : 'error',

  /**
  * Warning condition.
  */
  WARNING : 'warning',

  /**
  * Purely informational message.
  */
  INFO : 'info',

  /**
  * Application debug messages.
  */
  DEBUG : 'debug'
};

Logger.logPriority = [
  Logger.LogLevels.FATAL,
  Logger.LogLevels.ERROR,
  Logger.LogLevels.WARNING,
  Logger.LogLevels.NOTICE,
  Logger.LogLevels.INFO,
  Logger.LogLevels.DEBUG
];

Logger.prototype.log = function (level, msg) {
  this.loggerFunction(level, msg);
};

Logger.prototype.fatal = function(msg) {
  this.log(Logger.LogLevels.FATAL, msg);
};

Logger.prototype.error = function(msg) {
  this.log(Logger.LogLevels.ERROR, msg);
};

Logger.prototype.warn = function(msg) {
  this.log(Logger.LogLevels.WARNING, msg);
};

Logger.prototype.info = function(msg) {
  this.log(Logger.LogLevels.INFO, msg);
};

Logger.prototype.debug = function(msg) {
  this.log(Logger.LogLevels.DEBUG, msg);
};

Logger.prototype.defaultLoggerFunction = function(logLevel , msg) {
  var currentLevelIndex = Logger.logPriority.indexOf(this.level);
  var logLevelIndex = Logger.logPriority.indexOf(logLevel);
  var time = new Date();
  var timeStamp = time.toISOString();
  if (logLevelIndex <= currentLevelIndex) {
    console.log('[' + timeStamp + ']' + this.level + ' : ' + msg);
  }
};

module.exports = Logger;
