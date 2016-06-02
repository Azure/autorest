var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils');

var getLRORetryPutScenarioName = function (initialCode, initialState, finalState, finalCode) {
  if (initialCode === 201 && initialState === 'Creating' && finalState === 'Succeeded' && finalCode === 200) {
    return 'LRORetryPutSucceededWithBody';
  }
  return null;
};

var hasScenarioCookie = function (req, scenario) {
  var cookies = req.headers['cookie'];
  var cookieMatch;
  if (cookies) {
    cookieMatch = /scenario=(\w+)/.exec(cookies);
    if (cookieMatch && cookieMatch[1] && cookieMatch[1] === scenario) {
      return true;
    }
  }

  return false;
};

var addScenarioCookie = function (res, scenario) {
  res.cookie('scenario', scenario, {
    'maxAge': 900000
  });
  return res;
};

var removeScenarioCookie = function (res) {
  res.clearCookie('scenario');
  return res;
}

var getPascalCase = function (inString) {
  return '' + inString.substring(0, 1).toUpperCase() + inString.substring(1);
}

var lros = function (coverage) {
  coverage['LROPutInlineComplete'] = 0;
  coverage['CustomHeaderPutAsyncSucceded'] = 0;
  coverage['CustomHeaderPostAsyncSucceded'] = 0;
  coverage['CustomHeaderPutSucceeded'] = 0;
  coverage['CustomHeaderPostSucceeded'] = 0;
  router.put('/put/200/succeeded', function (req, res, next) {
    coverage['LROPutInlineComplete']++;
    res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
  });

  coverage['LROPut200InlineCompleteNoState'] = 0;
  router.put('/put/200/succeeded/nostate', function (req, res, next) {
    coverage['LROPut200InlineCompleteNoState']++;
    res.status(200).end('{"id": "100", "name": "foo" }');
  });

  coverage['LROPut202Retry200'] = 0;
  router.put('/put/202/retry/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/put/202/retry/operationResults/200';
    var headers = {
      'Location': pollingUri
    };

    res.set(headers).status(202).end();
  });

  router.get('/put/202/retry/operationResults/200', function (req, res, next) {
    coverage['LROPut202Retry200']++;
    res.status(200).end('{"id": "100", "name": "foo" }');
  });

  coverage['LROPutSucceededWithBody'] = 0; // /put/201/creating/succeeded/200
  coverage['LROPutSucceededNoBody'] = 0;   // /put/200/updating/succeeded/200
  coverage['LROPutFailed'] = 0;            // /put/201/created/failed/200
  coverage['LROPutCanceled'] = 0;          // /put/200/accepted/canceled/200
  var getLROPutScenarioName = function (initialCode, initialState, finalState, finalCode) {
    if (initialCode === 201 && initialState === 'Creating' && finalState === 'Succeeded' && finalCode === 200) {
      return 'LROPutSucceededWithBody';
    } else if (initialCode === 200 && initialState === 'Updating' && finalState === 'Succeeded' && finalCode === 200) {
      return 'LROPutSucceededNoBody';
    } else if (initialCode === 201 && initialState === 'Created' && finalState === 'Failed' && finalCode === 200) {
      return 'LROPutFailed';
    } else if (initialCode === 200 && initialState === 'Accepted' && finalState === 'Canceled' && finalCode === 200) {
      return 'LROPutCanceled';
    }
    return null;
  };

  router.put('/put/:initialCode/:initialState/:finalState/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var initialState = getPascalCase(req.params.initialState);
    var finalState = getPascalCase(req.params.finalState);
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLROPutScenarioName(initialCode, initialState, finalState, finalCode);
    if (scenario) {
      res.status(initialCode).end('{ "properties": { "provisioningState": "' + initialState + '"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "put" scenario with initialCode: "' + initialCode + '" initialState: "' + initialState + '", finalState: "' + finalState + '", finalCode: "' + finalCode + '"');
    }
  });

  router.get('/put/:initialCode/:initialState/:finalState/:finalCode', function (req, res, next) {
    console.log('parameters: (' + req.params.initialCode + ', ' + req.params.initialState + ', ' + req.params.finalState + ', ' + req.params.finalCode + ')\n')
    var initialCode = JSON.parse(req.params.initialCode);
    var initialState = getPascalCase(req.params.initialState);
    var finalState = getPascalCase(req.params.finalState);
    var finalCode = JSON.parse(req.params.finalCode);
    console.log('parsed parameters: (' + initialCode + ', ' + initialState + ', ' + finalState + ', ' + finalCode + ')\n');
    var scenario = getLROPutScenarioName(initialCode, initialState, finalState, finalCode);
    console.log('Scenario: ' + scenario + '\n')
    if (scenario) {
      coverage[scenario]++;
      res.status(finalCode).end('{ "properties": { "provisioningState": "' + finalState + '"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "put" scenario in poller with initialCode: "' + initialCode + '" initialState: "' + initialState + '", finalState: "' + finalState + '", finalCode: "' + finalCode + '"');
    }

  });

  coverage['LROPutAsyncRetrySucceeded'] = 0;
  coverage['LROPutAsyncNoRetrySucceeded'] = 0;
  coverage['LROPutAsyncRetryFailed'] = 0;
  coverage['LROPutAsyncNoRetryCanceled'] = 0;
  var getLROAsyncScenarioName = function (method, retry, finalState) {
    console.log('in async scenario namer with (' + method + ', ' + retry + ', ' + finalState + ')\n');
    method = getPascalCase(method.replace('async', 'Async'));
    console.log('Method: ' + method + '\n');
    if ((retry === 'retry' || retry === 'noretry') &&
      (finalState === 'Succeeded' || finalState === 'Canceled' || finalState === 'Failed')) {
      retry = retry.replace('no', 'No').replace('retry', 'Retry');
      console.log('retry: ' + retry + '\n');
      var scenario = 'LRO' + method + retry + finalState;
      console.log('scenario: ' + scenario + '\n');
      if (coverage[scenario] !== undefined) {
        return scenario;
      }
    }
    return null;
  };

  router.put('/putasync/:retry/:finalState', function (req, res, next) {
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);

    var scenario = getLROAsyncScenarioName("putasync", retry, finalState);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putasync/' + retry + '/' + finalState.toLowerCase() + '/operationResults/200/';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      res.set(headers).status(200).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "putAsync" scenario with retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  router.get('/putasync/:retry/:finalState', function (req, res, next) {
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);

    var scenario = getLROAsyncScenarioName("putasync", retry, finalState);
    if (scenario) {
      res.status(200).end('{ "properties": { "provisioningState": "' + finalState + '"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "putAsync" scenario with retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  router.get('/putasync/:retry/:finalState/operationResults/:code', function (req, res, next) {
    console.log('In initial poller for put async with ( ' + req.params.operation + ', ' + req.params.retry + ', ' + req.params.finalState + ', ' + req.params.code + ')\n');
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);
    var code = JSON.parse(req.params.code);
    var operation = 'putasync';
    console.log('Parsed parameters ( ' + operation + ', ' + retry + ', ' + finalState + ', ' + code + ')\n');

    var scenario = getLROAsyncScenarioName(operation, retry, finalState);
    console.log('In scenario: ' + scenario + '\n');
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/' + operation + '/' + retry + '/' + finalState.toLowerCase() + '/operationResults/' + code;
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.set(headers).status(202).end('{ "status": "Accepted"}');
      } else {
        removeScenarioCookie(res);
        coverage[scenario]++;
        res.status(code).end('{ "status": "' + finalState + '"}');
      }
    } else {
      utils.send400(res, next, 'Unable to parse "putAsync" scenario in initial polling operationwith retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  coverage['LROPutNoHeaderInRetry'] = 0;
  router.put('/put/noheader/202/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/put/noheader/operationresults';
    var headers = {
      'Location': pollingUri
    };
    res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
  });

  router.get('/put/noheader/operationresults', function (req, res, next) {
    var scenario = 'LROPutNoHeaderInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(202).end();
    } else {
      removeScenarioCookie(res);
      coverage[scenario]++;
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    }
  });

  coverage['LROPutAsyncNoHeaderInRetry'] = 0;
  router.put('/putasync/noheader/201/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putasync/noheader/operationresults/123';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': 'somethingBadWhichShouldNotBeUsed'
    };
    res.set(headers).status(201).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
  });

  router.get('/putasync/noheader/201/200', function (req, res, next) {
    coverage['LROPutAsyncNoHeaderInRetry']++;
    res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
  });

  router.get('/putasync/noheader/operationresults/123', function (req, res, next) {
    var scenario = 'LROPutAsyncNoHeaderInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(200).end('{ "status": "InProgress"}');
    } else {
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded"}');
    }
  });

  coverage['LRODeleteNoHeaderInRetry'] = 0;
  router.delete('/delete/noheader', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/delete/noheader/operationresults/123';
    var headers = {
      'Location': pollingUri
    };
    res.set(headers).status(202).end();
  });

  router.get('/delete/noheader/operationresults/123', function (req, res, next) {
    var scenario = 'LRODeleteNoHeaderInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(202).end();
    } else {
      removeScenarioCookie(res);
      coverage[scenario]++;
      res.status(204).end();
    }
  });

  coverage['LRODeleteAsyncNoHeaderInRetry'] = 0;
  router.delete('/deleteasync/noheader/202/204', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/deleteasync/noheader/operationresults/123';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': 'somethingBadWhichShouldNotBeUsed'
    };
    res.set(headers).status(202).end();
  });

  router.get('/deleteasync/noheader/operationresults/123', function (req, res, next) {
    var scenario = 'LRODeleteAsyncNoHeaderInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(200).end('{ "status": "InProgress"}');
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded"}');
    }
  });

  coverage['LROPutSubResourceInRetry'] = 0;
  router.put('/putsubresource/202/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putsubresource/operationresults';
    var headers = {
      'Location': pollingUri
    };
    res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "subresource": "sub1" }');
  });

  router.get('/putsubresource/operationresults', function (req, res, next) {
    var scenario = 'LROPutSubResourceInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(202).end();
    } else {
      removeScenarioCookie(res);
      coverage[scenario]++;
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "subresource": "sub1" }');
    }
  });

  coverage['LROPutSubResourceAsyncInRetry'] = 0;
  router.put('/putsubresourceasync/202/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putsubresourceasync/operationresults/123';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': 'somethingBadWhichShouldNotBeUsed'
    };
    res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "subresource": "sub1" }');
  });

  router.get('/putsubresourceasync/202/200', function (req, res, next) {
    res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "subresource": "sub1" }');
  });

  router.get('/putsubresourceasync/operationresults/123', function (req, res, next) {
    var scenario = 'LROPutSubResourceAsyncInRetry';
    coverage[scenario]++;
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(200).end('{ "status": "InProgress"}');
    } else {
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded"}');
    }
  });

  coverage['LROPutNonResourceInRetry'] = 0;
  router.put('/putnonresource/202/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putnonresource/operationresults';
    var headers = {
      'Location': pollingUri
    };
    res.set(headers).status(202).end();
  });

  router.get('/putnonresource/operationresults', function (req, res, next) {
    var scenario = 'LROPutNonResourceInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(202).end();
    } else {
      removeScenarioCookie(res);
      coverage[scenario]++;
      res.status(200).end('{ "name": "sku" , "id": "100" }');
    }
  });

  coverage['LROPutNonResourceAsyncInRetry'] = 0;
  router.put('/putnonresourceasync/202/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/putnonresourceasync/operationresults/123';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': 'somethingBadWhichShouldNotBeUsed'
    };
    res.set(headers).status(202).end();
  });

  router.get('/putnonresourceasync/202/200', function (req, res, next) {
    res.status(200).end('{ "name": "sku" , "id": "100" }');
  });

  router.get('/putnonresourceasync/operationresults/123', function (req, res, next) {
    var scenario = 'LROPutNonResourceAsyncInRetry';
    console.log('In scenario: ' + scenario + '\n');
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(200).end('{ "status": "InProgress"}');
    } else {
      removeScenarioCookie(res);
      coverage[scenario]++;
      res.status(200).end('{ "status": "Succeeded"}');
    }
  });

  coverage['LRODeleteProvisioningSucceededWithBody'] = 0;
  coverage['LRODeleteProvisioningFailed'] = 0;
  coverage['LRODeleteProvisioningCanceled'] = 0;
  var getLRODeleteProvisioningScenarioName = function (initialCode, initialState, finalCode, finalState) {
    console.log('Trying to find scenario with (' + initialCode + ', ' + initialState + ', ' + finalCode + ', ' + finalState + ')\n');
    if (initialCode === 202 && initialState === 'Accepted' && finalState === 'Succeeded' && finalCode === 200) {
      return 'LRODeleteProvisioningSucceededWithBody';
    } else if (initialCode === 202 && initialState === 'Deleting' && finalState === 'Failed' && finalCode === 200) {
      return 'LRODeleteProvisioningFailed';
    } else if (initialCode === 202 && initialState === 'Deleting' && finalState === 'Canceled' && finalCode === 200) {
      return 'LRODeleteProvisioningCanceled';
    }

    return null;
  };

  router.delete('/delete/provisioning/:initialCode/:initialState/:finalCode/:finalState', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var initialState = getPascalCase(req.params.initialState);
    var finalState = getPascalCase(req.params.finalState);
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLRODeleteProvisioningScenarioName(initialCode, initialState, finalCode, finalState);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/delete/provisioning/' + initialCode + '/' + initialState.toLowerCase() + '/' + finalCode + '/' + finalState.toLowerCase();
      var headers = {
        'Location': pollingUri,
        'Retry-After': 0
      };

      res.set(headers).status(initialCode).end('{ "properties": { "provisioningState": "' + initialState + '"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "delete provisioning" scenario with initialCode: "' + initialCode + '" initialState: "' + initialState + '", finalState: "' + finalState + '", finalCode: "' + finalCode + '"');
    }
  });

  router.get('/delete/provisioning/:initialCode/:initialState/:finalCode/:finalState', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var initialState = getPascalCase(req.params.initialState);
    var finalState = getPascalCase(req.params.finalState);
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLRODeleteProvisioningScenarioName(initialCode, initialState, finalCode, finalState);
    if (scenario) {
      coverage[scenario]++;
      res.status(finalCode).end('{ "properties": { "provisioningState": "' + finalState + '"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "delete provisioning" scenario in poller with initialCode: "' + initialCode + '" initialState: "' + initialState + '", finalState: "' + finalState + '", finalCode: "' + finalCode + '"');
    }
  });

  coverage['LRODeleteInlineComplete'] = 0;
  router.delete('/delete/204/succeeded', function (req, res, next) {
    coverage['LRODeleteInlineComplete']++;
    res.status(204).end();
  });

  coverage['LRODelete200'] = 0;
  coverage['LRODelete204'] = 0;
  var getLRODeleteScenarioName = function (initialCode, retry, finalCode) {
    console.log('Trying to find delete scenario with (' + initialCode + ', ' + retry + ', ' + finalCode + ')\n');
    if (initialCode === 202 && retry === 'retry' && finalCode === 200) {
      return 'LRODelete200';
    } else if (initialCode === 202 && retry === 'noretry' && finalCode === 204) {
      return 'LRODelete204';
    }
    return null;
  };

  router.delete('/delete/:initialCode/:retry/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var retry = req.params.retry;
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLRODeleteScenarioName(initialCode, retry, finalCode);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/delete/' + initialCode + '/' + retry + '/' + finalCode;
      var headers = {
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      res.set(headers).status(initialCode).end();
    } else {
      utils.send400(res, next, 'Unable to parse "delete" scenario with initialCode: "' + initialCode + '", retry: "' + retry + '", finalCode: "' + finalCode + '"');
    }
  });

  router.get('/delete/:initialCode/:retry/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var retry = req.params.retry;
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLRODeleteScenarioName(initialCode, retry, finalCode);
    if (scenario) {
      coverage[scenario]++;
      res.status(finalCode).end();
    } else {
      utils.send400(res, next, 'Unable to parse "delete" scenario polling with initialCode: "' + initialCode + '", retry: "' + retry + '", finalCode: "' + finalCode + '"');
    }
  });

  coverage['LRODeleteAsyncRetrySucceeded'] = 0;
  coverage['LRODeleteAsyncNoRetrySucceeded'] = 0;
  coverage['LRODeleteAsyncRetryFailed'] = 0;
  coverage['LRODeleteAsyncRetryCanceled'] = 0;
  router.delete('/deleteasync/:retry/:finalState', function (req, res, next) {
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);

    var scenario = getLROAsyncScenarioName("deleteasync", retry, finalState);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/deleteasync/' + retry + '/' + finalState.toLowerCase() + '/operationResults/200/';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      res.set(headers).status(202).end();
    } else {
      utils.send400(res, next, 'Unable to parse "deleteAsync" scenario with retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  router.get('/deleteasync/:retry/:finalState/operationResults/:code', function (req, res, next) {
    console.log('In initial poller for delete async with ( ' + req.params.retry + ', ' + req.params.finalState + ', ' + req.params.code + ')\n');
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);
    var code = JSON.parse(req.params.code);
    var operation = 'deleteasync';
    console.log('Parsed parameters ( ' + operation + ', ' + retry + ', ' + finalState + ', ' + code + ')\n');

    var scenario = getLROAsyncScenarioName(operation, retry, finalState);
    console.log('In scenario: ' + scenario + '\n');
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/' + operation + '/' + retry + '/' + finalState.toLowerCase() + '/operationResults/' + code;
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.set(headers).status(202).end('{ "status": "Accepted"}');
      } else {
        removeScenarioCookie(res);
        coverage[scenario]++;
        res.status(code).end('{ "status": "' + finalState + '"}');
      }
    } else {
      utils.send400(res, next, 'Unable to parse "putAsync" scenario in initial polling operationwith retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  coverage['LROPostSuccededWithBody'] = 0;
  coverage['LROPostSuccededNoBody'] = 0;
  var getLROPostScenarioName = function (initialCode, retry, finalCode) {
    if (initialCode === 202 && retry === 'retry' && finalCode === 200) {
      return 'LROPostSuccededWithBody';
    } else if (initialCode === 202 && retry === 'noretry' && finalCode === 204) {
      return 'LROPostSuccededNoBody';
    }
    return null;
  };

  router.post('/post/:initialCode/:retry/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var retry = req.params.retry;
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLROPostScenarioName(initialCode, retry, finalCode);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/post/' + initialCode + '/' + retry + '/' + finalCode;
      var headers = {
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }

      res.set(headers).status(initialCode).end();
    } else {
      utils.send400(res, next, 'Unable to parse "post" scenario with initialCode: "' + initialCode + '" retry: "' + retry + '", finalCode: "' + finalCode + '"');
    }
  });

  router.get('/post/:initialCode/:retry/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var retry = req.params.retry;
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLROPostScenarioName(initialCode, retry, finalCode);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/post/newuri/' + initialCode + '/' + retry + '/' + finalCode;
      var headers = {
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }

      res.set(headers).status(initialCode).end();
    } else {
      utils.send400(res, next, 'Unable to parse "post" scenario polling with initialCode: "' + initialCode + '", retry: "' + retry + '", finalCode: "' + finalCode + '"');
    }
  });

  router.get('/post/newuri/:initialCode/:retry/:finalCode', function (req, res, next) {
    var initialCode = JSON.parse(req.params.initialCode);
    var retry = req.params.retry;
    var finalCode = JSON.parse(req.params.finalCode);
    var scenario = getLROPostScenarioName(initialCode, retry, finalCode);
    if (scenario) {
      coverage[scenario]++;
      if (finalCode === 200) {
        res.status(200).end('{ "properties": { "provisioningState": "Running"}, "id": "100", "name": "foo" }');
      } else {
        res.status(finalCode).end();
      }
    } else {
      utils.send400(res, next, 'Unable to parse "post" scenario polling with initialCode: "' + initialCode + '", retry: "' + retry + '", finalCode: "' + finalCode + '"');
    }
  });

  coverage['LROPost200'] = 0;
  router.post('/post/payload/200', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/post/payload/200';
    var headers = {
      'Location': pollingUri,
      'Retry-After' : 0
    };

    res.set(headers).status(202).end();
  });

  router.get('/post/payload/200', function (req, res, next) {
    var scenario = 'LROPost200';
    coverage[scenario]++;
    res.status(200).end('{"id":1, "name":"product"}');
  });

  coverage['LROPostAsyncRetrySucceeded'] = 0;
  coverage['LROPostAsyncNoRetrySucceeded'] = 0;
  coverage['LROPostAsyncRetryFailed'] = 0;
  coverage['LROPostAsyncRetryCanceled'] = 0;
  router.post('/postasync/:retry/:finalState', function (req, res, next) {
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);

    var scenario = getLROAsyncScenarioName("postasync", retry, finalState);
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/postasync/' + retry + '/' + finalState.toLowerCase() + '/operationResults/200/';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Unable to parse "postAsync" scenario with retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  router.get('/postasync/:retry/:finalState/operationResults/:code', function (req, res, next) {
    console.log('In initial poller for post async with ( ' + req.params.retry + ', ' + req.params.finalState + ', ' + req.params.code + ')\n');
    var retry = req.params.retry;
    var finalState = getPascalCase(req.params.finalState);
    var code = JSON.parse(req.params.code);
    var operation = 'postasync';
    console.log('Parsed parameters ( ' + operation + ', ' + retry + ', ' + finalState + ', ' + code + ')\n');

    var scenario = getLROAsyncScenarioName(operation, retry, finalState);
    console.log('In scenario: ' + scenario + '\n');
    if (scenario) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/' + operation + '/' + retry + '/' + finalState.toLowerCase() + '/operationResults/' + code;
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      if (retry === 'retry') {
        headers['Retry-After'] = 0;
      }
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.set(headers).status(202).end('{ "status": "Accepted"}');
      } else {
        removeScenarioCookie(res);
        coverage[scenario]++;
        var outStr = '{ "status": "' + finalState + '", "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }';
        if (operation == 'postasync' && finalState == 'Failed') {
          outStr = '{ "status": "' + finalState + '", "error": { "code": 500, "message": "Internal Server Error"}}';
        }

        res.status(code).end(outStr);
      }
    } else {
      utils.send400(res, next, 'Unable to parse "putAsync" scenario in initial polling operationwith retry: "' + retry + '", finalState: "' + finalState + '"');
    }
  });

  /** Retryable errors **/

  coverage['LRORetryPutSucceededWithBody'] = 0;
  router.put('/retryerror/put/201/creating/succeeded/200', function (req, res, next) {
    var scenario = 'LRORetryPutSucceededWithBody';
    if (scenario) {
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.status(500).end();
      } else {
        removeScenarioCookie(res);
        res.status(201).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
      }
    } else {
      utils.send400(res, next, 'Unable to parse "put" scenario with initialCode: "201" initialState: "Creating", finalState: "Succeeded", finalCode: "200"');
    }
  });

  router.get('/retryerror/put/201/creating/succeeded/200', function (req, res, next) {
    var scenario = 'LRORetryPutSucceededWithBody';
    if (scenario) {
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.status(500).end();
      } else {
        coverage[scenario]++;
        removeScenarioCookie(res);
        res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
      }
    } else {
      utils.send400(res, next, 'Unable to parse "put" scenario with initialCode: "201" initialState: "Creating", finalState: "Succeeded", finalCode: "200"');
    }

  });

  coverage['LRORetryErrorPutAsyncSucceeded'] = 0;
  coverage['LRORetryErrorPutAsyncSucceededPolling'] = 0;
  router.put('/retryerror/putasync/retry/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorPutAsyncSucceeded';
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/putasync/retry/succeeded/operationResults/200';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.set(headers).status(500).end();
    } else {
      removeScenarioCookie(res);
      res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
    }
  });

  router.get('/retryerror/putasync/retry/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorPutAsyncSucceeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    }
  });

  router.get('/retryerror/putasync/retry/succeeded/operationResults/200', function (req, res, next) {
    var scenario = 'LRORetryErrorPutAsyncSucceededPolling';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded" }');
    }
  });

  coverage['LRORetryErrorDelete202Accepted200Succeeded'] = 0;
  router.delete('/retryerror/delete/provisioning/202/accepted/200/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorDelete202Accepted200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/delete/provisioning/202/accepted/200/succeeded';
      var headers = {
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      removeScenarioCookie(res);
      res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
    }
  });

  router.get('/retryerror/delete/provisioning/202/accepted/200/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorDelete202Accepted200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    }
  });

  coverage['LRORetryErrorDelete202Retry200Succeeded'] = 0;
  router.delete('/retryerror/delete/202/retry/200', function (req, res, next) {
    var scenario = 'LRORetryErrorDelete202Retry200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/delete/202/retry/200';
      var headers = {
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      removeScenarioCookie(res);
      res.set(headers).status(202).end();
    }
  });

  router.get('/retryerror/delete/202/retry/200', function (req, res, next) {
    var scenario = 'LRORetryErrorDelete202Retry200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    }
  });

  coverage['LRORetryErrorDeleteAsyncRetrySucceeded'] = 0;
  router.delete('/retryerror/deleteasync/retry/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorDeleteAsyncRetrySucceeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/deleteasync/retry/succeeded/operationResults/200';
      var headers = {
        'Location': '/foo',
        'Azure-AsyncOperation': pollingUri,
        'Retry-After': 0
      };
      removeScenarioCookie(res);
      res.set(headers).status(202).end();
    }
  });

  router.get('/retryerror/deleteasync/retry/succeeded/operationResults/200', function (req, res, next) {
    var scenario = 'LRORetryErrorDeleteAsyncRetrySucceeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded" }');
    }
  });

  coverage['LRORetryErrorPost202Retry200Succeeded'] = 0;
  router.post('/retryerror/post/202/retry/200', function (req, res, next) {
    var scenario = 'LRORetryErrorPost202Retry200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/post/202/retry/200/operationResults';
      var headers = {
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      removeScenarioCookie(res);
      res.set(headers).status(202).end();
    }
  });

  router.get('/retryerror/post/202/retry/200/operationResults', function (req, res, next) {
    var scenario = 'LRORetryErrorPost202Retry200Succeeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    }
  });

  coverage['LRORetryErrorPostAsyncRetrySucceeded'] = 0;
  router.post('/retryerror/postasync/retry/succeeded', function (req, res, next) {
    var scenario = 'LRORetryErrorPostAsyncRetrySucceeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/retryerror/postasync/retry/succeeded/operationResults/200';
      var headers = {
        'Location': '/foo',
        'Azure-AsyncOperation': pollingUri,
        'Retry-After': 0
      };
      removeScenarioCookie(res);
      res.set(headers).status(202).end();
    }
  });

  router.get('/retryerror/postasync/retry/succeeded/operationResults/200', function (req, res, next) {
    var scenario = 'LRORetryErrorPostAsyncRetrySucceeded';
    if (!hasScenarioCookie(req, scenario)) {
      addScenarioCookie(res, scenario);
      res.status(500).end();
    } else {
      coverage[scenario]++;
      removeScenarioCookie(res);
      res.status(200).end('{ "status": "Succeeded" }');
    }
  });

  /*** HERE COMES THE SAD PATHS ***/

  coverage['LRONonRetryPut400'] = 0;
  router.put('/nonretryerror/put/400', function (req, res, next) {
    coverage['LRONonRetryPut400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  coverage['LRONonRetryPut201Creating400'] = 0;
  router.put('/nonretryerror/put/201/creating/400', function (req, res, next) {
    res.status(201).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/nonretryerror/put/201/creating/400', function (req, res, next) {
    coverage['LRONonRetryPut201Creating400']++;
    res.status(400).end('{ "message" : "Error from the server" }');
  });

  /* TODO: only C# has implemented this test. Exclude it from code coverage until it is implemented in other languages */
  coverage['LRONonRetryPut201Creating400InvalidJson'] = 1;
  router.put('/nonretryerror/put/201/creating/400/invalidjson', function (req, res, next) {
      res.status(201).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/nonretryerror/put/201/creating/400/invalidjson', function (req, res, next) {
      coverage['LRONonRetryPut201Creating400InvalidJson']++;
      res.status(400).end('<{ "message" : "Error from the server" }');
  });

  coverage['LRONonRetryPutAsyncRetry400'] = 0;
  router.put('/nonretryerror/putasync/retry/400', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/nonretryerror/putasync/retry/failed/operationResults/400';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/nonretryerror/putasync/retry/failed/operationResults/400', function (req, res, next) {
    coverage['LRONonRetryPutAsyncRetry400']++;
    res.status(400).end();
  });

  coverage['LRONonRetryDelete400'] = 0;
  router.delete('/nonretryerror/delete/400', function (req, res, next) {
    coverage['LRONonRetryDelete400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  coverage['LRONonRetryDelete202Retry400'] = 0;
  router.delete('/nonretryerror/delete/202/retry/400', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/nonretryerror/delete/202/retry/400';
    var headers = {
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/nonretryerror/delete/202/retry/400', function (req, res, next) {
    coverage['LRONonRetryDelete202Retry400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  coverage['LRONonRetryDeleteAsyncRetry400'] = 0;
  router.delete('/nonretryerror/deleteasync/retry/400', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/nonretryerror/deleteasync/retry/failed/operationResults/400';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/nonretryerror/deleteasync/retry/failed/operationResults/400', function (req, res, next) {
    coverage['LRONonRetryDeleteAsyncRetry400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  coverage['LRONonRetryPost400'] = 0;
  router.post('/nonretryerror/post/400', function (req, res, next) {
    coverage['LRONonRetryPost400']++;
    res.status(400).end('{"message" : "Expected bad request message"}');
  });

  coverage['LRONonRetryPost202Retry400'] = 0;
  router.post('/nonretryerror/post/202/retry/400', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/nonretryerror/post/202/retry/400';
    var headers = {
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/nonretryerror/post/202/retry/400', function (req, res, next) {
    coverage['LRONonRetryPost202Retry400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  coverage['LRONonRetryPostAsyncRetry400'] = 0;
  router.post('/nonretryerror/postasync/retry/400', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/nonretryerror/postasync/retry/failed/operationResults/400';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/nonretryerror/postasync/retry/failed/operationResults/400', function (req, res, next) {
    coverage['LRONonRetryPostAsyncRetry400']++;
    utils.send400(res, next, 'Expected bad request message');
  });

  // Errors
  coverage['LROErrorPut201NoProvisioningStatePayload'] = 0;
  router.put('/error/put/201/noprovisioningstatepayload', function (req, res, next) {
    coverage['LROErrorPut201NoProvisioningStatePayload']++;
    res.status(201).end();
  });

  router.get('/error/put/201/noprovisioningstatepayload', function (req, res, next) {
    res.status(200).end();
  });

  coverage['LROErrorPutAsyncNoPollingStatus'] = 0;
  router.put('/error/putasync/retry/nostatus', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/putasync/retry/failed/operationResults/nostatus';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/error/putasync/retry/nostatus', function (req, res, next) {
    res.status(200).end('{ }');
  });

  router.get('/error/putasync/retry/failed/operationResults/nostatus', function (req, res, next) {
    coverage['LROErrorPutAsyncNoPollingStatus']++;
    res.status(200).end('{ }');
  });

  coverage['LROErrorPutAsyncNoPollingStatusPayload'] = 0;
  router.put('/error/putasync/retry/nostatuspayload', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/putasync/retry/failed/operationResults/nostatuspayload';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/error/putasync/retry/nostatuspayload', function (req, res, next) {
    res.status(200).end();
  });

  router.get('/error/putasync/retry/failed/operationResults/nostatuspayload', function (req, res, next) {
    coverage['LROErrorPutAsyncNoPollingStatusPayload']++;
    res.status(200).end();
  });

  coverage['LROErrorPut200InvalidJson'] = 0;
  router.put('/error/put/200/invalidjson', function (req, res, next) {
    coverage['LROErrorPut200InvalidJson']++;
    res.status(200).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo"');
  });

  router.get('/error/put/200/invalidjson', function (req, res, next) {
    res.status(200).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo"');
  });

  coverage['LROErrorPutAsyncInvalidHeader'] = 0;
  router.put('/error/putasync/retry/invalidheader', function (req, res, next) {
    coverage['LROErrorPutAsyncInvalidHeader']++;
    var pollingUri = '/foo';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': '/bar'
    };
    res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  coverage['LROErrorPutAsyncInvalidJsonPolling'] = 0;
  router.put('/error/putasync/retry/invalidjsonpolling', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/putasync/retry/failed/operationResults/invalidjsonpolling';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(200).set(headers).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
  });

  router.get('/error/putasync/retry/failed/operationResults/invalidjsonpolling', function (req, res, next) {
    coverage['LROErrorPutAsyncInvalidJsonPolling']++;
    res.status(200).end('{ "status": "Accepted"');
  });

  coverage['LROErrorDeleteNoLocation'] = 0;
  router.delete('/error/delete/204/nolocation', function (req, res, next) {
    coverage['LROErrorDeleteNoLocation']++;
    res.status(204).end();
  });

  coverage['LROErrorDelete202RetryInvalidHeader'] = 0;
  router.delete('/error/delete/202/retry/invalidheader', function (req, res, next) {
    coverage['LROErrorDelete202RetryInvalidHeader']++;
    var pollingUri = '/foo';
    var headers = {
      'Location': pollingUri,
      'Retry-After': '/bar'
    };
    res.status(202).set(headers).end();
  });

  coverage['LROErrorDeleteAsyncNoPollingStatus'] = 0;
  router.delete('/error/deleteasync/retry/nostatus', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/deleteasync/retry/failed/operationResults/nostatus';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/error/deleteasync/retry/failed/operationResults/nostatus', function (req, res, next) {
    coverage['LROErrorDeleteAsyncNoPollingStatus']++;
    res.status(200).end('{ }');
  });

  coverage['LROErrorDeleteAsyncInvalidHeader'] = 0;
  router.delete('/error/deleteasync/retry/invalidheader', function (req, res, next) {
    coverage['LROErrorDeleteAsyncInvalidHeader']++;
    var pollingUri = '/foo';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': '/bar'
    };
    res.status(202).set(headers).end();
  });

  coverage['LROErrorDeleteAsyncInvalidJsonPolling'] = 0;
  router.delete('/error/deleteasync/retry/invalidjsonpolling', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/deleteasync/retry/failed/operationResults/invalidjsonpolling';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/error/deleteasync/retry/failed/operationResults/invalidjsonpolling', function (req, res, next) {
    coverage['LROErrorDeleteAsyncInvalidJsonPolling']++;
    res.status(200).end('{ "status": "Accepted"');
  });

  coverage['LROErrorPostNoLocation'] = 0;
  router.post('/error/post/202/nolocation', function (req, res, next) {
    coverage['LROErrorPostNoLocation']++;
    res.status(202).end();
  });

  coverage['LROErrorPost202RetryInvalidHeader'] = 0;
  router.post('/error/post/202/retry/invalidheader', function (req, res, next) {
    coverage['LROErrorPost202RetryInvalidHeader']++;
    var pollingUri = '/foo';
    var headers = {
      'Location': pollingUri,
      'Retry-After': '/bar'
    };
    res.status(202).set(headers).end();
  });

  coverage['LROErrorPostAsyncNoPollingPayload'] = 0;
  router.post('/error/postasync/retry/nopayload', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/postasync/retry/failed/operationResults/nopayload';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/error/postasync/retry/failed/operationResults/nopayload', function (req, res, next) {
    coverage['LROErrorPostAsyncNoPollingPayload']++;
    res.status(200).end();
  });

  coverage['LROErrorPostAsyncInvalidHeader'] = 0;
  router.post('/error/postasync/retry/invalidheader', function (req, res, next) {
    coverage['LROErrorPostAsyncInvalidHeader']++;
    var pollingUri = '/foo';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': '/bar'
    };
    res.status(202).set(headers).end();
  });

  coverage['LROErrorPostAsyncInvalidJsonPolling'] = 0;
  router.post('/error/postasync/retry/invalidjsonpolling', function (req, res, next) {
    var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/error/postasync/retry/failed/operationResults/invalidjsonpolling';
    var headers = {
      'Azure-AsyncOperation': pollingUri,
      'Location': pollingUri,
      'Retry-After': 0
    };
    res.status(202).set(headers).end();
  });

  router.get('/error/postasync/retry/failed/operationResults/invalidjsonpolling', function (req, res, next) {
    coverage['LROErrorPostAsyncInvalidJsonPolling']++;
    res.status(200).end('{ "status": "Accepted"');
  });

  router.put('/customheader/putasync/retry/succeeded', function (req, res, next) {
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/putasync/retry/succeeded/operationResults/200';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      res.set(headers).status(200).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in put: "' + header);
    }
  });

  router.get('/customheader/putasync/retry/succeeded', function (req, res, next) {
    var header = req.get("x-ms-client-request-id");
    var scenario = 'CustomHeaderPutAsyncSucceded';
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get: "' + header);
    }
  });

  router.get('/customheader/putasync/retry/succeeded/operationResults/200', function (req, res, next) {
    var header = req.get("x-ms-client-request-id");
    var scenario = 'CustomHeaderPutAsyncSucceded';
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/putasync/retry/succeeded/operationResults/200';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.set(headers).status(202).end('{ "status": "Accepted"}');
      } else {
        removeScenarioCookie(res);
        coverage[scenario]++;
        res.status(200).end('{ "status": "Succeeded"}');
      }
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get: "' + header);
    }
  });

  router.post('/customheader/postasync/retry/succeeded', function (req, res, next) {
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/postasync/retry/succeeded/operationResults/200';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      res.set(headers).status(202).end('{ "properties": { "provisioningState": "Accepted"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in put: "' + header);
    }
  });

  router.get('/customheader/postasync/retry/succeeded/operationResults/200', function (req, res, next) {
    var header = req.get("x-ms-client-request-id");
    var scenario = 'CustomHeaderPostAsyncSucceded';
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/postasync/retry/succeeded/operationResults/200';
      var headers = {
        'Azure-AsyncOperation': pollingUri,
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      if (!hasScenarioCookie(req, scenario)) {
        addScenarioCookie(res, scenario);
        res.set(headers).status(202).end('{ "status": "Accepted"}');
      } else {
        removeScenarioCookie(res);
        coverage[scenario]++;
        res.status(200).end('{ "status": "Succeeded"}');
      }
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get: "' + header);
    }
  });

 router.put('/customheader/put/201/creating/succeeded/200', function (req, res, next) {
    var scenario = 'CustomHeaderPutSucceeded';
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      res.status(201).end('{ "properties": { "provisioningState": "Creating"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in put: "' + header);
    }
  });

  router.get('/customheader/put/201/creating/succeeded/200', function (req, res, next) {
    var scenario = 'CustomHeaderPutSucceeded';
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      coverage[scenario]++;
      res.status(200).end('{ "properties": { "provisioningState": "Succeeded"}, "id": "100", "name": "foo" }');
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get: "' + header);
    }
  });

///////////////////////////////
  router.post('/customheader/post/202/retry/200', function (req, res, next) {
    var scenario = 'CustomHeaderPostSucceeded';
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/post/202/retry/200';
      var headers = {
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      res.set(headers).status(202).end();
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in post: "' + header);
    }
  });

  router.get('/customheader/post/202/retry/200', function (req, res, next) {
    var scenario = 'CustomHeaderPostSucceeded';
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      var pollingUri = 'http://localhost:' + utils.getPort() + '/lro/customheader/post/newuri/202/retry/200';
      var headers = {
        'Location': pollingUri
      };
      headers['Retry-After'] = 0;
      res.set(headers).status(202).end();
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get: "' + header);
    }
  });

  router.get('/customheader/post/newuri/202/retry/200', function (req, res, next) {
    var scenario = 'CustomHeaderPostSucceeded';
    var header = req.get("x-ms-client-request-id");
    if (header && header.toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      coverage[scenario]++;
      res.status(200).end();
    } else {
      utils.send400(res, next, 'Did not receive the correct x-ms-client-request-id header in get new uri: "' + header);
    }
  });
};

lros.prototype.router = router;

module.exports = lros;