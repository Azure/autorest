package dictionarygrouptest

import (
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest/date"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-dictionary"
)

//TODO:
//TestGetBase64Url

func Test(t *testing.T) { chk.TestingT(t) }

type DictionaryGroupSuite struct{}

var _ = chk.Suite(&DictionaryGroupSuite{})

var dictionaryClient = getDictionaryClient()

func getDictionaryClient() DictionaryClient {
	c := NewDictionaryClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *DictionaryGroupSuite) TestGetArrayEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetArrayEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]string{})
}

func (s *DictionaryGroupSuite) TestGetArrayItemEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetArrayItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]string{
		"0": {"1", "2", "3"},
		"1": {},
		"2": {"7", "8", "9"},
	})
}

func (s *DictionaryGroupSuite) TestGetArrayItemNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetArrayItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]string{
		"0": {"1", "2", "3"},
		"1": nil,
		"2": {"7", "8", "9"},
	})
}

func (s *DictionaryGroupSuite) TestGetArrayNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetArrayNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestGetArrayValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetArrayValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]string{
		"0": {"1", "2", "3"},
		"1": {"4", "5", "6"},
		"2": {"7", "8", "9"},
	})
}

func (s *DictionaryGroupSuite) TestGetBooleanInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetBooleanInvalidNull()
	c.Assert(err, chk.IsNil)
	i, j := true, false
	c.Assert(*res.Value, chk.DeepEquals, map[string]*bool{"0": &i, "1": nil, "2": &j})
}

func (s *DictionaryGroupSuite) TestGetBooleanInvalidStringDictionary(c *chk.C) {
	_, err := dictionaryClient.GetBooleanInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetBooleanTfftDictionary(c *chk.C) {
	res, err := dictionaryClient.GetBooleanTfft()
	c.Assert(err, chk.IsNil)
	i, j := true, false
	c.Assert(*res.Value, chk.DeepEquals, map[string]*bool{"0": &i, "1": &j, "2": &j, "3": &i})
}

func (s *DictionaryGroupSuite) TestGetByteValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetByteValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]byte{
		"0": {255, 255, 255, 250},
		"1": {1, 2, 3},
		"2": {37, 41, 67},
	})
}

func (s *DictionaryGroupSuite) TestGetByteInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetByteInvalidNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string][]byte{"0": {171, 172, 173}, "1": nil})
}

// func (s *DictionaryGroupSuite) TestGetBase64Url(c *chk.C) {
// 	res, err := dictionaryClient.GetBase64Url()
// 	c.Assert(err, chk.IsNil)
// 	var val0, val1, val2 []byte
// 	base64.URLEncoding.Encode(val0, []byte("a string that gets encoded with base64url"))
// 	base64.URLEncoding.Encode(val1, []byte("test string"))
// 	base64.URLEncoding.Encode(val2, []byte("Lorem ipsum"))
// 	c.Assert(*res.Value, chk.DeepEquals, map[string][]byte{
// 		"0": val0,
// 		"1": val1,
// 		"2": val2})
// }

func (s *DictionaryGroupSuite) TestGetComplexEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetComplexEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getComplexDictionary("empty"))
}

func (s *DictionaryGroupSuite) TestGetComplexValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetComplexValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getComplexDictionary("valid"))
}

func (s *DictionaryGroupSuite) TestGetComplexNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetComplexNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestGetComplexItemNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetComplexItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getComplexDictionary("itemNull"))
}

func (s *DictionaryGroupSuite) TestGetComplexItemEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetComplexItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getComplexDictionary("itemEmpty"))
}

func (s *DictionaryGroupSuite) TestGetDateInvalidCharsDictionary(c *chk.C) {
	_, err := dictionaryClient.GetDateInvalidChars()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetDateInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDateInvalidNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]*date.Date{
		"0": &date.Date{time.Date(2012, time.January, 01, 0, 0, 0, 0, time.UTC)},
		"1": nil,
		"2": &date.Date{time.Date(1776, time.July, 04, 0, 0, 0, 0, time.UTC)},
	})
}

func (s *DictionaryGroupSuite) TestGetDateTimeInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDateTimeInvalidNull()
	c.Assert(err, chk.IsNil)
	dt1, _ := time.Parse(time.RFC3339, "2000-12-01T00:00:01Z")
	c.Assert(*res.Value, chk.DeepEquals, map[string]*date.Time{
		"0": &date.Time{dt1},
		"1": nil,
	})
}

func (s *DictionaryGroupSuite) TestGetDateTimeInvalidCharsDictionary(c *chk.C) {
	_, err := dictionaryClient.GetDateTimeInvalidChars()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetDateTimeRfc1123ValidDictionary(c *chk.C) {
	dt, err := dictionaryClient.GetDateTimeRfc1123Valid()
	c.Assert(err, chk.IsNil)
	dt1, _ := time.Parse(time.RFC1123, "Fri, 01 Dec 2000 00:00:01 GMT")
	dt2, _ := time.Parse(time.RFC1123, "Wed, 02 Jan 1980 00:11:35 GMT")
	dt3, _ := time.Parse(time.RFC1123, "Wed, 12 Oct 1492 10:15:01 GMT")
	c.Assert(*dt.Value, chk.DeepEquals, map[string]*date.TimeRFC1123{
		"0": &date.TimeRFC1123{dt1},
		"1": &date.TimeRFC1123{dt2},
		"2": &date.TimeRFC1123{dt3},
	})
}

func (s *DictionaryGroupSuite) TestGetDateTimeValidDictionary(c *chk.C) {
	dt, err := dictionaryClient.GetDateTimeValid()
	c.Assert(err, chk.IsNil)
	dt1, _ := time.Parse(time.RFC3339, "2000-12-01T00:00:01Z")
	dt2, _ := time.Parse(time.RFC3339, "1980-01-02T00:11:35+01:00")
	dt3, _ := time.Parse(time.RFC3339, "1492-10-12T10:15:01-08:00")
	c.Assert(*dt.Value, chk.DeepEquals, map[string]*date.Time{
		"0": &date.Time{dt1},
		"1": &date.Time{dt2},
		"2": &date.Time{dt3},
	})
}

func (s *DictionaryGroupSuite) TestGetDateValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDateValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]*date.Date{
		"0": &date.Date{time.Date(2000, time.December, 01, 0, 0, 0, 0, time.UTC)},
		"1": &date.Date{time.Date(1980, time.January, 02, 0, 0, 0, 0, time.UTC)},
		"2": &date.Date{time.Date(1492, time.October, 12, 0, 0, 0, 0, time.UTC)},
	})
}

func (s *DictionaryGroupSuite) TestGetDictionaryEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDictionaryEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]map[string]string{})
}

func (s *DictionaryGroupSuite) TestGetDictionaryItemEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDictionaryItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]map[string]string{
		"0": {"1": "one", "2": "two", "3": "three"},
		"1": {},
		"2": {"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *DictionaryGroupSuite) TestGetDictionaryItemNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDictionaryItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]map[string]string{
		"0": {"1": "one", "2": "two", "3": "three"},
		"1": nil,
		"2": {"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *DictionaryGroupSuite) TestGetDictionaryNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDictionaryNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestGetDictionaryValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDictionaryValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]map[string]string{
		"0": {"1": "one", "2": "two", "3": "three"},
		"1": {"4": "four", "5": "five", "6": "six"},
		"2": {"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *DictionaryGroupSuite) TestGetDoubleInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDoubleInvalidNull()
	c.Assert(err, chk.IsNil)
	f1, f2 := 0.0, -1.2e20
	c.Assert(*res.Value, chk.DeepEquals, map[string]*float64{"0": &f1, "1": nil, "2": &f2})
}

func (s *DictionaryGroupSuite) TestGetDoubleInvalidStringDictionary(c *chk.C) {
	_, err := dictionaryClient.GetDoubleInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetDoubleValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDoubleValid()
	c.Assert(err, chk.IsNil)
	f1, f2, f3 := 0.0, -0.01, -1.2e20
	expected := map[string]*float64{"0": &f1, "1": &f2, "2": &f3}
	c.Assert(*res.Value, chk.DeepEquals, expected)
}

func (s *DictionaryGroupSuite) TestGetDurationValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetDurationValid()
	c.Assert(err, chk.IsNil)
	timespan1, timespan2 := "P123DT22H14M12.011S", "P5DT1H"
	c.Assert(*res.Value, chk.DeepEquals, map[string]*string{"0": &timespan1, "1": &timespan2})
}

func (s *DictionaryGroupSuite) TestGetEmptyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]*int32{})
}

func (s *DictionaryGroupSuite) TestGetEmptyStringKeyDictionary(c *chk.C) {
	res, err := dictionaryClient.GetEmptyStringKey()
	c.Assert(err, chk.IsNil)
	str := "val1"
	c.Assert(*res.Value, chk.DeepEquals, map[string]*string{"": &str})
}

func (s *DictionaryGroupSuite) TestGetFloatInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetFloatInvalidNull()
	c.Assert(err, chk.IsNil)
	f1, f3 := 0.0, -1.2e20
	c.Assert(*res.Value, chk.DeepEquals, map[string]*float64{"0": &f1, "1": nil, "2": &f3})
}

func (s *DictionaryGroupSuite) TestGetFloatInvalidStringDictionary(c *chk.C) {
	_, err := dictionaryClient.GetFloatInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetFloatValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetFloatValid()
	c.Assert(err, chk.IsNil)
	f1, f2, f3 := 0.0, -0.01, -1.2e20
	c.Assert(*res.Value, chk.DeepEquals, map[string]*float64{"0": &f1, "1": &f2, "2": &f3})
}

func (s *DictionaryGroupSuite) TestGetIntegerValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetIntegerValid()
	c.Assert(err, chk.IsNil)
	var i1, i2, i3, i4 int32 = 1, -1, 3, 300
	c.Assert(*res.Value, chk.DeepEquals, map[string]*int32{"0": &i1, "1": &i2, "2": &i3, "3": &i4})
}

func (s *DictionaryGroupSuite) TestGetIntInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetIntInvalidNull()
	c.Assert(err, chk.IsNil)
	var i1, i2 int32 = 1, 0
	c.Assert(*res.Value, chk.DeepEquals, map[string]*int32{"0": &i1, "1": nil, "2": &i2})
}

func (s *DictionaryGroupSuite) TestGetIntInvalidStringDictionary(c *chk.C) {
	_, err := dictionaryClient.GetIntInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetInvalidDictionary(c *chk.C) {
	_, err := dictionaryClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetLongInvalidNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetLongInvalidNull()
	c.Assert(err, chk.IsNil)
	var i1, i2 int64 = 1, 0
	c.Assert(*res.Value, chk.DeepEquals, map[string]*int64{"0": &i1, "1": nil, "2": &i2})
}

func (s *DictionaryGroupSuite) TestGetLongInvalidStringDictionary(c *chk.C) {
	_, err := dictionaryClient.GetLongInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetLongValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetLongValid()
	c.Assert(err, chk.IsNil)
	var i1, i2, i3, i4 int64 = 1, -1, 3, 300
	c.Assert(*res.Value, chk.DeepEquals, map[string]*int64{"0": &i1, "1": &i2, "2": &i3, "3": &i4})
}

func (s *DictionaryGroupSuite) TestGetNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestGetNullKeyDictionary(c *chk.C) {
	_, err := dictionaryClient.GetNullKey()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetNullValueDictionary(c *chk.C) {
	res, err := dictionaryClient.GetNullValue()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, map[string]*string{"key1": nil})
}

func (s *DictionaryGroupSuite) TestGetStringValidDictionary(c *chk.C) {
	res, err := dictionaryClient.GetStringValid()
	c.Assert(err, chk.IsNil)
	str0, str1, str2 := "foo1", "foo2", "foo3"
	c.Assert(*res.Value, chk.DeepEquals, map[string]*string{"0": &str0, "1": &str1, "2": &str2})
}

func (s *DictionaryGroupSuite) TestGetStringWithInvalidDictionary(c *chk.C) {
	_, err := dictionaryClient.GetStringWithInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *DictionaryGroupSuite) TestGetStringWithNullDictionary(c *chk.C) {
	res, err := dictionaryClient.GetStringWithNull()
	c.Assert(err, chk.IsNil)
	str0, str2 := "foo", "foo2"
	c.Assert(*res.Value, chk.DeepEquals, map[string]*string{"0": &str0, "1": nil, "2": &str2})
}

func (s *DictionaryGroupSuite) TestPutArrayValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutArrayValid(map[string][]string{
		"0": {"1", "2", "3"},
		"1": {"4", "5", "6"},
		"2": {"7", "8", "9"},
	})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutBooleanTfftDictionary(c *chk.C) {
	_, err := dictionaryClient.PutBooleanTfft(map[string]bool{"0": true,
		"1": false,
		"2": false,
		"3": true})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutByteValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutByteValid(map[string][]byte{
		"0": {255, 255, 255, 250},
		"1": {1, 2, 3},
		"2": {37, 41, 67},
	})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDateTimeRfc1123ValidDictionary(c *chk.C) {
	dt1, _ := time.Parse(time.RFC1123, "Fri, 01 Dec 2000 00:00:01 GMT")
	dt2, _ := time.Parse(time.RFC1123, "Wed, 02 Jan 1980 00:11:35 GMT")
	dt3, _ := time.Parse(time.RFC1123, "Wed, 12 Oct 1492 10:15:01 GMT")
	_, err := dictionaryClient.PutDateTimeRfc1123Valid(map[string]date.TimeRFC1123{
		"0": date.TimeRFC1123{dt1},
		"1": date.TimeRFC1123{dt2},
		"2": date.TimeRFC1123{dt3},
	})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutLongValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutLongValid(map[string]int64{
		"0": 1,
		"1": -1,
		"2": 3,
		"3": 300})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutIntegerValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutIntegerValid(map[string]int32{
		"0": 1,
		"1": -1,
		"2": 3,
		"3": 300})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutFloatValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutFloatValid(map[string]float64{
		"0": 0.0,
		"1": -0.01,
		"2": -1.2e20})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDurationValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutDurationValid(map[string]string{
		"0": "P123DT22H14M12.011S",
		"1": "P5DT1H"})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDoubleValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutDoubleValid(map[string]float64{
		"0": 0.0,
		"1": -0.01,
		"2": -1.2e20})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDictionaryValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutDictionaryValid(map[string]map[string]string{
		"0": {"1": "one", "2": "two", "3": "three"},
		"1": {"4": "four", "5": "five", "6": "six"},
		"2": {"7": "seven", "8": "eight", "9": "nine"},
	})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDateTimeValidDictionary(c *chk.C) {
	dt1, _ := time.Parse(time.RFC3339, "2000-12-01T00:00:01Z")
	dt2, _ := time.Parse(time.RFC3339, "1980-01-01T23:11:35Z")
	dt3, _ := time.Parse(time.RFC3339, "1492-10-12T18:15:01Z")
	dic := map[string]date.Time{
		"0": date.Time{dt1},
		"1": date.Time{dt2},
		"2": date.Time{dt3},
	}
	_, err := dictionaryClient.PutDateTimeValid(dic)
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutDateValidDictionary(c *chk.C) {
	_, err := dictionaryClient.PutDateValid(map[string]date.Date{
		"0": date.Date{time.Date(2000, time.December, 01, 0, 0, 0, 0, time.UTC)},
		"1": date.Date{time.Date(1980, time.January, 02, 0, 0, 0, 0, time.UTC)},
		"2": date.Date{time.Date(1492, time.October, 12, 0, 0, 0, 0, time.UTC)},
	})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutStringValidDictionary(c *chk.C) {
	dic := map[string]string{"0": "foo1", "1": "foo2", "2": "foo3"}
	_, err := dictionaryClient.PutStringValid(dic)
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutEmptyDictionary(c *chk.C) {
	_, err := dictionaryClient.PutEmpty(map[string]string{})
	c.Assert(err, chk.IsNil)
}

func (s *DictionaryGroupSuite) TestPutComplexValidDictionary(c *chk.C) {
	var i0, i1, i2 int32 = 1, 3, 5
	var str0, str1, str2 = "2", "4", "6"
	_, err := dictionaryClient.PutComplexValid(map[string]Widget{
		"0": Widget{&i0, &str0},
		"1": Widget{&i1, &str1},
		"2": Widget{&i2, &str2},
	})
	c.Assert(err, chk.IsNil)
}

func getComplexDictionary(str string) map[string]*Widget {
	var i0, i1, i2 int32 = 1, 3, 5
	var str0, str1, str2 string = "2", "4", "6"
	var complexDictionary map[string]*Widget
	switch str {
	case "valid":
		complexDictionary = map[string]*Widget{
			"0": &Widget{&i0, &str0},
			"1": &Widget{&i1, &str1},
			"2": &Widget{&i2, &str2},
		}
	case "itemEmpty":
		complexDictionary = map[string]*Widget{
			"0": &Widget{&i0, &str0},
			"1": &Widget{},
			"2": &Widget{&i2, &str2},
		}
	case "itemNull":
		complexDictionary = map[string]*Widget{
			"0": &Widget{&i0, &str0},
			"1": nil,
			"2": &Widget{&i2, &str2},
		}
	case "empty":
		complexDictionary = map[string]*Widget{}
	}

	return complexDictionary
}
