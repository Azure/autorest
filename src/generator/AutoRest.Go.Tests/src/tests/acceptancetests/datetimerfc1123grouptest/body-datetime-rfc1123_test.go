package datetimerfc1123grouptest

import (
	"strings"
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest/date"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-datetime-rfc1123"
)

func Test(t *testing.T) { chk.TestingT(t) }

type DateTimeRfc1123GroupSuite struct{}

var _ = chk.Suite(&DateTimeRfc1123GroupSuite{})
var datetimerfc1123Client = getDateTimeRFC1123Client()

func getDateTimeRFC1123Client() Datetimerfc1123Client {
	c := NewDatetimerfc1123Client()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *DateTimeRfc1123GroupSuite) TestGetInvalidDateTimeRFC1123(c *chk.C) {
	_, err := datetimerfc1123Client.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *DateTimeRfc1123GroupSuite) TestGetNullDateTimeRFC1123(c *chk.C) {
	res, err := datetimerfc1123Client.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *DateTimeRfc1123GroupSuite) TestGetGetUnderflowDateTimeRFC1123(c *chk.C) {
	res, err := datetimerfc1123Client.GetUnderflow()
	c.Assert(err, chk.IsNil)
	t1, _ := time.Parse(time.RFC1123, "Tue, 00 Jan 0000 00:00:00 GMT")
	c.Assert((*res.Value).Time, chk.DeepEquals, t1)
}

func (s *DateTimeRfc1123GroupSuite) TestGetOverflowDateTimeRFC1123(c *chk.C) {
	_, err := datetimerfc1123Client.GetOverflow()
	c.Assert(err, chk.NotNil)
}

func (s *DateTimeRfc1123GroupSuite) TestGetUtcLowercaseMaxDateTimeRFC1123(c *chk.C) {
	res, err := datetimerfc1123Client.GetUtcLowercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	t1, _ := time.Parse(time.RFC1123, "Fri, 31 Dec 9999 23:59:59 GMT")
	c.Assert((*res.Value).Time, chk.DeepEquals, t1)
}

func (s *DateTimeRfc1123GroupSuite) TestGetUtcMinDateTimeRFC1123(c *chk.C) {
	res, err := datetimerfc1123Client.GetUtcMinDateTime()
	c.Assert(err, chk.IsNil)
	t1, _ := time.Parse(time.RFC1123, "Mon, 01 Jan 0001 00:00:00 GMT")
	c.Assert((*res.Value).Time, chk.DeepEquals, t1)
}

func (s *DateTimeRfc1123GroupSuite) TestGetUtcUppercaseMaxDateTimeRFC1123(c *chk.C) {
	res, err := datetimerfc1123Client.GetUtcUppercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	t1, _ := time.Parse(time.RFC1123, "Fri, 31 Dec 9999 23:59:59 GMT")
	c.Assert((*res.Value).Time, chk.DeepEquals, t1)
}

func (s *DateTimeRfc1123GroupSuite) TestPutUtcMaxDateTimeRFC1123(c *chk.C) {
	t1, _ := time.Parse(time.RFC1123, "Fri, 31 Dec 9999 23:59:59 GMT")
	_, err := datetimerfc1123Client.PutUtcMaxDateTime(date.TimeRFC1123{Time: t1})
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeRfc1123GroupSuite) TestPutUtcMinDateTimeRFC1123(c *chk.C) {
	t1, _ := time.Parse(time.RFC1123, "Mon, 1 Jan 0001 00:00:00 GMT")
	_, err := datetimerfc1123Client.PutUtcMinDateTime(date.TimeRFC1123{t1})
	c.Assert(err, chk.IsNil)
}

func toDateTimeRFC1123(s string) date.TimeRFC1123 {
	t, _ := time.Parse(time.RFC1123, strings.ToUpper(s))
	return date.TimeRFC1123{t}
}
