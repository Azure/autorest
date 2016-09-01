package integergrouptest

import (
	"math"
	"testing"

	"tests/acceptancetests/utils"
	. "tests/generated/body-integer"

	chk "gopkg.in/check.v1"
)

// Not yet in coverage
// So swagger files are not changed, code for this tests won't be generated
// TestGetUnixTime
// TestPutUnixTimeDate
// TestGetInvalidUnixTime
// TestGetNullUnixTime

func Test(t *testing.T) { chk.TestingT(t) }

type IntegerSuite struct{}

var _ = chk.Suite(&IntegerSuite{})

var intClient = getIntegerClient()

func getIntegerClient() IntGroupClient {
	c := NewIntGroupClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *IntegerSuite) TestGetInvalidInt(c *chk.C) {
	_, err := intClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *IntegerSuite) TestGetNullInt(c *chk.C) {
	res, err := intClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *IntegerSuite) TestGetOverflowInt32(c *chk.C) {
	_, err := intClient.GetOverflowInt32()
	c.Assert(err, chk.NotNil)
}

func (s *IntegerSuite) TestGetOverflowInt64(c *chk.C) {
	_, err := intClient.GetOverflowInt64()
	c.Assert(err, chk.NotNil)
}

func (s *IntegerSuite) TestGetUnderflowInt32(c *chk.C) {
	_, err := intClient.GetUnderflowInt32()
	c.Assert(err, chk.NotNil)
}

func (s *IntegerSuite) TestGetUnderflowInt64(c *chk.C) {
	_, err := intClient.GetUnderflowInt64()
	c.Assert(err, chk.NotNil)
}

func (s *IntegerSuite) TestPutMax32(c *chk.C) {
	_, err := intClient.PutMax32(int32(math.MaxInt32))
	c.Assert(err, chk.IsNil)
}

func (s *IntegerSuite) TestPutMax64(c *chk.C) {
	_, err := intClient.PutMax64(int64(math.MaxInt64))
	c.Assert(err, chk.IsNil)
}

func (s *IntegerSuite) TestPutMin32(c *chk.C) {
	_, err := intClient.PutMin32(int32(math.MinInt32))
	c.Assert(err, chk.IsNil)
}

func (s *IntegerSuite) TestPutMin64(c *chk.C) {
	_, err := intClient.PutMin64(int64(math.MinInt64))
	c.Assert(err, chk.IsNil)
}

// func (s *IntegerSuite) TestGetUnixTime(c *chk.C) {
// 	unixTime, err := intClient.GetUnixTime()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(unixTime, chk.Equals, time.Date(2016, time.April, 13, 0, 0, 0, 0, time.UTC).Unix())
// }

// func (s *IntegerSuite) TestPutUnixTimeDate(c *chk.C) {
// 	_, err := intClient.PutUnixTimeDate(time.Date(2016, time.April, 13, 0, 0, 0, 0, time.UTC).Unix())
// 	c.Assert(err, chk.IsNil)
// }

// func (s *IntegerSuite) TestGetInvalidUnixTime(c *chk.C) {
// 	_, err := intClient.GetInvalidUnixTime()
// 	c.Assert(err, chk.NotNil)
// }

// func (s *IntegerSuite) TestGetNullUnixTime(c *chk.C) {
// 	res, err := intClient.GetNullUnixTime()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.Value, chk.IsNil)
// }
