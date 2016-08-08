package headergrouptest

import (
	"encoding/base64"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest/date"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/header"
)

func Test(t *testing.T) { chk.TestingT(t) }

type HeaderSuite struct{}

var _ = chk.Suite(&HeaderSuite{})

var headerClient = getHeaderClient()

func getHeaderClient() HeaderClient {
	c := NewHeaderClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *HeaderSuite) TestHeaderParamFloatNegative(c *chk.C) {
	_, err := headerClient.ParamFloat("negative", -3.0)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseFloatNegative(c *chk.C) {
	res, err := headerClient.ResponseFloat("negative")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseFloat(res.Response.Header["Value"][0], 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, -3.0)
}

func (s *HeaderSuite) TestHeaderParamFloatPositive(c *chk.C) {
	_, err := headerClient.ParamFloat("positive", 0.07)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseFloatPositive(c *chk.C) {
	res, err := headerClient.ResponseFloat("positive")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseFloat(res.Response.Header["Value"][0], 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, 0.07)
}

func (s *HeaderSuite) TestHeaderParamDoubleNegative(c *chk.C) {
	_, err := headerClient.ParamDouble("negative", -3.0)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDoubleNegative(c *chk.C) {
	res, err := headerClient.ResponseDouble("negative")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseFloat(res.Response.Header["Value"][0], 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, -3.0)
}

func (s *HeaderSuite) TestHeaderParamDoublePositive(c *chk.C) {
	_, err := headerClient.ParamDouble("positive", 7e120)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDoublePositive(c *chk.C) {
	res, err := headerClient.ResponseDouble("positive")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseFloat(res.Response.Header["Value"][0], 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, 7e120)
}

func (s *HeaderSuite) TestHeaderParamBoolFalse(c *chk.C) {
	_, err := headerClient.ParamBool("false", false)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseBoolFalse(c *chk.C) {
	res, err := headerClient.ResponseBool("false")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseBool(res.Response.Header["Value"][0])
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, false)
}

func (s *HeaderSuite) TestHeaderParamBoolTrue(c *chk.C) {
	_, err := headerClient.ParamBool("true", true)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseBoolTrue(c *chk.C) {
	res, err := headerClient.ResponseBool("true")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseBool(res.Response.Header["Value"][0])
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, true)
}

func (s *HeaderSuite) TestHeaderParamIntPositive(c *chk.C) {
	_, err := headerClient.ParamInteger("positive", 1)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseIntPositive(c *chk.C) {
	res, err := headerClient.ResponseInteger("positive")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseInt(res.Response.Header["Value"][0], 10, 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, int64(1))
}

func (s *HeaderSuite) TestHeaderParamIntNegative(c *chk.C) {
	_, err := headerClient.ParamInteger("negative", -2)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseIntNegative(c *chk.C) {
	res, err := headerClient.ResponseInteger("negative")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseInt(res.Response.Header["Value"][0], 10, 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, int64(-2))
}

func (s *HeaderSuite) TestHeaderParamLongNegative(c *chk.C) {
	_, err := headerClient.ParamLong("negative", -2)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseLongNegative(c *chk.C) {
	res, err := headerClient.ResponseLong("negative")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseInt(res.Response.Header["Value"][0], 10, 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, int64(-2))
}

func (s *HeaderSuite) TestHeaderParamLongPositive(c *chk.C) {
	_, err := headerClient.ParamLong("positive", 105)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseLongPositive(c *chk.C) {
	res, err := headerClient.ResponseLong("positive")
	c.Assert(err, chk.IsNil)
	f, err := strconv.ParseInt(res.Response.Header["Value"][0], 10, 64)
	c.Assert(err, chk.IsNil)
	c.Assert(f, chk.Equals, int64(105))
}

func (s *HeaderSuite) TestHeaderParamStringValid(c *chk.C) {
	_, err := headerClient.ParamString("valid", "The quick brown fox jumps over the lazy dog")
	c.Assert(err, chk.IsNil)
}

// String can't be null in Go
func (s *HeaderSuite) TestHeaderParamStringNull(c *chk.C) {
	_, err := headerClient.ParamString("null", "")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderParamStringEmpty(c *chk.C) {
	_, err := headerClient.ParamString("empty", "")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseStringValid(c *chk.C) {
	res, err := headerClient.ResponseString("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, "The quick brown fox jumps over the lazy dog")
}

func (s *HeaderSuite) TestHeaderResponseStringNull(c *chk.C) {
	res, err := headerClient.ResponseString("null")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, "null")
}

func (s *HeaderSuite) TestHeaderResponseStringEmpty(c *chk.C) {
	res, err := headerClient.ResponseString("empty")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, "")
}

func (s *HeaderSuite) TestHeaderResponseEnumValid(c *chk.C) {
	res, err := headerClient.ResponseEnum("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, "GREY")
}

func (s *HeaderSuite) TestHeaderParamEnumValid(c *chk.C) {
	_, err := headerClient.ParamEnum("valid", "GREY")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseEnumNull(c *chk.C) {
	res, err := headerClient.ResponseEnum("null")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, "")
}

// String can't be null in Go
func (s *HeaderSuite) TestHeaderParamEnumNull(c *chk.C) {
	_, err := headerClient.ParamEnum("null", "")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderParamByteValid(c *chk.C) {
	encoded := base64.StdEncoding.EncodeToString([]byte("啊齄丂狛狜隣郎隣兀﨩"))
	_, err := headerClient.ParamByte("valid", []byte(encoded))
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseByteValid(c *chk.C) {
	res, err := headerClient.ResponseByte("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.Equals, base64.StdEncoding.EncodeToString([]byte("啊齄丂狛狜隣郎隣兀﨩")))
}

func (s *HeaderSuite) TestHeaderParamDateValid(c *chk.C) {
	_, err := headerClient.ParamDate("valid", date.Date{time.Date(2010, time.January, 01, 0, 0, 0, 0, time.UTC)})
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderParamDateMin(c *chk.C) {
	_, err := headerClient.ParamDate("min", date.Date{time.Date(0001, time.January, 01, 0, 0, 0, 0, time.UTC)})
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDateValid(c *chk.C) {
	res, err := headerClient.ResponseDate("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "2010-01-01")
}

func (s *HeaderSuite) TestHeaderResponseDateMin(c *chk.C) {
	res, err := headerClient.ResponseDate("min")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "0001-01-01")
}

func (s *HeaderSuite) TestHeaderParamDateTimeValid(c *chk.C) {
	_, err := headerClient.ParamDatetime("valid", utils.ToDateTime("2010-01-01T12:34:56Z"))
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderParamDateTimeMin(c *chk.C) {
	_, err := headerClient.ParamDatetime("min", utils.ToDateTime("0001-01-01T00:00:00Z"))
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDateTimeValid(c *chk.C) {
	res, err := headerClient.ResponseDatetime("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "2010-01-01T12:34:56Z")
}

func (s *HeaderSuite) TestHeaderResponseDateTimeMin(c *chk.C) {
	res, err := headerClient.ResponseDatetime("min")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "0001-01-01T00:00:00Z")
}

func (s *HeaderSuite) TestHeaderParamDateTimeRFC1123Valid(c *chk.C) {
	d := utils.ToDateTimeRFC1123("Wed, 01 Jan 2010 12:34:56 GMT")
	_, err := headerClient.ParamDatetimeRfc1123("valid", &d)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderParamDateTimeRFC1123Min(c *chk.C) {
	d := utils.ToDateTimeRFC1123("Mon, 01 Jan 0001 00:00:00 GMT")
	_, err := headerClient.ParamDatetimeRfc1123("min", &d)
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDateTimeRFC1123Valid(c *chk.C) {
	res, err := headerClient.ResponseDatetimeRfc1123("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "Fri, 01 Jan 2010 12:34:56 GMT")
}

func (s *HeaderSuite) TestHeaderResponseDateTimeRFC1123Min(c *chk.C) {
	res, err := headerClient.ResponseDatetimeRfc1123("min")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "Mon, 01 Jan 0001 00:00:00 GMT")
}

func (s *HeaderSuite) TestHeaderParamDurationValid(c *chk.C) {
	_, err := headerClient.ParamDuration("valid", "P123DT22H14M12.011S")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseDuration(c *chk.C) {
	res, err := headerClient.ResponseDuration("valid")
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["Value"][0], chk.DeepEquals, "P123DT22H14M12.011S")
}

func (s *HeaderSuite) TestHeaderParamExistingKey(c *chk.C) {
	_, err := headerClient.ParamExistingKey("overwrite")
	c.Assert(err, chk.IsNil)
}

func (s *HeaderSuite) TestHeaderResponseExistingKey(c *chk.C) {
	res, err := headerClient.ResponseExistingKey()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Response.Header["User-Agent"][0], chk.DeepEquals, "overwrite")
}

func (s *HeaderSuite) TestHeaderResponseProtectedKey(c *chk.C) {
	res, err := headerClient.ResponseProtectedKey()
	c.Assert(err, chk.IsNil)
	if !(strings.Contains(res.Response.Header["Content-Type"][0], "text/html")) {
		c.Errorf("Expected to contain '%v', got %v\n", "text/html", res.Response.Header["Content-Type"][0])
	}
}
