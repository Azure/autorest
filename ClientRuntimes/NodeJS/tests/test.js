var ps = require('./SwaggerPetstore');
var util = require('util');
var mc = require('../lib/common');

petstore = new ps.SwaggerPetstore("http://localhost:12510/api", new mc.TokenCredentials({
  subscriptionId: "<your subscription id>",
  token: "<your token here>"
})).withFilter(createLogFilter());


function createLogFilter() {
  return function handle (resource, next, callback) {
    function logMessage(err, response, body) {
      console.log("The response logged by the log filter: " + util.inspect(response.body, {depth : null}));
      if (callback) {
        callback(err, response, body);
      }
    }
    return next(resource, logMessage);
  };
}


petstore.findPetById(1, function (error, result) {
	console.log(util.inspect(result, {depth :null}));
});