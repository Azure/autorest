package stringgrouptest

import (
	"testing"

	"tests/acceptancetests/utils"
	. "tests/generated/body-string"

	chk "gopkg.in/check.v1"
)

// Not in coverage yet
// So swagger files are not changed, code for this tests won't be generated
// TestGetBase64Encoded
// TestGetBase64UrlEncoded
// TestPutBase64UrlEncoded
// TestGetNullBase64UrlEncoded

func Test(t *testing.T) { chk.TestingT(t) }

type StringSuite struct{}

var _ = chk.Suite(&StringSuite{})

var stringClient = getStringClient()
var enumClient = getEnumClient()

func getStringClient() OperationsClient {
	c := NewOperationsClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getEnumClient() EnumClient {
	c := NewEnumClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

const (
	multibyteBufferBody = "啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€"
	whitespaceText      = "    Now is the time for all good men to come to the aid of their country    "
	emptyString         = ""
)

func (s *StringSuite) TestGetEmptyString(c *chk.C) {
	str, err := stringClient.GetEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*str.Value, chk.HasLen, 0)
	c.Assert(*str.Value, chk.Equals, emptyString)
}

func (s *StringSuite) TestGetMbcs(c *chk.C) {
	str, err := stringClient.GetMbcs()
	c.Assert(err, chk.IsNil)
	c.Assert(*str.Value, chk.Equals, multibyteBufferBody)
}

func (s *StringSuite) TestGetNotProvided(c *chk.C) {
	str, err := stringClient.GetNotProvided()
	c.Assert(err, chk.IsNil)
	c.Assert(str.Value, chk.IsNil)
}

func (s *StringSuite) TestGetNullString(c *chk.C) {
	str, err := stringClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(str.Value, chk.IsNil)
}

func (s *StringSuite) TestGetWhitespace(c *chk.C) {
	str, err := stringClient.GetWhitespace()
	c.Assert(err, chk.IsNil)
	c.Assert(*str.Value, chk.Equals, whitespaceText)
}

func (s *StringSuite) TestPutEmptyString(c *chk.C) {
	_, err := stringClient.PutEmpty(emptyString)
	c.Assert(err, chk.IsNil)
}

func (s *StringSuite) TestPutMbcs(c *chk.C) {
	_, err := stringClient.PutMbcs(multibyteBufferBody)
	c.Assert(err, chk.IsNil)
}

func (s *StringSuite) TestPutWhitespace(c *chk.C) {
	_, err := stringClient.PutWhitespace(whitespaceText)
	c.Assert(err, chk.IsNil)
}

// Go doesn't support Null String
func (s *StringSuite) TestPutNullString(c *chk.C) {
	_, err := stringClient.PutNull("")
	c.Assert(err, chk.IsNil)
}

// func (s *StringSuite) TestGetBase64Encoded(c *chk.C) {
// 	res, err := stringClient.GetBase64Encoded()
// 	c.Assert(err, chk.IsNil)
// 	var expected []byte
// 	base64.StdEncoding.Encode(expected, []byte("a string that gets encoded with base64"))
// 	c.Assert(res.Value, chk.DeepEquals, expected)
// }

// func (s *StringSuite) TestGetBase64UrlEncoded(c *chk.C) {
// 	res, err := stringClient.GetBase64UrlEncoded()
// 	c.Assert(err, chk.IsNil)
// 	var expected []byte
// 	base64.URLEncoding.Encode(expected, []byte("a string that gets encoded with base64url"))
// 	c.Assert(res.Value, chk.DeepEquals, expected)
// }

// func (s *StringSuite) TestPutBase64UrlEncoded(c *chk.C) {
// 	var encoded []byte
// 	base64.URLEncoding.Encode(encoded, []byte("a string that gets encoded with base64url"))
// 	_, err := stringClient.PutBase64UrlEncoded(encoded)
// 	c.Assert(err, chk.IsNil)
// }

// func (s *StringSuite) TestGetNullBase64UrlEncoded(c *chk.C) {
// 	res, err := stringClient.GetNullBase64UrlEncoded()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(res.Value, chk.IsNil)
// }

func (s *StringSuite) TestGetNotExpandable(c *chk.C) {
	str, err := enumClient.GetNotExpandable()
	c.Assert(err, chk.IsNil)
	c.Assert(*str.Value, chk.Equals, "red color")
}

func (s *StringSuite) TestPutNotExpandable(c *chk.C) {
	_, err := enumClient.PutNotExpandable("red color")
	c.Assert(err, chk.IsNil)
}
