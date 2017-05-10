package paginggrouptest

import (
	"net/http"
	"testing"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/paging"
)

func Test(t *testing.T) { chk.TestingT(t) }

type PagingGroupSuite struct{}

var _ = chk.Suite(&PagingGroupSuite{})

var pagingClient = getPagingClient()
var clientID = "client-id"

func getPagingClient() PagingClient {
	c := NewPagingClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *PagingGroupSuite) TestGetMultiplePages(c *chk.C) {
	// Get pages one by one...
	res, err := pagingClient.GetMultiplePages(clientID, nil, nil)
	c.Assert(err, chk.IsNil)
	c.Assert(res.NextLink, chk.NotNil)
	count := 1
	for res.NextLink != nil {
		count++
		resNext, err := pagingClient.GetMultiplePagesNextResults(res)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)

	resChan, errChan := pagingClient.GetMultiplePagesComplete(clientID, nil, nil, nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetSinglePages(c *chk.C) {
	res, err := pagingClient.GetSinglePages()
	c.Assert(err, chk.IsNil)
	c.Assert(res.NextLink, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetOdataMultiplePages(c *chk.C) {
	res, err := pagingClient.GetOdataMultiplePages(clientID, nil, nil)
	c.Assert(err, chk.IsNil)
	c.Assert(res.OdataNextLink, chk.NotNil)
	count := 1
	for res.OdataNextLink != nil {
		count++
		resNext, err := pagingClient.GetOdataMultiplePagesNextResults(res)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)

	resChan, errChan := pagingClient.GetOdataMultiplePagesComplete(clientID, nil, nil, nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetMultiplePagesWithOffset(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesWithOffset(100, clientID, nil, nil)
	c.Assert(err, chk.IsNil)
	c.Assert(res.NextLink, chk.NotNil)
	count := 1
	for res.NextLink != nil {
		count++
		resNext, err := pagingClient.GetMultiplePagesWithOffsetNextResults(res)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(*(*res.Values)[0].Properties.ID, chk.Equals, int32(110))

	resChan, errChan := pagingClient.GetMultiplePagesWithOffsetComplete(100, clientID, nil, nil, nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetMultiplePagesRetryFirst(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesRetryFirst()
	c.Assert(err, chk.IsNil)
	count := 1
	for res.NextLink != nil {
		count++
		resNext, err := pagingClient.GetMultiplePagesRetryFirstNextResults(res)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)

	resChan, errChan := pagingClient.GetMultiplePagesRetryFirstComplete(nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetMultiplePagesRetrySecond(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesRetrySecond()
	c.Assert(err, chk.IsNil)
	count := 1
	for res.NextLink != nil {
		count++
		resNext, err := pagingClient.GetMultiplePagesRetrySecondNextResults(res)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)

	resChan, errChan := pagingClient.GetMultiplePagesRetrySecondComplete(nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}

func (s *PagingGroupSuite) TestGetSinglePagesFailure(c *chk.C) {
	res, err := pagingClient.GetSinglePagesFailure()
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)

	resChan, errChan := pagingClient.GetSinglePagesFailureComplete(nil)
	count := 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 0)
	c.Assert(<-errChan, chk.NotNil)
}

func (s *PagingGroupSuite) TestGetMultiplePagesFailure(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesFailure()
	c.Assert(err, chk.IsNil)
	c.Assert(res.NextLink, chk.NotNil)
	res, err = pagingClient.GetMultiplePagesFailureNextResults(res)
	c.Assert(err, chk.NotNil)
	c.Assert(res.StatusCode, chk.Equals, http.StatusBadRequest)

	resChan, errChan := pagingClient.GetMultiplePagesFailureComplete(nil)
	count := 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 1)
	c.Assert(<-errChan, chk.NotNil)
}

func (s *PagingGroupSuite) TestGetMultiplePagesFailureURI(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesFailureURI()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.NextLink, chk.Equals, "*&*#&$")
	_, err = pagingClient.GetMultiplePagesFailureURINextResults(res)
	c.Assert(err, chk.NotNil)
	c.Assert(err, chk.ErrorMatches, ".*No scheme detected in URL.*")

	resChan, errChan := pagingClient.GetMultiplePagesFailureURIComplete(nil)
	count := 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 1)
	err = <-errChan
	c.Assert(err, chk.NotNil)
	c.Assert(err, chk.ErrorMatches, ".*No scheme detected in URL.*")
}

func (s *PagingGroupSuite) TestGetMultiplePagesFragmentNextLink(c *chk.C) {
	res, err := pagingClient.GetMultiplePagesFragmentNextLink("1.6", "test_user")
	c.Assert(err, chk.IsNil)
	count := 1
	for res.OdataNextLink != nil {
		count++
		resNext, err := pagingClient.NextFragment("1.6", "test_user", *res.OdataNextLink)
		c.Assert(err, chk.IsNil)
		res = resNext
	}
	c.Assert(count, chk.Equals, 10)

	resChan, errChan := pagingClient.GetMultiplePagesFragmentNextLinkComplete("1.6", "test_user", nil)
	count = 0
	for item := range resChan {
		count++
		c.Assert(item, chk.NotNil)
	}
	c.Assert(count, chk.Equals, 10)
	c.Assert(<-errChan, chk.IsNil)
}
