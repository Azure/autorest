package booleangrouptest

import (
	"testing"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-boolean"
)

func Test(t *testing.T) { chk.TestingT(t) }

type BoolGroupSuite struct{}

var _ = chk.Suite(&BoolGroupSuite{})

var boolClient = getBooleanClient()

func getBooleanClient() BoolGroupClient {
	c := NewBoolGroupClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *BoolGroupSuite) TestGetTrue(c *chk.C) {
	res, err := boolClient.GetTrue()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, true)
}

func (s *BoolGroupSuite) TestPutTrue(c *chk.C) {
	_, err := boolClient.PutTrue(true)
	c.Assert(err, chk.IsNil)
}

func (s *BoolGroupSuite) TestGetFalse(c *chk.C) {
	res, err := boolClient.GetFalse()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, false)
}

func (s *BoolGroupSuite) TestPutFalse(c *chk.C) {
	_, err := boolClient.PutFalse(false)
	c.Assert(err, chk.IsNil)
}

func (s *BoolGroupSuite) TestGetInvalidBool(c *chk.C) {
	_, err := boolClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *BoolGroupSuite) TestGetNullBool(c *chk.C) {
	res, err := boolClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}
