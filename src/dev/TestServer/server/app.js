var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var fs = require('fs');
var morgan = require('morgan');
var routes = require('./routes/index');
var number = require('./routes/number');
var array = require('./routes/array');
var bool = require('./routes/bool');
var integer = require('./routes/int');
var string = require('./routes/string');
var byte = require('./routes/byte');
var date = require('./routes/date');
var datetime = require('./routes/datetime');
var datetimeRfc1123 = require('./routes/datetime-rfc1123');
var duration = require('./routes/duration');
var complex = require('./routes/complex');
var report = require('./routes/report');
var dictionary = require('./routes/dictionary');
var paths = require('./routes/paths');
var queries = require('./routes/queries');
var pathitem = require('./routes/pathitem');
var header = require('./routes/header');
var reqopt = require('./routes/reqopt');
var httpResponses = require('./routes/httpResponses');
var files = require('./routes/files');
var formData = require('./routes/formData');
var lros = require('./routes/lros');
var paging = require('./routes/paging');
var modelFlatten = require('./routes/model-flatten');
var azureUrl = require('./routes/azureUrl');
var azureSpecial = require('./routes/azureSpecials');
var parameterGrouping = require('./routes/azureParameterGrouping.js');
var validation = require('./routes/validation.js');
var customUri = require('./routes/customUri.js');
var util = require('util');

var app = express();

//set up server log
var now = new Date();
var logFileName = 'AccTestServer-' + now.getHours() +
    now.getMinutes() + now.getSeconds() + '.log';
var testResultDir = path.join(__dirname, '../../../TestResults');
if (!fs.existsSync(testResultDir)) {
  fs.mkdirSync(testResultDir);
}
var logfile = fs.createWriteStream(path.join(testResultDir, logFileName), {flags: 'a'});
app.use(morgan('combined', {stream: logfile}));

var azurecoverage = {};
var optionalCoverage = {};
var coverage = {
  "getArrayNull": 0,
  "getArrayEmpty": 0,
  "putArrayEmpty": 0,
  "getArrayInvalid": 0,
  "getArrayBooleanValid": 0,
  "putArrayBooleanValid": 0,
  "getArrayBooleanWithNull": 0,
  "getArrayBooleanWithString": 0,
  "getArrayIntegerValid": 0,
  "putArrayIntegerValid": 0,
  "getArrayIntegerWithNull": 0,
  "getArrayIntegerWithString": 0,
  "getArrayLongValid": 0,
  "putArrayLongValid": 0,
  "getArrayLongWithNull": 0,
  "getArrayLongWithString": 0,
  "getArrayFloatValid": 0,
  "putArrayFloatValid": 0,
  "getArrayFloatWithNull": 0,
  "getArrayFloatWithString": 0,
  "getArrayDoubleValid": 0,
  "putArrayDoubleValid": 0,
  "getArrayDoubleWithNull": 0,
  "getArrayDoubleWithString": 0,
  "getArrayStringValid": 0,
  "putArrayStringValid": 0,
  "getArrayStringWithNull": 0,
  "getArrayStringWithNumber": 0,
  "getArrayDateValid": 0,
  "putArrayDateValid": 0,
  "getArrayDateWithNull": 0,
  "getArrayDateWithInvalidChars": 0,
  "getArrayDateTimeValid": 0,
  "putArrayDateTimeValid": 0,
  "getArrayDateTimeWithNull": 0,
  "getArrayDateTimeWithInvalidChars": 0,
  "getArrayDateTimeRfc1123Valid": 0,
  "putArrayDateTimeRfc1123Valid": 0,
  "getArrayDurationValid": 0,
  "putArrayDurationValid": 0,
  "getArrayUuidValid": 0,
  "getArrayUuidWithInvalidChars": 0,
  "putArrayUuidValid": 0,
  "getArrayByteValid": 0,
  "putArrayByteValid": 0,
  "getArrayByteWithNull": 0,
  "getArrayArrayNull": 0,
  "getArrayArrayEmpty": 0,
  "getArrayArrayItemNull": 0,
  "getArrayArrayItemEmpty": 0,
  "getArrayArrayValid": 0,
  "putArrayArrayValid": 0,
  "getArrayComplexNull": 0,
  "getArrayComplexEmpty": 0,
  "getArrayComplexItemNull": 0,
  "getArrayComplexItemEmpty": 0,
  "getArrayComplexValid": 0,
  "putArrayComplexValid": 0,
  "getArrayDictionaryNull": 0,
    "getArrayDictionaryEmpty": 0,
  "getArrayDictionaryItemNull": 0,
  "getArrayDictionaryItemEmpty": 0,
  "getArrayDictionaryValid": 0,
  "putArrayDictionaryValid": 0,
  "getBoolTrue" : 0,
  "putBoolTrue" : 0,
  "getBoolFalse" : 0,
  "putBoolFalse" : 0,
  "getBoolInvalid" : 0,
  "getBoolNull" : 0,
  "getByteNull": 0,
  "getByteEmpty": 0,
  "getByteNonAscii": 0,
  "putByteNonAscii": 0,
  "getByteInvalid": 0,
  "getDateNull": 0,
  "getDateInvalid": 0,
  "getDateOverflow": 0,
  "getDateUnderflow": 0,
  "getDateMax": 0,
  "putDateMax": 0,
  "getDateMin": 0,
  "putDateMin": 0,
  "getDateTimeNull": 0,
  "getDateTimeInvalid": 0,
  "getDateTimeOverflow": 0,
  "getDateTimeUnderflow": 0,
  "putDateTimeMaxUtc": 0,
  "getDateTimeMaxUtcLowercase": 0,
  "getDateTimeMaxUtcUppercase": 0,
  "getDateTimeMaxLocalPositiveOffsetLowercase": 0,
  "getDateTimeMaxLocalPositiveOffsetUppercase": 0,
  "getDateTimeMaxLocalNegativeOffsetLowercase": 0,
  "getDateTimeMaxLocalNegativeOffsetUppercase": 0,
  "getDateTimeMinUtc": 0,
  "putDateTimeMinUtc": 0,
  "getDateTimeMinLocalPositiveOffset": 0,
  "getDateTimeMinLocalNegativeOffset": 0,
  "getDateTimeRfc1123Null": 0,
  "getDateTimeRfc1123Invalid": 0,
  "getDateTimeRfc1123Overflow": 0,
  "getDateTimeRfc1123Underflow": 0,
  "getDateTimeRfc1123MinUtc": 0,
  "putDateTimeRfc1123Max": 0,
  "putDateTimeRfc1123Min": 0,
  "getDateTimeRfc1123MaxUtcLowercase": 0,
  "getDateTimeRfc1123MaxUtcUppercase": 0,
  "getIntegerNull": 0,
  "getIntegerInvalid": 0,
  "getIntegerOverflow" : 0,
  "getIntegerUnderflow": 0,
  "getLongOverflow": 0,
  "getLongUnderflow": 0,
  "putIntegerMax": 0,
  "putLongMax": 0,
  "putIntegerMin": 0,
  "putLongMin": 0,
  "getNumberNull": 0,
  "getFloatInvalid": 0,
  "getDoubleInvalid": 0,
  "getFloatBigScientificNotation": 0,
  "putFloatBigScientificNotation": 0,
  "getDoubleBigScientificNotation": 0,
  "putDoubleBigScientificNotation": 0,
  "getDoubleBigPositiveDecimal" : 0,
  "putDoubleBigPositiveDecimal" : 0,
  "getDoubleBigNegativeDecimal" : 0,
  "putDoubleBigNegativeDecimal" : 0,
  "getFloatSmallScientificNotation" : 0,
  "putFloatSmallScientificNotation" : 0,
  "getDoubleSmallScientificNotation" : 0,
  "putDoubleSmallScientificNotation" : 0,
  "getStringNull": 0,
  "putStringNull": 0,
  "getStringEmpty": 0,
  "putStringEmpty": 0,
  "getStringMultiByteCharacters": 0,
  "putStringMultiByteCharacters": 0,
  "getStringWithLeadingAndTrailingWhitespace" : 0,
  "putStringWithLeadingAndTrailingWhitespace" : 0,
  "getStringNotProvided": 0,
  "getEnumNotExpandable": 0,
  "putEnumNotExpandable":0,
  "putComplexBasicValid": 0,
  "getComplexBasicValid": 0,
  "getComplexBasicEmpty": 0,
  "getComplexBasicNotProvided": 0,
  "getComplexBasicNull": 0,
  "getComplexBasicInvalid": 0,
  "putComplexPrimitiveInteger": 0,
  "putComplexPrimitiveLong": 0,
  "putComplexPrimitiveFloat": 0,
  "putComplexPrimitiveDouble": 0,
  "putComplexPrimitiveBool": 0,
  "putComplexPrimitiveString": 0,
  "putComplexPrimitiveDate": 0,
  "putComplexPrimitiveDateTime": 0,
  "putComplexPrimitiveDateTimeRfc1123": 0,
  "putComplexPrimitiveDuration": 0,
  "putComplexPrimitiveByte": 0,
  "getComplexPrimitiveInteger": 0,
  "getComplexPrimitiveLong": 0,
  "getComplexPrimitiveFloat": 0,
  "getComplexPrimitiveDouble": 0,
  "getComplexPrimitiveBool": 0,
  "getComplexPrimitiveString": 0,
  "getComplexPrimitiveDate": 0,
  "getComplexPrimitiveDateTime": 0,
  "getComplexPrimitiveDateTimeRfc1123": 0,
  "getComplexPrimitiveDuration": 0,
  "getComplexPrimitiveByte": 0,
  "putComplexArrayValid": 0,
  "putComplexArrayEmpty": 0,
  "getComplexArrayValid": 0,
  "getComplexArrayEmpty": 0,
  "getComplexArrayNotProvided": 0,
  "putComplexDictionaryValid": 0,
  "putComplexDictionaryEmpty": 0,
  "getComplexDictionaryValid": 0,
  "getComplexDictionaryEmpty": 0,
  "getComplexDictionaryNull": 0,
  "getComplexDictionaryNotProvided": 0,
  "putComplexInheritanceValid": 0,
  "getComplexInheritanceValid": 0,
  "putComplexPolymorphismValid": 0,
  "getComplexPolymorphismValid": 0,
  "putComplexPolymorphicRecursiveValid": 0,
  "getComplexPolymorphicRecursiveValid": 0,
  "putComplexReadOnlyPropertyValid": 0,
  "UrlPathsBoolFalse": 0,
  "UrlPathsBoolTrue": 0,
  "UrlPathsIntPositive": 0,
  "UrlPathsIntNegative": 0,
  "UrlPathsLongPositive": 0,
  "UrlPathsLongNegative": 0,
  "UrlPathsFloatPositive": 0,
  "UrlPathsFloatNegative": 0,
  "UrlPathsDoublePositive": 0,
  "UrlPathsDoubleNegative": 0,
  "UrlPathsStringUrlEncoded": 0,
  "UrlPathsStringEmpty": 0,
  "UrlPathsEnumValid":0,
  "UrlPathsByteMultiByte": 0,
  "UrlPathsByteEmpty": 0,
  "UrlPathsDateValid": 0,
  "UrlPathsDateTimeValid": 0,
  "UrlQueriesBoolFalse": 0,
  "UrlQueriesBoolTrue": 0,
  "UrlQueriesBoolNull": 0,
  "UrlQueriesIntPositive": 0,
  "UrlQueriesIntNegative": 0,
  "UrlQueriesIntNull": 0,
  "UrlQueriesLongPositive": 0,
  "UrlQueriesLongNegative": 0,
  "UrlQueriesLongNull": 0,
  "UrlQueriesFloatPositive": 0,
  "UrlQueriesFloatNegative": 0,
  "UrlQueriesFloatNull": 0,
  "UrlQueriesDoublePositive": 0,
  "UrlQueriesDoubleNegative": 0,
  "UrlQueriesDoubleNull": 0,
  "UrlQueriesStringUrlEncoded": 0,
  "UrlQueriesStringEmpty": 0,
  "UrlQueriesStringNull": 0,
  "UrlQueriesEnumValid": 0,
  "UrlQueriesEnumNull": 0,
  "UrlQueriesByteMultiByte": 0,
  "UrlQueriesByteEmpty": 0,
  "UrlQueriesByteNull": 0,
  "UrlQueriesDateValid": 0,
  "UrlQueriesDateNull": 0,
  "UrlQueriesDateTimeValid": 0,
  "UrlQueriesDateTimeNull": 0,
  "UrlQueriesArrayCsvNull": 0,
  "UrlQueriesArrayCsvEmpty": 0,
  "UrlQueriesArrayCsvValid": 0,
  "UrlQueriesArraySsvValid": 0,
  "UrlQueriesArrayPipesValid": 0,
  "UrlQueriesArrayTsvValid": 0,
  "UrlPathItemGetAll": 0,
  "UrlPathItemGetGlobalNull": 0,
  "UrlPathItemGetGlobalAndLocalNull": 0,
  "UrlPathItemGetPathItemAndLocalNull": 0,
  "putDictionaryEmpty": 0,
  "getDictionaryNull": 0,
  "getDictionaryEmpty": 0,
  "getDictionaryInvalid": 0,
  "getDictionaryNullValue": 0,
  "getDictionaryNullkey": 0,
  "getDictionaryKeyEmptyString": 0,
  "getDictionaryBooleanValid": 0,
  "getDictionaryBooleanWithNull": 0,
  "getDictionaryBooleanWithString": 0,
  "getDictionaryIntegerValid": 0,
  "getDictionaryIntegerWithNull": 0,
  "getDictionaryIntegerWithString": 0,
  "getDictionaryLongValid": 0,
  "getDictionaryLongWithNull": 0,
  "getDictionaryLongWithString": 0,
  "getDictionaryFloatValid": 0,
  "getDictionaryFloatWithNull": 0,
  "getDictionaryFloatWithString": 0,
  "getDictionaryDoubleValid": 0,
  "getDictionaryDoubleWithNull": 0,
  "getDictionaryDoubleWithString": 0,
  "getDictionaryStringValid": 0,
  "getDictionaryStringWithNull": 0,
  "getDictionaryStringWithNumber": 0,
  "getDictionaryDateValid": 0,
  "getDictionaryDateWithNull": 0,
  "getDictionaryDateWithInvalidChars": 0,
  "getDictionaryDateTimeValid": 0,
  "getDictionaryDateTimeWithNull": 0,
  "getDictionaryDateTimeWithInvalidChars": 0,
  "getDictionaryDateTimeRfc1123Valid": 0,
  "getDictionaryDurationValid": 0,
  "getDictionaryByteValid": 0,
  "getDictionaryByteWithNull": 0,
  "putDictionaryBooleanValid": 0,
  "putDictionaryIntegerValid": 0,
  "putDictionaryLongValid": 0,
  "putDictionaryFloatValid": 0,
  "putDictionaryDoubleValid": 0,
  "putDictionaryStringValid": 0,
  "putDictionaryDateValid": 0,
  "putDictionaryDateTimeValid": 0,
  "putDictionaryDateTimeRfc1123Valid": 0,
  "putDictionaryDurationValid": 0,
  "putDictionaryByteValid": 0,
  "getDictionaryComplexNull": 0,
  "getDictionaryComplexEmpty": 0,
  "getDictionaryComplexItemNull": 0,
  "getDictionaryComplexItemEmpty": 0,
  "getDictionaryComplexValid": 0,
  "putDictionaryComplexValid": 0,
  "getDictionaryArrayNull": 0,
  "getDictionaryArrayEmpty": 0,
  "getDictionaryArrayItemNull": 0,
  "getDictionaryArrayItemEmpty": 0,
  "getDictionaryArrayValid": 0,
  "putDictionaryArrayValid": 0,
  "getDictionaryDictionaryNull": 0,
  "getDictionaryDictionaryEmpty": 0,
  "getDictionaryDictionaryItemNull": 0,
  "getDictionaryDictionaryItemEmpty": 0,
  "getDictionaryDictionaryValid": 0,
  "putDictionaryDictionaryValid": 0,
  "putDurationPositive": 0,
  "getDurationNull": 0,
  "getDurationInvalid": 0,
  "getDurationPositive": 0,
  "HeaderParameterExistingKey": 0,
  "HeaderResponseExistingKey": 0,
  "HeaderResponseProtectedKey": 0,
  "HeaderParameterIntegerPositive": 0,
  "HeaderParameterIntegerNegative": 0,
  "HeaderParameterLongPositive": 0,
  "HeaderParameterLongNegative": 0,
  "HeaderParameterFloatPositive": 0,
  "HeaderParameterFloatNegative": 0,
  "HeaderParameterDoublePositive": 0,
  "HeaderParameterDoubleNegative": 0,
  "HeaderParameterBoolTrue": 0,
  "HeaderParameterBoolFalse": 0,
  "HeaderParameterStringValid": 0,
  "HeaderParameterStringNull": 0,
  "HeaderParameterStringEmpty": 0,
  "HeaderParameterDateValid": 0,
  "HeaderParameterDateMin": 0,
  "HeaderParameterDateTimeValid": 0,
  "HeaderParameterDateTimeMin": 0,
  "HeaderParameterDateTimeRfc1123Valid": 0,
  "HeaderParameterDateTimeRfc1123Min": 0,
  "HeaderParameterBytesValid": 0,
  "HeaderParameterDurationValid": 0,
  "HeaderResponseIntegerPositive": 0,
  "HeaderResponseIntegerNegative": 0,
  "HeaderResponseLongPositive": 0,
  "HeaderResponseLongNegative": 0,
  "HeaderResponseFloatPositive": 0,
  "HeaderResponseFloatNegative": 0,
  "HeaderResponseDoublePositive": 0,
  "HeaderResponseDoubleNegative": 0,
  "HeaderResponseBoolTrue": 0,
  "HeaderResponseBoolFalse": 0,
  "HeaderResponseStringValid": 0,
  "HeaderResponseStringNull": 0,
  "HeaderResponseStringEmpty": 0,
  "HeaderParameterEnumValid": 0,
  "HeaderParameterEnumNull": 0,
  "HeaderResponseEnumValid": 0,
  "HeaderResponseEnumNull": 0,
  "HeaderResponseDateValid": 0,
  "HeaderResponseDateMin": 0,
  "HeaderResponseDateTimeValid": 0,
  "HeaderResponseDateTimeMin": 0,
  "HeaderResponseDateTimeRfc1123Valid": 0,
  "HeaderResponseDateTimeRfc1123Min": 0,
  "HeaderResponseBytesValid": 0,
  "HeaderResponseDurationValid": 0,
  "FormdataStreamUploadFile": 0,
  "StreamUploadFile": 0,
  "ConstantsInPath": 0,
  "ConstantsInBody": 0,
  "CustomBaseUri": 0,
  //Once all the languages implement this test, the scenario counter should be reset to zero. It is currently implemented in C#, Python and node.js
  "CustomBaseUriMoreOptions": 1,
  'getModelFlattenArray': 0,
  'putModelFlattenArray': 0,
  'getModelFlattenDictionary': 0,
  'putModelFlattenDictionary': 0,
  'getModelFlattenResourceCollection': 0,
  'putModelFlattenResourceCollection': 0,
  'putModelFlattenCustomBase': 0,
  'postModelFlattenCustomParameter': 0,
  'putModelFlattenCustomGroupedParameter': 0,
  /* TODO: only C#, Python and node.js support the base64url format currently. Exclude these tests from code coverage until it is implemented in other languages */
  "getStringBase64Encoded": 1,
  "getStringBase64UrlEncoded": 1,
  "putStringBase64UrlEncoded": 1,
  "getStringNullBase64UrlEncoding": 1,
  "getArrayBase64Url": 1,
  "getDictionaryBase64Url": 1,
  "UrlPathsStringBase64Url": 1,
  "UrlPathsArrayCSVInPath": 1,
  /* TODO: only C# and Python support the unixtime format currently. Exclude these tests from code coverage until it is implemented in other languages */
  "getUnixTime": 1,
  "getInvalidUnixTime": 1,
  "getNullUnixTime": 1,
  "putUnixTime": 1,
  "UrlPathsIntUnixTime": 1,
  /* TODO: Once all the languages implement these tests, the scenario counters should be reset to zero. It is currently implemented in Python */
  "getDecimalInvalid": 1,
  "getDecimalBig": 1,
  "getDecimalSmall": 1,
  "getDecimalBigPositiveDecimal" : 1,
  "getDecimalBigNegativeDecimal" : 1,
  "putDecimalBig": 1,
  "putDecimalSmall": 1,
  "putDecimalBigPositiveDecimal" : 1,
  "putDecimalBigNegativeDecimal" : 1,
};

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json({strict: false}));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/bool', new bool(coverage).router);
app.use('/int', new integer(coverage).router);
app.use('/number', new number(coverage).router);
app.use('/string', new string(coverage).router);
app.use('/byte', new byte(coverage).router);
app.use('/date', new date(coverage).router);
app.use('/datetime', new datetime(coverage, optionalCoverage).router);
app.use('/datetimeRfc1123', new datetimeRfc1123(coverage).router);
app.use('/duration', new duration(coverage, optionalCoverage).router);
app.use('/array', new array(coverage).router);
app.use('/complex', new complex(coverage).router);
app.use('/dictionary', new dictionary(coverage).router);
app.use('/paths', new paths(coverage).router);
app.use('/queries', new queries(coverage).router);
app.use('/pathitem', new pathitem(coverage).router);
app.use('/header', new header(coverage, optionalCoverage).router);
app.use('/reqopt', new reqopt(coverage).router);
app.use('/files', new files(coverage).router);
app.use('/formdata', new formData(coverage).router);
app.use('/http', new httpResponses(coverage, optionalCoverage).router);
app.use('/model-flatten', new modelFlatten(coverage).router);
app.use('/lro', new lros(azurecoverage).router);
app.use('/paging', new paging(azurecoverage).router);
app.use('/azurespecials', new azureSpecial(azurecoverage).router);
app.use('/report', new report(coverage, azurecoverage).router);
app.use('/subscriptions', new azureUrl(azurecoverage).router);
app.use('/parameterGrouping', new parameterGrouping(azurecoverage).router);
app.use('/validation', new validation(coverage).router);
app.use('/customUri', new customUri(coverage).router);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.end(JSON.stringify(err));
});

module.exports = app;
