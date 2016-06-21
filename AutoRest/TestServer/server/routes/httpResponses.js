var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var getHttpScenarioName = function(scenario, method, code) {
    var lookup = {
        'Success': {
            '200' : {
                'head': 'HttpSuccess200Head',
                'get': 'HttpSuccess200Get',
                'options': 'HttpSuccess200Options',
                'put': 'HttpSuccess200Put',
                'post': 'HttpSuccess200Post',
                'patch': 'HttpSuccess200Patch',
                'delete': 'HttpSuccess200Delete'
            },
            '201' : {
                'put': 'HttpSuccess201Put',
                'post': 'HttpSuccess201Post'
            },
            '202' : {
                'put': 'HttpSuccess202Put',
                'post': 'HttpSuccess202Post',
                'patch': 'HttpSuccess202Patch',
                'delete': 'HttpSuccess202Delete'
            },
            '204' : {
                'head': 'HttpSuccess204Head',
                'put': 'HttpSuccess204Put',
                'post': 'HttpSuccess204Post',
                'patch': 'HttpSuccess204Patch',
                'delete': 'HttpSuccess204Delete'
            },
            '404' : {
                'head': 'HttpSuccess404Head'
            }
        },
        'Redirect': {
            '300' : {
                'head': 'HttpRedirect300Head',
                'get': 'HttpRedirect300Get'
            },
            '301' : {
                'head': 'HttpRedirect300Head',
                'put': 'HttpRedirect301Put',
                'get': 'HttpRedirect301Get'
            },
            '302' : {
                'head': 'HttpRedirect302Head',
                'get': 'HttpRedirect302Get',
                'patch': 'HttpRedirect302Patch'
            },
            '303' : {
                'post': 'HttpRedirect303Post'
            },
            '307' : {
                'head': 'HttpRedirect307Head',
                'get': 'HttpRedirect307Get',
                'options': 'HttpRedirect307Options',
                'put': 'HttpRedirect307Put',
                'post': 'HttpRedirect307Post',
                'patch': 'HttpRedirect307Patch',
                'delete': 'HttpRedirect307Delete'
            }
        },
        'Retry': {
            '408' : {
                'head': 'HttpRetry408Head'
            },
            '502' : {
                'options': 'HttpRetry502Options',
                'get': 'HttpRetry502Get'
            },
            '500' : {
                'put': 'HttpRetry500Put',
                'patch': 'HttpRetry500Patch'
            },
            '503' : {
                'post': 'HttpRetry503Post',
                'delete': 'HttpRetry503Delete'
            },
            '504' : {
                'put': 'HttpRetry504Put',
                'patch': 'HttpRetry504Patch'
            }
        },
        'Failure': {
            '400' : {
                'head': 'HttpClientFailure400Head',
                'get': 'HttpClientFailure400Get',
                'options': 'HttpClientFailure400Options',
                'put': 'HttpClientFailure400Put',
                'post': 'HttpClientFailure400Post',
                'patch': 'HttpClientFailure400Patch',
                'delete': 'HttpClientFailure400Delete'
            },
            '401' : {
                'head': 'HttpClientFailure401Head'
            },
            '402' : {
                'get': 'HttpClientFailure402Get'
            },
            '403' : {
                'get': 'HttpClientFailure403Get',
                'options': 'HttpClientFailure403Options'
            },
            '404' : {
                'put': 'HttpClientFailure404Put'
            },
            '405' : {
                'patch': 'HttpClientFailure405Patch'
            },
            '406' : {
                'post': 'HttpClientFailure406Post'
            },
            '407' : {
                'delete': 'HttpClientFailure407Delete'
            },
            '409' : {
                'put': 'HttpClientFailure409Put'
            },
            '410' : {
                'head': 'HttpClientFailure410Head'
            },
            '411' : {
                'get': 'HttpClientFailure411Get'
            },
            '412' : {
                'get': 'HttpClientFailure412Get',
                'options': 'HttpClientFailure412Options'
            },
            '413' : {
                'put': 'HttpClientFailure413Put'
            },
            '414' : {
                'patch': 'HttpClientFailure414Patch'
            },
            '415' : {
                'post': 'HttpClientFailure415Post'
            },
            '416' : {
                'get': 'HttpClientFailure416Get'
            },
            '417' : {
                'delete': 'HttpClientFailure417Delete'
            },
            '429' : {
                'head': 'HttpClientFailure429Head'
            },
             '501' : {
                'head': 'HttpServerFailure501Head',
                'get': 'HttpServerFailure501Get'
            },
            '502' : {
                'options': 'HttpServerFailure502Options',
                'put': 'HttpServerFailure502Put'
            },
            '504' : {
                'patch': 'HttpServerFailure504Patch'
            },
            '505' : {
                'post': 'HttpServerFailure505Post',
                'delete': 'HttpServerFailure505Delete'
            }
        }
    };
    var method = method.toLowerCase();
    console.log('looking up http scenario ( ' + scenario + ', ' + code + ', ' + method + ')\n');
    if (lookup[scenario] && lookup[scenario][code] && lookup[scenario][code][method]) {
        return lookup[scenario][code][method];
    } else {
        return null;
    }
};

var isRetryRequest = function(req, code, method) {
    var cookies = req.headers['cookie'];
    var cookieMatch;
    if (cookies) {
        cookieMatch = /tries=(\w+)/.exec(cookies);
        if (cookieMatch && cookieMatch[1] && cookieMatch[1] === code + '_' + method) {
            return true;
        }
    }

    return false;
};

var addRetryTracker = function(res, code, method) {
    res.cookie('tries', code + '_' + method, {'maxAge': 900000});
    return res;
};

var removeRetryTracker = function(res) {
    res.clearCookie('tries');
    return res;
}

var getMultipleResponseScenarioName = function( scenario, code, type) {
    if (scenario === 'A') {
        if (code === '200' && type === 'valid') {
            return "ResponsesScenarioA200MatchingModel";
        } else if (code === '204' && type === 'none') {
            return "ResponsesScenarioA204MatchingNoModel";
        } else if (code === '201' && type === 'valid') {
            return "ResponsesScenarioA201DefaultNoModel";
        } else if (code === '202' && type === 'none') {
            return "ResponsesScenarioA202DefaultNoModel";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioA400DefaultModel";
        } else {
            return null;
        }
    } else if (scenario ==='B') {
        if (code === '200' && type === 'valid') {
            return "ResponsesScenarioB200MatchingModel";
        } else if (code === '201' && type === 'valid') {
            return "ResponsesScenarioB201MatchingModel";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioB400DefaultModel";
        } else {
            return null;
        }
    } else if (scenario ==='C') {
        if (code === '200' && type === 'valid') {
            return "ResponsesScenarioC200MatchingModel";
        } else if (code === '201' && type === 'valid') {
            return "ResponsesScenarioC201MatchingModel";
        } else if (code === '404' && type === 'valid') {
            return "ResponsesScenarioC404MatchingModel";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioC400DefaultModel";
        } else {
            return null;
        }
    } else if (scenario ==='D') {
        if (code === '202' && type === 'none') {
            return "ResponsesScenarioD202MatchingNoModel";
        } else if (code === '204' && type === 'none') {
            return "ResponsesScenarioD204MatchingNoModel";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioD400DefaultModel";
        } else {
            return null;
        }
    } else if (scenario ==='E') {
        if (code === '202' && type === 'invalid') {
            return "ResponsesScenarioE202MatchingInvalid";
        } else if (code === '204' && type === 'none') {
            return "ResponsesScenarioE204MatchingNoModel";
        } else if (code === '400' && type === 'none') {
            return "ResponsesScenarioE400DefaultNoModel";
        } else if (code === '400' && type === 'invalid') {
            return "ResponsesScenarioE400DefaultInvalid";
        } else {
            return null;
        }
    } else if (scenario ==='F') {
        if (code === '200' && type === 'valid') {
            return "ResponsesScenarioF200DefaultModel";
        } else if (code === '200' && type === 'none') {
            return "ResponsesScenarioF200DefaultNone";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioF400DefaultModel";
        } else if (code === '400' && type === 'none') {
            return "ResponsesScenarioF400DefaultNone";
        } else {
            return null;
        }
    } else if (scenario ==='G') {
        if (code === '200' && type === 'invalid') {
            return "ResponsesScenarioG200DefaultInvalid";
        } else if (code === '200' && type === 'none') {
            return "ResponsesScenarioG200DefaultNoModel";
        } else if (code === '400' && type === 'invalid') {
            return "ResponsesScenarioG400DefaultInvalid";
        } else if (code === '400' && type === 'none') {
            return "ResponsesScenarioG400DefaultNoModel";
        } else {
            return null;
        }
    } else if (scenario ==='H') {
        if (code === '200' && type === 'none') {
            return "ResponsesScenarioH200MatchingNone";
        } else if (code === '200' && type === 'valid') {
            return "ResponsesScenarioH200MatchingModel";
        } if (code === '200' && type === 'invalid') {
            return "ResponsesScenarioH200MatchingInvalid";
        } else if (code === '400' && type === 'none') {
            return "ResponsesScenarioH400NonMatchingNone";
        } else if (code === '400' && type === 'valid') {
            return "ResponsesScenarioH400NonMatchingModel";
        } else if (code === '400' && type === 'invalid') {
            return "ResponsesScenarioH400NonMatchingInvalid";
        } else if (code === '202' && type === 'valid') {
            return "ResponsesScenarioH202NonMatchingModel";
        } else {
            return null;
        }
    } else {
        return null;
    }
};



var httpResponses = function(coverage, optionalCoverage) {
    coverage['HttpSuccess200Head'] = 0;
    coverage['HttpSuccess200Get'] = 0;
    optionalCoverage['HttpSuccess200Options'] = 0;
    coverage['HttpSuccess200Put'] = 0;
    coverage['HttpSuccess200Post'] = 0;
    coverage['HttpSuccess200Patch'] = 0;
    coverage['HttpSuccess200Delete'] = 0;
	coverage['HttpSuccess200Head'] = 0;
    coverage['HttpSuccess201Put'] = 0;
    coverage['HttpSuccess201Post'] = 0;
    coverage['HttpSuccess202Put'] = 0;
    coverage['HttpSuccess202Post'] = 0;
    coverage['HttpSuccess202Patch'] = 0;
    coverage['HttpSuccess202Delete'] = 0;
    coverage['HttpSuccess204Head'] = 0;
    coverage['HttpSuccess404Head'] = 0;
    coverage['HttpSuccess204Put'] = 0;
    coverage['HttpSuccess204Post'] = 0;
    coverage['HttpSuccess204Patch'] = 0;
    coverage['HttpSuccess204Delete'] = 0;
    coverage['HttpRedirect300Head'] = 0;
    coverage['HttpRedirect300Get'] = 0;
    coverage['HttpRedirect300Head'] = 0;
    coverage['HttpRedirect301Put'] = 0;
    coverage['HttpRedirect301Get'] = 0;
    coverage['HttpRedirect302Head'] = 0;
    coverage['HttpRedirect302Get'] = 0;
    coverage['HttpRedirect302Patch'] = 0;
    coverage['HttpRedirect303Post'] = 0;
    coverage['HttpRedirect307Head'] = 0;
    coverage['HttpRedirect307Get'] = 0;
    optionalCoverage['HttpRedirect307Options'] = 0;
    coverage['HttpRedirect307Put'] = 0;
    coverage['HttpRedirect307Post'] = 0;
    coverage['HttpRedirect307Patch'] = 0;
    coverage['HttpRedirect307Delete'] = 0;
    coverage['HttpRetry408Head'] = 0;
    coverage['HttpRetry500Put'] = 0;
    coverage['HttpRetry500Patch'] = 0;
    optionalCoverage['HttpRetry502Options'] = 0;
    coverage['HttpRetry502Get'] = 0;
    coverage['HttpRetry503Post'] = 0;
    coverage['HttpRetry503Delete'] = 0;
    coverage['HttpRetry504Put'] = 0;
    coverage['HttpRetry504Patch'] = 0;
    coverage['HttpClientFailure400Head'] = 0;
    coverage['HttpClientFailure400Get'] = 0;
    optionalCoverage['HttpClientFailure400Options'] = 0;
    coverage['HttpClientFailure400Put'] = 0;
    coverage['HttpClientFailure400Post'] = 0;
    coverage['HttpClientFailure400Patch'] = 0;
    coverage['HttpClientFailure400Delete'] = 0;
    coverage['HttpClientFailure401Head'] = 0;
    coverage['HttpClientFailure402Get'] = 0;
    coverage['HttpClientFailure403Get'] = 0;
    optionalCoverage['HttpClientFailure403Options'] = 0;
    coverage['HttpClientFailure404Put'] = 0;
    coverage['HttpClientFailure405Patch'] = 0;
    coverage['HttpClientFailure406Post'] = 0;
    // 407 throws an exception in DNX
    coverage['HttpClientFailure407Delete'] = 1;
    coverage['HttpClientFailure409Put'] = 0;
    coverage['HttpClientFailure410Head'] = 0;
    coverage['HttpClientFailure411Get'] = 0;
    coverage['HttpClientFailure412Get'] = 0;
    optionalCoverage['HttpClientFailure412Options'] = 0;
    coverage['HttpClientFailure413Put'] = 0;
    coverage['HttpClientFailure414Patch'] = 0;
    coverage['HttpClientFailure415Post'] = 0;
    coverage['HttpClientFailure416Get'] = 0;
    coverage['HttpClientFailure417Delete'] = 0;
    coverage['HttpClientFailure429Head'] = 0;
    coverage['HttpServerFailure501Head'] = 0;
    coverage['HttpServerFailure501Get'] = 0;
    coverage['HttpServerFailure505Post'] = 0;
    coverage['HttpServerFailure505Delete'] = 0;
    coverage['ResponsesScenarioA200MatchingModel'] = 0;
    coverage['ResponsesScenarioA204MatchingNoModel'] = 0;
    coverage['ResponsesScenarioA201DefaultNoModel'] = 0;
    coverage['ResponsesScenarioA202DefaultNoModel'] = 0;
    coverage['ResponsesScenarioA400DefaultModel'] = 0;
    coverage['ResponsesScenarioB200MatchingModel'] = 0;
    coverage['ResponsesScenarioB201MatchingModel'] = 0;
    coverage['ResponsesScenarioB400DefaultModel'] = 0;
    coverage['ResponsesScenarioC200MatchingModel'] = 0;
    coverage['ResponsesScenarioC201MatchingModel'] = 0;
    coverage['ResponsesScenarioC404MatchingModel'] = 0;
    coverage['ResponsesScenarioC400DefaultModel'] = 0;
    coverage['ResponsesScenarioD202MatchingNoModel'] = 0;
    coverage['ResponsesScenarioD204MatchingNoModel'] = 0;
    coverage['ResponsesScenarioD400DefaultModel'] = 0;
    coverage['ResponsesScenarioE202MatchingInvalid'] = 0;
    coverage['ResponsesScenarioE204MatchingNoModel'] = 0;
    coverage['ResponsesScenarioE400DefaultNoModel'] = 0;
    coverage['ResponsesScenarioE400DefaultInvalid'] = 0;
    coverage['ResponsesScenarioF200DefaultModel'] = 0;
    coverage['ResponsesScenarioF200DefaultNone'] = 0;
    coverage['ResponsesScenarioF400DefaultModel'] = 0;
    coverage['ResponsesScenarioF400DefaultNone'] = 0;
    coverage['ResponsesScenarioG200DefaultInvalid'] = 0;
    coverage['ResponsesScenarioG200DefaultNoModel'] = 0;
    coverage['ResponsesScenarioG400DefaultInvalid'] = 0;
    coverage['ResponsesScenarioG400DefaultNoModel'] = 0;
    coverage['ResponsesScenarioH200MatchingNone'] = 0;
    coverage['ResponsesScenarioH200MatchingModel'] = 0;
    coverage['ResponsesScenarioH200MatchingInvalid'] = 0;
    coverage['ResponsesScenarioH400NonMatchingNone'] = 0;
    coverage['ResponsesScenarioH400NonMatchingModel'] = 0;
    coverage['ResponsesScenarioH400NonMatchingInvalid'] = 0;
    coverage['ResponsesScenarioH202NonMatchingModel'] = 0;
    coverage['ResponsesScenarioEmptyErrorBody'] = 0;
    coverage['ResponsesScenarioNoModelErrorBody'] = 0;
    optionalCoverage['ResponsesScenarioNoModelEmptyBody'] = 0; // For handling a specific null content scenario in C#
    var updateScenarioCoverage = function(scenario, method) {
        if (method.toLowerCase() === 'options') {
            optionalCoverage[scenario]++
        } else {
            coverage[scenario]++;
        }
    };

    router.all('/success/:code', function(req, res, next) {
        var scenario = getHttpScenarioName("Success", req.method, req.params.code);
        var code = JSON.parse(req.params.code);
        if (scenario !== null) {
            updateScenarioCoverage(scenario, req.method);
            if (req.method === 'GET' || req.method === 'OPTIONS') {
                res.status(code).end('true');
            } else {
                res.status(code).end();
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse success scenario with return code "' + req.params.code + '"');
        }
    });

    router.all('/success/:method/:code', function(req, res, next) {
        res = removeRetryTracker(res);
        if (req.method.toLowerCase() === req.params.method) {
            res.status(JSON.parse(req.params.code)).end();
        } else {
            utils.send400(res, next, 'Unable to parse redirection, expected method "' + req.params.method + '" did not match actual method "' + req.method.toLowerCase() + '"');
        }
    });

    router.all('/failure/:code', function(req, res, next) {
        utils.send400(res, next, 'Client incorrectly redirected a request');
    });

    router.all('/failure/emptybody/error', function(req, res, next) {
        coverage['ResponsesScenarioEmptyErrorBody']++;
        utils.send400(res, next, '');
    });
    router.all('/failure/nomodel/error', function(req, res, next) {
        coverage['ResponsesScenarioNoModelErrorBody']++;
        utils.send400(res, next, 'NoErrorModel');
    });
    router.all('/failure/nomodel/empty', function(req, res, next) {
        // TODO: cover this scenario
        coverage['ResponsesScenarioNoModelEmptyBody']++;
        res.status(400).end();
    });
    router.all('/redirect/:code', function(req, res, next) {
        var scenario = getHttpScenarioName("Redirect", req.method, req.params.code);
        if (scenario !== null) {
            updateScenarioCoverage(scenario, req.method);
            status = (JSON.parse(req.params.code));
            if ((req.params.code === '301' || req.params.code === '302')  && req.method !== 'HEAD' && req.method !== 'GET') {
                res.append('Location', '/http/failure/500');
            } else if (req.params.code === '303') {
                res.append('Location', '/http/success/get/200');
            } else {
                res.append('Location', '/http/success/' + req.method.toLowerCase() + '/200');
            }

            if (req.method === 'GET'  && req.params.code === '300') {
                res.status(status).end('["/http/success/get/200"]');
            } else {
                res.status(status).end();
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse redirection scenario with return code "' + req.params.code + '"');
        }
    });

    router.all('/failure/:type/:code', function(req, res, next) {
        var scenario = getHttpScenarioName("Failure", req.method, req.params.code);
        if (scenario !== null) {
            updateScenarioCoverage(scenario, req.method);
            var status = JSON.parse(req.params.code);
            res.status(status).end();
        }
        else {
            utils.send400(res, next, 'Unable to parse failure scenario with return code "' + req.params.code + '"');
        }
    });

    router.all('/retry/:code', function( req, res, next) {
       var scenario = getHttpScenarioName("Retry", req.method, req.params.code);
       var code = JSON.parse(req.params.code);
        if (scenario !== null) {
            if (isRetryRequest(req, code, req.method.toLowerCase())) {
               updateScenarioCoverage(scenario, req.method);
               removeRetryTracker(res).status(200).end();
            } else {
               utils.sendError(code, addRetryTracker(res, code, req.method.toLowerCase()), next, "Retry scenario initial request");
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse retry scenario with return code "' + req.params.code + '"');
        }
    });

    router.get('/payloads/200/A/204/none/default/Error/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("A", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'valid') {
                if (code === 200 || code === 201) {
                    res.status(code).end('{ "statusCode": "' + code + '" }');
                } else {
                    utils.sendError(400, res, next, 'client error');
                }
            } else if (req.params.type === 'none') {
               res.status(code).end();
            } else if (req.params.type === 'invalid') {
               res.status(code).end();
            } else {
                utils.send400(res, next, 'Unable to parse multiple response scenario with return code "' + req.params.code +
                    '" and type "' + req.params.type + '"');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario A (One success response with model, one success response with no model, default error model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/200/A/201/B/default/Error/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("B", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'valid') {
                if (code === 200 ) {
                    res.status(200).end('{ "statusCode": "200" }');
                } else if (code === 201) {
                    res.status(201).end('{ "statusCode": "201" , "textStatusCode": "Created" }');
                } else {
                    utils.send400(res, next, 'client error');
                }
            } else {
                utils.send400(res, next, 'Unable to parse multiple response scenario B with return code "' + req.params.code +
                    '" and type "' + req.params.type + '"');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario B (Two success responses with common base model, default error response with model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/200/A/201/C/404/D/default/Error/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("C", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'valid') {
                if (code === 200 ) {
                    res.status(200).end('{ "statusCode": "200" }');
                } else if (code === 201) {
                    res.status(201).end('{ "httpCode": "201" }');
                } else if (code === 404) {
                    res.status(404).end('{ "httpStatusCode": "404" }');
                } else {
                    utils.send400(res, next, 'client error');
                }
            } else {
                utils.send400(res, next, 'Unable to parse type "' + req.params.type + '" in response scenario C');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario C (Three success responses with models with no common base type, default error response with model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/202/none/204/none/default/Error/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("D", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'none') {
                res.status(code).end();
            } else {
                utils.send400(res, next, 'client error');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario D (Two success responses with no model and one default response with no model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/202/none/204/none/default/none/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("E", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'none') {
                res.status(code).end();
            } else if (req.params.type === 'invalid') {
                res.status(code).end('{ "property": "value" }');
            } else {
                utils.send400(res, next, 'Unable to parse type "' + req.params.type + '" in response scenario E');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario E (Two success responses with no model and one default response with no model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/default/A/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("F", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'none') {
                res.status(code).end();
            } else if (req.params.type === 'valid') {
                res.status(code).end('{ "statusCode": "' + code + '" }');
            } else {
                utils.send400(res, next, 'Unable to parse type "' + req.params.type + '" in response scenario F');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario F (One default response with model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/default/none/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("G", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'none') {
                res.status(code).end();
            } else if (req.params.type === 'invalid') {
                res.status(code).end('{ "statusCode": "' + code + '" }');
            } else {
                utils.send400(res, next, 'Unable to parse type "' + req.params.type + '" in response scenario F');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario G (One default response with no model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });

    router.get('/payloads/200/A/response/:code/:type', function( req, res, next) {
        var code = JSON.parse(req.params.code);
        var scenario = getMultipleResponseScenarioName("H", req.params.code, req.params.type);
        if (scenario !== null) {
            coverage[scenario]++;
            if (req.params.type === 'none') {
                res.status(code).end();
            } else if (req.params.type === 'valid') {
                res.status(code).end('{ "statusCode": "' + code + '" }');
            } else if (req.params.type === 'invalid') {
                res.status(code).end('{ "statusCodeInvalid": "' + code + '" }');
            } else {
                utils.send400(res, next, 'Unable to parse type "' + req.params.type + '" in response scenario F');
            }
        }
        else {
            utils.send400(res, next, 'Unable to parse multiple response scenario H (One success response with model) with return code "' + req.params.code +
                '" and type "' + req.params.type + '"');
        }
    });}

httpResponses.prototype.router = router;

module.exports = httpResponses;