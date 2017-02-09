package custombaseurlgrouptest

import (
	"testing"

	chk "gopkg.in/check.v1"

	. "tests/generated/custom-baseurl"
)

func Test(t *testing.T) { chk.TestingT(t) }

type CustomBaseURLGroupSuite struct{}

var _ = chk.Suite(&CustomBaseURLGroupSuite{})

var custombaseuriClient = getCustomBaseURIClient()

func getCustomBaseURIClient() PathsClient {
	c := NewWithoutDefaults("host:3000")
	return PathsClient{ManagementClient: c}
}

func (s *CustomBaseURLGroupSuite) TestCustomBaseUriPositive(c *chk.C) {
	_, err := custombaseuriClient.GetEmpty("local")
	c.Assert(err, chk.IsNil)
}

func (s *CustomBaseURLGroupSuite) TestCustomBaseUriNegative(c *chk.C) {
	_, err := custombaseuriClient.GetEmpty("badhost:3000")
	c.Assert(err, chk.NotNil)

	custombaseuriClient.RetryAttempts = 0
	_, err = custombaseuriClient.GetEmpty("bad")
	c.Assert(err, chk.NotNil)
}
