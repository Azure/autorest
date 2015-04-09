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
  * System is unusable.
  */
  EMERGENCY: 'emergency',

  /**
  * Action must be taken immediately.
  */
  ALERT : 'alert',

  /**
  * Critical condition.
  */
  CRITICAL : 'critical',

  /**
  * Error condition.
  */
  ERROR : 'error',

  /**
  * Warning condition.
  */
  WARNING : 'warning',

  /**
  * Normal but significant condition.
  */
  NOTICE : 'notice',

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
  Logger.LogLevels.EMERGENCY,
  Logger.LogLevels.ALERT,
  Logger.LogLevels.CRITICAL,
  Logger.LogLevels.ERROR,
  Logger.LogLevels.WARNING,
  Logger.LogLevels.NOTICE,
  Logger.LogLevels.INFO,
  Logger.LogLevels.DEBUG
];

Logger.prototype.log = function (level, msg) {
  this.loggerFunction(level, msg);
};

Logger.prototype.emergency = function(msg) {
  this.log(Logger.LogLevels.EMERGENCY, msg);
};

Logger.prototype.critical = function(msg) {
  this.log(Logger.LogLevels.CRITICAL, msg);
};

Logger.prototype.alert = function(msg) {
  this.log(Logger.LogLevels.ALERT, msg);
};

Logger.prototype.error = function(msg) {
  this.log(Logger.LogLevels.ERROR, msg);
};

Logger.prototype.warn = function(msg) {
  this.log(Logger.LogLevels.WARNING, msg);
};

Logger.prototype.notice = function(msg) {
  this.log(Logger.LogLevels.NOTICE, msg);
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
