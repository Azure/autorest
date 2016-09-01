package filegrouptest

import (
	"bufio"
	"io"
	"io/ioutil"
	"testing"

	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-file"
)

func Test(t *testing.T) { chk.TestingT(t) }

type FileSuite struct{}

var _ = chk.Suite(&FileSuite{})

var filesClient = getFileClient()

func getFileClient() FilesClient {
	c := NewFilesClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *FileSuite) TestGetFile(c *chk.C) {
	res, err := filesClient.GetFile()
	c.Assert(err, chk.IsNil)
	b, err := ioutil.ReadAll(*res.Value)
	defer func() { (res.Body).Close() }()
	c.Assert(err, chk.IsNil)
	c.Assert(len(b), chk.Equals, 8725)
}

func (s *FileSuite) TestGetEmptyFile(c *chk.C) {
	res, err := filesClient.GetEmptyFile()
	c.Assert(err, chk.IsNil)
	b, err := ioutil.ReadAll(*res.Value)
	defer func() { (res.Body).Close() }()
	c.Assert(err, chk.IsNil)
	c.Assert(len(b), chk.Equals, 0)
}

func (s *FileSuite) TestGetFileLarge(c *chk.C) {
	res, err := filesClient.GetFileLarge()
	c.Assert(err, chk.IsNil)
	numberOfBytes, err := readLargeFile(*res.Value)
	c.Assert(err, chk.IsNil)
	c.Assert(numberOfBytes, chk.Equals, 3000*1024*1024)
}

func readLargeFile(b io.ReadCloser) (int, error) {
	r := bufio.NewReader(b)
	buf := make([]byte, 1024*1024)
	length := 0
	for {
		n, err := r.Read(buf)
		if err != nil && err != io.EOF {
			return 0, err
		}
		if n == 0 {
			break
		}
		length += n
	}
	return length, nil
}
