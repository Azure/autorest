package formdatagrouptest

import (
	"bytes"
	"io/ioutil"
	"testing"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-formdata"
)

func Test(t *testing.T) { chk.TestingT(t) }

type FormdataSuite struct{}

var _ = chk.Suite(&FormdataSuite{})
var formdataClient = getFormdataClient()

func getFormdataClient() FormdataClient {
	c := NewFormdataClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *FormdataSuite) TestUploadFileViaBody(c *chk.C) {
	f, err := ioutil.ReadFile("../sample.png")
	c.Assert(err, chk.IsNil)
	res, err := formdataClient.UploadFileViaBody(ioutil.NopCloser(bytes.NewReader(f)))
	c.Assert(err, chk.IsNil)
	buf := new(bytes.Buffer)
	buf.ReadFrom(*res.Value)
	b := buf.Bytes()
	defer (*res.Value).Close()
	c.Assert(len(b), chk.Equals, len(f))
	c.Assert(string(b), chk.Equals, string(f))
}

func (s *FormdataSuite) TestUploadFile(c *chk.C) {
	f, err := ioutil.ReadFile("../sample.png")
	c.Assert(err, chk.IsNil)
	res, err := formdataClient.UploadFile(ioutil.NopCloser(bytes.NewReader(f)), "samplefile")
	c.Assert(err, chk.IsNil)
	buf := new(bytes.Buffer)
	buf.ReadFrom(*res.Value)
	b := buf.Bytes()
	defer (*res.Value).Close()
	c.Assert(len(b), chk.Equals, len(f))
	c.Assert(string(b), chk.Equals, string(f))
}
