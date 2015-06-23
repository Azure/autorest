
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

exports.ErrorModel = require('./ErrorModel');
exports.Basic = require('./Basic');
exports.Pet = require('./Pet');
exports.Cat = require('./Cat');
exports.Dog = require('./Dog');
exports.Siamese = require('./Siamese');
exports.Fish = require('./Fish');
exports.Salmon = require('./Salmon');
exports.Shark = require('./Shark');
exports.Sawshark = require('./Sawshark');
exports.IntWrapper = require('./IntWrapper');
exports.LongWrapper = require('./LongWrapper');
exports.FloatWrapper = require('./FloatWrapper');
exports.DoubleWrapper = require('./DoubleWrapper');
exports.BooleanWrapper = require('./BooleanWrapper');
exports.StringWrapper = require('./StringWrapper');
exports.DateWrapper = require('./DateWrapper');
exports.DatetimeWrapper = require('./DatetimeWrapper');
exports.ByteWrapper = require('./ByteWrapper');
exports.ArrayWrapper = require('./ArrayWrapper');
exports.DictionaryWrapper = require('./DictionaryWrapper');
exports.discriminators = {
  'fish' : exports.Fish,
  'salmon' : exports.Salmon,
  'shark' : exports.Shark,
  'sawshark' : exports.Sawshark
};
