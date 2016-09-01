package datetimegrouptest

import (
	"testing"
	"time"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-datetime"
)

func Test(t *testing.T) { chk.TestingT(t) }

type DateTimeGroupSuite struct{}

var _ = chk.Suite(&DateTimeGroupSuite{})
var datetimeClient = getDateTimeClient()

func getDateTimeClient() DatetimeClient {
	c := NewDatetimeClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *DateTimeGroupSuite) TestGetInvalidDateTime(c *chk.C) {
	_, err := datetimeClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *DateTimeGroupSuite) TestGetLocalNegativeOffsetLowercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalNegativeOffsetLowercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31t23:59:59.9999999-14:00"))
}

func (s *DateTimeGroupSuite) TestGetLocalNegativeOffsetMinDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalNegativeOffsetMinDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("0001-01-01T00:00:00-14:00"))
}

func (s *DateTimeGroupSuite) TestGetLocalNegativeOffsetUppercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalNegativeOffsetUppercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31T23:59:59.9999999-14:00"))
}

func (s *DateTimeGroupSuite) TestGetLocalPositiveOffsetLowercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalPositiveOffsetLowercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31T23:59:59.9999999+14:00"))
}

func (s *DateTimeGroupSuite) TestGetLocalPositiveOffsetMinDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalPositiveOffsetMinDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("0001-01-01T00:00:00+14:00"))
}

func (s *DateTimeGroupSuite) TestGetLocalPositiveOffsetUppercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetLocalPositiveOffsetUppercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31T23:59:59.9999999+14:00"))
}

func (s *DateTimeGroupSuite) TestGetNullDateTime(c *chk.C) {
	dt, err := datetimeClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(dt.Value, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestGetOverflow(c *chk.C) {
	ti, err := datetimeClient.GetOverflow()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31T23:59:59.9999999-14:00"))
}

func (s *DateTimeGroupSuite) TestGetUnderflow(c *chk.C) {
	_, err := datetimeClient.GetUnderflow()
	c.Assert(err, chk.NotNil)
}

func (s *DateTimeGroupSuite) TestGetUtcLowercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetUtcLowercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("9999-12-31T23:59:59.9999999Z"))
}

func (s *DateTimeGroupSuite) TestGetUtcMinDateTime(c *chk.C) {
	ti, err := datetimeClient.GetUtcMinDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert(*ti.Value, chk.DeepEquals, utils.ToDateTime("0001-01-01T00:00:00Z"))
}

func (s *DateTimeGroupSuite) TestGetUtcUppercaseMaxDateTime(c *chk.C) {
	ti, err := datetimeClient.GetUtcUppercaseMaxDateTime()
	c.Assert(err, chk.IsNil)
	c.Assert((*ti.Value).Format(time.RFC3339), chk.Equals, "9999-12-31T23:59:59Z")
}

func (s *DateTimeGroupSuite) TestPutLocalNegativeOffsetMaxDateTime(c *chk.C) {
	dt := utils.ToDateTime("9999-12-31T23:59:59.9999999-14:00")
	_, err := datetimeClient.PutLocalNegativeOffsetMaxDateTime(dt)
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestPutLocalNegativeOffsetMinDateTime(c *chk.C) {
	dt := utils.ToDateTime("0001-01-01T00:00:00-14:00")
	_, err := datetimeClient.PutLocalNegativeOffsetMinDateTime(dt)
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestPutLocalPositiveOffsetMaxDateTime(c *chk.C) {
	dt := utils.ToDateTime("9999-12-31T23:59:59.9999999+14:00")
	_, err := datetimeClient.PutLocalPositiveOffsetMaxDateTime(dt)
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestPutLocalPositiveOffsetMinDateTime(c *chk.C) {
	dt := utils.ToDateTime("0001-01-01T00:00:00+14:00")
	_, err := datetimeClient.PutLocalPositiveOffsetMinDateTime(dt)
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestPutUtcMaxDateTime(c *chk.C) {
	dt := utils.ToDateTime("9999-12-31T23:59:59.9999999Z")
	_, err := datetimeClient.PutUtcMaxDateTime(dt)
	c.Assert(err, chk.IsNil)
}

func (s *DateTimeGroupSuite) TestPutUtcMinDateTime(c *chk.C) {
	dt := utils.ToDateTime("0001-01-01T00:00:00Z")
	_, err := datetimeClient.PutUtcMinDateTime(dt)
	c.Assert(err, chk.IsNil)
}
