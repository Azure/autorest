
exports = module.exports;

exports.sendError = function(code, res, next, msg) {
  return next({'message': msg, 'status': code});
};

exports.send400 = function(res, next, msg) {
  return exports.sendError(400, res, next, msg);
};

exports.coerceDate = function(targetObject) {
  var stringRep = JSON.stringify(targetObject);
  stringRep = stringRep.replace(/(\d\d\d\d-\d\d-\d\d[Tt]\d\d:\d\d:\d\d)\.\d\d\d[Zz]/g, "$1Z");
  return JSON.parse(stringRep);
};

exports.getPort = function () {
	return process.env.PORT || 3000;
}

exports.toPascalCase = function(input) {
	return '' + input.charAt(0).toUpperCase() + input.slice(1);
}