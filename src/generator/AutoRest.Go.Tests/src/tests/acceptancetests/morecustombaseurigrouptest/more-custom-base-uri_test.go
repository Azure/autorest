package morecustombaseurigrouptest

import (
	"testing"

	chk "gopkg.in/check.v1"

	. "tests/generated/more-custom-base-uri"
)

func Test(t *testing.T) { chk.TestingT(t) }

type MoreCustomBaseURIGroupSuite struct{}

var _ = chk.Suite(&MoreCustomBaseURIGroupSuite{})

var custombaseuriClient = getMoreCustomBaseURIClient()

func getMoreCustomBaseURIClient() PathsClient {
	c := NewWithoutDefaults("test12", "host:3000")
	return PathsClient{ManagementClient: c}
}

func (s *MoreCustomBaseURIGroupSuite) TestCustomBaseUriMoreOptions(c *chk.C) {
	_, err := custombaseuriClient.GetEmpty("http://lo", "cal", "key1", "v1")
	c.Assert(err, chk.IsNil)
}
