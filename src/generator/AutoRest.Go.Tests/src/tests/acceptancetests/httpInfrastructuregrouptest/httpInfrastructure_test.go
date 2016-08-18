package httpinfrastructuregrouptest

import (
	"net/http"
	"strconv"
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/httpinfrastructure"
)

//TODO:
//Options tests (200, 307, 400, 403, 412, 502)

func Test(t *testing.T) { chk.TestingT(t) }

type HTTPSuite struct{}

var _ = chk.Suite(&HTTPSuite{})

var httpSuccessClient = getHTTPSuccessClient()
var httpFailureClient = getHTTPFailureClient()
var httpClientFailureClient = getHTTPClientFailureClient()
var httpRetryClient = getHTTPRetryClient()
var httpRedirectClient = getHTTPRedirectClient()
var httpServerFailureClient = getHTTPServerFailureClient()
var httpMultipleResponsesClient = getHTTPMultipleResponsesClient()

func getHTTPSuccessClient() HTTPSuccessClient {
	c := NewHTTPSuccessClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getHTTPFailureClient() HTTPFailureClient {
	c := NewHTTPFailureClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getHTTPClientFailureClient() HTTPClientFailureClient {
	c := NewHTTPClientFailureClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getHTTPRetryClient() HTTPRetryClient {
	c := NewHTTPRetryClient()
	c.BaseURI = utils.GetBaseURI()
	c.RetryDuration = 3 * time.Second
	return c
}

func getHTTPRedirectClient() HTTPRedirectsClient {
	c := NewHTTPRedirectsClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getHTTPServerFailureClient() HTTPServerFailureClient {
	c := NewHTTPServerFailureClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getHTTPMultipleResponsesClient() MultipleResponsesClient {
	c := NewMultipleResponsesClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

// HTTP success test
//200

func (s *HTTPSuite) TestHead200(c *chk.C) {
	res, err := httpSuccessClient.Head200()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGet200(c *chk.C) {
	res, err := httpSuccessClient.Get200()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, true)
}

func (s *HTTPSuite) TestPut200(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Put200(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPost200(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Post200(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPatch200(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Patch200(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestDelete200(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Delete200(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

// func (s *HTTPSuite) TestOptions200(c *chk.C) {
// 	res, err := httpSuccessClient.Options200()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

//201

func (s *HTTPSuite) TestPut201(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Put201(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusCreated)
}

func (s *HTTPSuite) TestPost201(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Post201(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusCreated)
}

//202

func (s *HTTPSuite) TestPut202(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Put202(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
}

func (s *HTTPSuite) TestPost202(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Post202(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
}

func (s *HTTPSuite) TestPatch202(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Patch202(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
}

func (s *HTTPSuite) TestDelete202(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Delete202(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
}

//204

func (s *HTTPSuite) TestHead204(c *chk.C) {
	res, err := httpSuccessClient.Head204()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestPut204(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Put204(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestPost204(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Post204(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestDelete204(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Delete204(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestPatch204(c *chk.C) {
	b := true
	res, err := httpSuccessClient.Patch204(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

//404

func (s *HTTPSuite) TestHead404(c *chk.C) {
	res, err := httpSuccessClient.Head404()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNotFound)
}

// HTTP redirect test
//300
// Go does not support redirects for HEAD and GET for 300.

// func (s *HTTPSuite) TestHead300(c *chk.C) {
// 	res, err := httpRedirectClient.Head300()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// func (s *HTTPSuite) TestGet300(c *chk.C) {
// 	res, err := httpRedirectClient.Get300()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// 301

func (s *HTTPSuite) TestHead301(c *chk.C) {
	res, err := httpRedirectClient.Head301()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGet301(c *chk.C) {
	res, err := httpRedirectClient.Get301()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPut301(c *chk.C) {
	b := true
	res, err := httpRedirectClient.Put301(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusMovedPermanently)
}

//302

func (s *HTTPSuite) TestHead302(c *chk.C) {
	res, err := httpRedirectClient.Head302()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGet302(c *chk.C) {
	res, err := httpRedirectClient.Get302()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPatch302(c *chk.C) {
	b := true
	res, err := httpRedirectClient.Patch302(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusFound)
}

//303

func (s *HTTPSuite) TestPost303(c *chk.C) {
	b := true
	res, err := httpRedirectClient.Post303(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

//307
// Go does not support redirects for Put, Post, Patch, Delete for 307.

func (s *HTTPSuite) TestHead307(c *chk.C) {
	res, err := httpRedirectClient.Head307()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGet307(c *chk.C) {
	res, err := httpRedirectClient.Get307()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

// func (s *HTTPSuite) TestPut307(c *chk.C) {
// 	b := true
// 	res, err := httpRedirectClient.Put307(&b)
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// func (s *HTTPSuite) TestPost307(c *chk.C) {
// 	b := true
// 	res, err := httpRedirectClient.Post307(&b)
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// func (s *HTTPSuite) TestPatch307(c *chk.C) {
// 	b := true
// 	res, err := httpRedirectClient.Patch307(&b)
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// func (s *HTTPSuite) TestDelete307(c *chk.C) {
// 	b := true
// 	res, err := httpRedirectClient.Delete307(&b)
// 	// Code does not redirect if its not Get or Head
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// func (s *HTTPSuite) TestOptions307(c *chk.C) {
// 	res, err := httpRedirectClient.Options307()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

// HTTP failure test

func (s *HTTPSuite) TestGetEmptyError(c *chk.C) {
	res, err := httpFailureClient.GetEmptyError()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGetNoModelError(c *chk.C) {
	res, err := httpFailureClient.GetNoModelError()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

// HTTP client failure test
//400

func (s *HTTPSuite) TestHead400(c *chk.C) {
	res, err := httpClientFailureClient.Head400()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet400(c *chk.C) {
	res, err := httpClientFailureClient.Get400()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestPut400(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Put400(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestPatch400(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Patch400(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestPost400(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Post400(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestDelete400(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Delete400(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

// func (s *HTTPSuite) TestOptions400(c *chk.C) {
// 	res, err := httpClientFailureClient.Options400()
// 	c.Assert(err, chk.NotNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
// }

//401

func (s *HTTPSuite) TestHead401(c *chk.C) {
	res, err := httpClientFailureClient.Head401()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusUnauthorized)
}

//402

func (s *HTTPSuite) TestGet402(c *chk.C) {
	res, err := httpClientFailureClient.Get402()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusPaymentRequired)
}

//403

func (s *HTTPSuite) TestGet403(c *chk.C) {
	res, err := httpClientFailureClient.Get403()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusForbidden)
}

// func (s *HTTPSuite) TestOptions403(c *chk.C) {
// 	res, err := httpClientFailureClient.Options403()
// 	c.Assert(err, chk.NotNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusForbidden)
// }

//404

func (s *HTTPSuite) TestPut404(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Put404(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNotFound)
}

//405

func (s *HTTPSuite) TestPatch405(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Patch405(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusMethodNotAllowed)
}

//406

func (s *HTTPSuite) TestPost406(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Post406(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNotAcceptable)
}

//407

func (s *HTTPSuite) TestDelete407(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Delete407(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusProxyAuthRequired)
}

//409

func (s *HTTPSuite) TestPut409(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Put409(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusConflict)
}

//410

func (s *HTTPSuite) TestHead410(c *chk.C) {
	res, err := httpClientFailureClient.Head410()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusGone)
}

//411

func (s *HTTPSuite) TestGet411(c *chk.C) {
	res, err := httpClientFailureClient.Get411()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusLengthRequired)
}

//412

func (s *HTTPSuite) TestGet412(c *chk.C) {
	res, err := httpClientFailureClient.Get412()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusPreconditionFailed)
}

// func (s *HTTPSuite) TestOptions412(c *chk.C) {
// 	res, err := httpClientFailureClient.Options412()
// 	c.Assert(err, chk.NotNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusPreconditionFailed)
// }

//413

func (s *HTTPSuite) TestPut413(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Put413(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusRequestEntityTooLarge)
}

//414

func (s *HTTPSuite) TestPatch414(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Patch414(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusRequestURITooLong)
}

//415

func (s *HTTPSuite) TestPost415(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Post415(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusUnsupportedMediaType)
}

//416

func (s *HTTPSuite) TestGet416(c *chk.C) {
	res, err := httpClientFailureClient.Get416()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusRequestedRangeNotSatisfiable)
}

//417

func (s *HTTPSuite) TestDelete417(c *chk.C) {
	b := true
	res, err := httpClientFailureClient.Delete417(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusExpectationFailed)
}

//429

func (s *HTTPSuite) TestHead429(c *chk.C) {
	res, err := httpClientFailureClient.Head429()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, 429)
}

// HTTP retry test
//408

func (s *HTTPSuite) TestHead408(c *chk.C) {
	res, err := httpRetryClient.Head408()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

//500

func (s *HTTPSuite) TestPut500(c *chk.C) {
	b := true
	res, err := httpRetryClient.Put500(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPatch500(c *chk.C) {
	b := true
	res, err := httpRetryClient.Patch500(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

//502

func (s *HTTPSuite) TestGet502(c *chk.C) {
	res, err := httpRetryClient.Get502()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

// func (s *HTTPSuite) TestOptions502(c *chk.C) {
// 	res, err := httpRetryClient.Options502()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
// }

//503

func (s *HTTPSuite) TestPost503(c *chk.C) {
	b := true
	res, err := httpRetryClient.Post503(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestDelete503(c *chk.C) {
	b := true
	res, err := httpRetryClient.Delete503(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

//504

func (s *HTTPSuite) TestPut504(c *chk.C) {
	b := true
	res, err := httpRetryClient.Put504(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestPatch504(c *chk.C) {
	b := true
	res, err := httpRetryClient.Patch504(&b)
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

// Server failure test
//501

func (s *HTTPSuite) TestHead501(c *chk.C) {
	res, err := httpServerFailureClient.Head501()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNotImplemented)
}

func (s *HTTPSuite) TestGet501(c *chk.C) {
	res, err := httpServerFailureClient.Get501()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNotImplemented)
}

//505

func (s *HTTPSuite) TestPost505(c *chk.C) {
	b := true
	res, err := httpServerFailureClient.Post505(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusHTTPVersionNotSupported)
}

func (s *HTTPSuite) TestDelete505(c *chk.C) {
	b := true
	res, err := httpServerFailureClient.Delete505(&b)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusHTTPVersionNotSupported)
}

// Multiple response status
func (s *HTTPSuite) TestGet200Model204NoModelDefaultError200Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model204NoModelDefaultError200Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.StatusCode, chk.Equals, strconv.Itoa(http.StatusOK))
}

func (s *HTTPSuite) TestGet200Model204NoModelDefaultError201Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model204NoModelDefaultError201Invalid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusCreated)
}

func (s *HTTPSuite) TestGet200Model204NoModelDefaultError202None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model204NoModelDefaultError202None()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusAccepted)
}

func (s *HTTPSuite) TestGet200Model204NoModelDefaultError204Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model204NoModelDefaultError204Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.IsNil)
}

func (s *HTTPSuite) TestGet200Model204NoModelDefaultError400Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model204NoModelDefaultError400Valid()
	// Failing: to parse the error. can't parse code; message to error{ code and message } service error
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200Model201ModelDefaultError200Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model201ModelDefaultError200Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.StatusCode, chk.Equals, strconv.Itoa(http.StatusOK))
}

func (s *HTTPSuite) TestGet200Model201ModelDefaultError201Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model201ModelDefaultError201Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(res, chk.NotNil)
	c.Assert(*res.StatusCode, chk.Equals, strconv.Itoa(http.StatusCreated))
	//c.Assert(res.Status, chk.Equals, "Created") //Obtained string is "201 Created""
}

func (s *HTTPSuite) TestGet200Model201ModelDefaultError400Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200Model201ModelDefaultError400Valid()
	// can't parse {code:, message: } into "error"{ code:, message:}
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200ModelA201ModelC404ModelDDefaultError200Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA201ModelC404ModelDDefaultError200Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(res, chk.NotNil)
	c.Assert((*res.Value)["statusCode"], chk.Equals, strconv.Itoa(http.StatusOK))
}

func (s *HTTPSuite) TestGet200ModelA201ModelC404ModelDDefaultError201Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA201ModelC404ModelDDefaultError201Valid()
	c.Assert(err, chk.IsNil)
	c.Assert((*res.Value)["httpCode"], chk.Equals, strconv.Itoa(http.StatusCreated))
}

func (s *HTTPSuite) TestGet200ModelA201ModelC404ModelDDefaultError404Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA201ModelC404ModelDDefaultError404Valid()
	c.Assert(err, chk.IsNil)
	c.Assert((*res.Value)["httpStatusCode"], chk.Equals, strconv.Itoa(http.StatusNotFound))
}

func (s *HTTPSuite) TestGet200ModelA201ModelC404ModelDDefaultError400Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA201ModelC404ModelDDefaultError400Valid()
	// can't decode error to DetailedError -- resp body is { code: , message:} not in error object format.
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet202None204NoneDefaultError202None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultError202None()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
}

func (s *HTTPSuite) TestGet202None204NoneDefaultError204None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultError204None()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestGet202None204NoneDefaultError400Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultError400Valid()
	// can't decode the service because it is coming as { "code": , "message":} instead of "error": { "code":, "message":}
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
	//According to swagger, "description": "Send a 400 response with valid payload: {'code': '400', 'message': 'client error'}"
}

func (s *HTTPSuite) TestGet202None204NoneDefaultNone202Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultNone202Invalid()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusAccepted)
	//According to swagger, "description": "Send a 202 response with an unexpected payload {'property': 'value'}"
}

func (s *HTTPSuite) TestGet202None204NoneDefaultNone204None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultNone204None()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusNoContent)
}

func (s *HTTPSuite) TestGet202None204NoneDefaultNone400None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultNone400None()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet202None204NoneDefaultNone400Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get202None204NoneDefaultNone400Invalid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
	//according to swagger, "description": "Send a 400 response with an unexpected payload {'property': 'value'}"
}

func (s *HTTPSuite) TestGetDefaultModelA200Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultModelA200Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.StatusCode, chk.Equals, "200")
	//according to swagger, "description": "Send a 200 response with valid payload: {'statusCode': '200'}"
}

func (s *HTTPSuite) TestGetDefaultModelA200None(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultModelA200None()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGetDefaultModelA400Valid(c *chk.C) {
	_, err := httpMultipleResponsesClient.GetDefaultModelA400Valid()
	v, ok := err.(autorest.DetailedError)
	c.Assert(ok, chk.Equals, true)
	c.Assert(v.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGetDefaultModelA400None(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultModelA400None()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.IsNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGetDefaultNone200Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultNone200Invalid()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGetDefaultNone200None(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultNone200None()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGetDefaultNone400Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultNone400Invalid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGetDefaultNone400None(c *chk.C) {
	res, err := httpMultipleResponsesClient.GetDefaultNone400None()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200ModelA200None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA200None()

	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.IsNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusOK)
}

func (s *HTTPSuite) TestGet200ModelA200Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA200Valid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.StatusCode, chk.Equals, strconv.Itoa(http.StatusOK))
}

func (s *HTTPSuite) TestGet200ModelA200Invalid(c *chk.C) {
	//? c.Assert(res.StatusCode, chk.IsNil) - VS - c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
	res, err := httpMultipleResponsesClient.Get200ModelA200Invalid()
	c.Assert(err, chk.IsNil)
	c.Assert(res.StatusCode, chk.IsNil)
	//c.Assert(res.StatusCode, chk.Equals, http.StatusOK)
	//acorrding to swagger, "description": "Send a 200 response with invalid payload {'statusCodeInvalid': '200'}"
}

func (s *HTTPSuite) TestGet200ModelA400None(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA400None()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200ModelA400Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA400Valid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200ModelA400Invalid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA400Invalid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusBadRequest)
}

func (s *HTTPSuite) TestGet200ModelA202Valid(c *chk.C) {
	res, err := httpMultipleResponsesClient.Get200ModelA202Valid()
	c.Assert(err, chk.NotNil)
	c.Assert(res.Response.StatusCode, chk.Equals, http.StatusAccepted)
}
