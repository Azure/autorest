package arraygrouptest

import (
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest/date"
	"github.com/satori/uuid"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-array"
)

//TODO:
//Base64Url tests

func Test(t *testing.T) { chk.TestingT(t) }

type ArrayGroupSuite struct{}

var _ = chk.Suite(&ArrayGroupSuite{})

var arrayClient = getArrayClient()

func getArrayClient() ArrayClient {
	c := NewArrayClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *ArrayGroupSuite) TestGetDictionaryEmptyArray(c *chk.C) {
	res, err := arrayClient.GetDictionaryEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []map[string]string{})
}

func (s *ArrayGroupSuite) TestGetArrayEmpty(c *chk.C) {
	res, err := arrayClient.GetArrayEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]string{})
}

func (s *ArrayGroupSuite) TestGetDictionaryItemEmptyArray(c *chk.C) {
	res, err := arrayClient.GetDictionaryItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []map[string]string{
		{"1": "one", "2": "two", "3": "three"},
		map[string]string{},
		{"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *ArrayGroupSuite) TestGetDictionaryItemNullArray(c *chk.C) {
	res, err := arrayClient.GetDictionaryItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []map[string]string{
		{"1": "one", "2": "two", "3": "three"},
		nil,
		{"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *ArrayGroupSuite) TestGetArrayItemEmpty(c *chk.C) {
	res, err := arrayClient.GetArrayItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]string{{"1", "2", "3"},
		{},
		{"7", "8", "9"}})
}

func (s *ArrayGroupSuite) TestGetArrayItemNull(c *chk.C) {
	res, err := arrayClient.GetArrayItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]string{{"1", "2", "3"},
		nil,
		{"7", "8", "9"}})
}

func (s *ArrayGroupSuite) TestGetArrayNull(c *chk.C) {
	arr, err := arrayClient.GetArrayNull()
	c.Assert(err, chk.IsNil)
	c.Assert(arr.Value, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetDictionaryNull(c *chk.C) {
	arr, err := arrayClient.GetDictionaryNull()
	c.Assert(err, chk.IsNil)
	c.Assert(arr.Value, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetEmptyArray(c *chk.C) {
	res, err := arrayClient.GetEmpty()
	if err != nil {
		c.SucceedNow()
	}
	c.Assert(*res.Value, chk.DeepEquals, []int32{})
}

func (s *ArrayGroupSuite) TestGetInvalidArray(c *chk.C) {
	_, err := arrayClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetNullArray(c *chk.C) {
	res, err := arrayClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetArrayValid(c *chk.C) {
	res, err := arrayClient.GetArrayValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]string{{"1", "2", "3"},
		{"4", "5", "6"},
		{"7", "8", "9"}})
}

/// change null to false (bool default value)
func (s *ArrayGroupSuite) TestGetBooleanInvalidNull(c *chk.C) {
	res, err := arrayClient.GetBooleanInvalidNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []bool{true, false, false})
}

func (s *ArrayGroupSuite) TestGetBooleanInvalidString(c *chk.C) {
	_, err := arrayClient.GetBooleanInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetBooleanTfft(c *chk.C) {
	res, err := arrayClient.GetBooleanTfft()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []bool{true, false, false, true})
}

func (s *ArrayGroupSuite) TestGetByteInvalidNullArray(c *chk.C) {
	res, err := arrayClient.GetByteInvalidNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]byte{{171, 172, 173}, nil})
}

func (s *ArrayGroupSuite) TestGetDictionaryValid(c *chk.C) {
	res, err := arrayClient.GetDictionaryValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []map[string]string{
		{"1": "one", "2": "two", "3": "three"},
		{"4": "four", "5": "five", "6": "six"},
		{"7": "seven", "8": "eight", "9": "nine"},
	})
}

func (s *ArrayGroupSuite) TestGetByteValidArray(c *chk.C) {
	res, err := arrayClient.GetByteValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, [][]byte{{255, 255, 255, 250},
		{1, 2, 3},
		{37, 41, 67}})
}

// func (s *ArrayGroupSuite) TestGetBase64Url(c *chk.C) {
// 	res, err := arrayClient.GetBase64Url()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(*res.Value, chk.HasLen, 3)
// 	c.Assert(*res.Value, chk.DeepEquals, []string{
// 		base64.URLEncoding.EncodeToString([]byte("a string that gets encoded with base64url")),
// 		base64.URLEncoding.EncodeToString([]byte("test string")),
// 		base64.URLEncoding.EncodeToString([]byte("Lorem ipsum"))})
// }

func (s *ArrayGroupSuite) TestGetComplexValidArray(c *chk.C) {
	res, err := arrayClient.GetComplexValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getProductArray("valid"))
}

func (s *ArrayGroupSuite) TestPutComplexValidArray(c *chk.C) {
	_, err := arrayClient.PutComplexValid(getProductArray("valid"))
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetComplexItemEmptyArray(c *chk.C) {
	res, err := arrayClient.GetComplexItemEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getProductArray("itemEmpty"))
}

func (s *ArrayGroupSuite) TestGetComplexItemNullArray(c *chk.C) {
	res, err := arrayClient.GetComplexItemNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getProductArray("itemNull"))
}

func (s *ArrayGroupSuite) TestGetComplexEmptyArray(c *chk.C) {
	res, err := arrayClient.GetComplexEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getProductArray("empty"))
}

func (s *ArrayGroupSuite) TestGetComplexNullArray(c *chk.C) {
	res, err := arrayClient.GetComplexNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetDateInvalidChars(c *chk.C) {
	_, err := arrayClient.GetDateInvalidChars()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetDateInvalidNull(c *chk.C) {
	_, err := arrayClient.GetDateInvalidNull()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetDateTimeInvalidChars(c *chk.C) {
	_, err := arrayClient.GetDateTimeInvalidChars()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetDateTimeInvalidNull(c *chk.C) {
	_, err := arrayClient.GetDateTimeInvalidNull()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetDateTimeValid(c *chk.C) {
	res, err := arrayClient.GetDateTimeValid()
	c.Assert(err, chk.IsNil)
	v1, _ := time.Parse(time.RFC3339, "2000-12-01T00:00:01Z")
	v2, _ := time.Parse(time.RFC3339, "1980-01-02T01:11:35+01:00")
	v3, _ := time.Parse(time.RFC3339, "1492-10-12T02:15:01-08:00")
	c.Assert(*res.Value, chk.DeepEquals, []date.Time{date.Time{v1}, date.Time{v2}, date.Time{v3}})
}

func (s *ArrayGroupSuite) TestGetDateTimeRfc1123ValidArray(c *chk.C) {
	res, err := arrayClient.GetDateTimeRfc1123Valid()
	c.Assert(err, chk.IsNil)
	v1, _ := time.Parse(time.RFC1123, "Fri, 01 Dec 2000 00:00:01 GMT")
	v2, _ := time.Parse(time.RFC1123, "Wed, 02 Jan 1980 00:11:35 GMT")
	v3, _ := time.Parse(time.RFC1123, "Wed, 12 Oct 1492 10:15:01 GMT")
	c.Assert(*res.Value, chk.DeepEquals, []date.TimeRFC1123{
		date.TimeRFC1123{v1},
		date.TimeRFC1123{v2},
		date.TimeRFC1123{v3},
	})
}

func (s *ArrayGroupSuite) TestGetDateValid(c *chk.C) {
	res, err := arrayClient.GetDateValid()
	if err != nil {
		c.Errorf("%v\n", err)
	}
	dateArray := []date.Date{date.Date{Time: time.Date(2000, time.December, 01, 0, 0, 0, 0, time.UTC)},
		date.Date{Time: time.Date(1980, time.January, 02, 0, 0, 0, 0, time.UTC)},
		date.Date{Time: time.Date(1492, time.October, 12, 0, 0, 0, 0, time.UTC)},
	}
	c.Assert(*res.Value, chk.DeepEquals, dateArray)
}

// convert null to 0 - Double default value
// {1, null, 0} ---> {1,0,0}
func (s *ArrayGroupSuite) TestGetDoubleInvalidNull(c *chk.C) {
	res, err := arrayClient.GetDoubleInvalidNull()
	if err != nil {
		c.SucceedNow()
	}
	c.Assert(*res.Value, chk.DeepEquals, []float64{0, 0, -1.2e20})
}

func (s *ArrayGroupSuite) TestGetDoubleInvalidString(c *chk.C) {
	_, err := arrayClient.GetDoubleInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetDoubleValid(c *chk.C) {
	res, err := arrayClient.GetDoubleValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []float64{0, -0.01, -1.2e20})
}

func (s *ArrayGroupSuite) TestGetDurationValid(c *chk.C) {
	res, err := arrayClient.GetDurationValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []string{"P123DT22H14M12.011S", "P5DT1H0M0S"})
}

// convert null to 0 - Float default value
// {1, null, 0} ---> {1,0,0}
func (s *ArrayGroupSuite) TestGetFloatInvalidNull(c *chk.C) {
	res, err := arrayClient.GetFloatInvalidNull()
	if err != nil {
		c.SucceedNow()
	}
	c.Assert(*res.Value, chk.DeepEquals, []float64{0, 0, -1.2e20})
}

func (s *ArrayGroupSuite) TestGetFloatInvalidString(c *chk.C) {
	_, err := arrayClient.GetFloatInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetFloatValid(c *chk.C) {
	res, err := arrayClient.GetFloatValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []float64{0, -0.01, -1.2e20})
}

func (s *ArrayGroupSuite) TestGetIntegerValid(c *chk.C) {
	res, err := arrayClient.GetIntegerValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []int32{1, -1, 3, 300})
}

// convert null to 0 - Int default value
// {1, null, 0} ---> {1,0,0}
func (s *ArrayGroupSuite) TestGetIntInvalidNull(c *chk.C) {
	res, err := arrayClient.GetIntInvalidNull()
	if err != nil {
		c.SucceedNow()
	}
	c.Assert(*res.Value, chk.DeepEquals, []int32{1, 0, 0})
}

func (s *ArrayGroupSuite) TestGetIntInvalidString(c *chk.C) {
	_, err := arrayClient.GetIntInvalidString()
	c.Assert(err, chk.NotNil)
}

// convert null to 0 - long default value
// {1, null, 0} ---> {1,0,0}
func (s *ArrayGroupSuite) TestGetLongInvalidNull(c *chk.C) {
	res, err := arrayClient.GetLongInvalidNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []int64{1, 0, 0})
}

func (s *ArrayGroupSuite) TestGetLongInvalidString(c *chk.C) {
	_, err := arrayClient.GetLongInvalidString()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetLongValid(c *chk.C) {
	res, err := arrayClient.GetLongValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []int64{1, -1, 3, 300})
}

func (s *ArrayGroupSuite) TestGetStringValid(c *chk.C) {
	res, err := arrayClient.GetStringValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []string{"foo1", "foo2", "foo3"})
}

func (s *ArrayGroupSuite) TestGetStringWithNull(c *chk.C) {
	res, err := arrayClient.GetStringWithNull()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, []string{"foo", "", "foo2"})
}

func (s *ArrayGroupSuite) TestGetStringWithInvalid(c *chk.C) {
	_, err := arrayClient.GetStringWithInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestPutArrayValid(c *chk.C) {
	_, err := arrayClient.PutArrayValid([][]string{{"1", "2", "3"},
		{"4", "5", "6"},
		{"7", "8", "9"}})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutEmptyArray(c *chk.C) {
	_, err := arrayClient.PutEmpty([]string{})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutDictionaryValid(c *chk.C) {
	_, err := arrayClient.PutDictionaryValid([]map[string]string{
		{"1": "one", "2": "two", "3": "three"},
		{"4": "four", "5": "five", "6": "six"},
		{"7": "seven", "8": "eight", "9": "nine"},
	})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutBooleanTfft(c *chk.C) {
	_, err := arrayClient.PutBooleanTfft([]bool{true, false, false, true})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutByteValid(c *chk.C) {
	_, err := arrayClient.PutByteValid([][]byte{
		[]byte{0xFF, 0xFF, 0xFF, 0xFA},
		[]byte{0x01, 0x02, 0x03},
		[]byte{0x25, 0x29, 0x43}})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutDateTimeValid(c *chk.C) {
	t1, _ := time.Parse(time.RFC3339, "2000-12-01T00:00:01Z")
	t2, _ := time.Parse(time.RFC3339, "1980-01-02T00:11:35Z")
	t3, _ := time.Parse(time.RFC3339, "1492-10-12T10:15:01Z")
	_, err := arrayClient.PutDateTimeValid([]date.Time{
		date.Time{Time: t1},
		date.Time{Time: t2},
		date.Time{Time: t3},
	})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutDateTimeRfc1123ValidArray(c *chk.C) {
	t1, _ := time.Parse(time.RFC1123, "Fri, 01 Dec 2000 00:00:01 GMT")
	t2, _ := time.Parse(time.RFC1123, "Wed, 02 Jan 1980 00:11:35 GMT")
	t3, _ := time.Parse(time.RFC1123, "Wed, 12 Oct 1492 10:15:01 GMT")
	_, err := arrayClient.PutDateTimeRfc1123Valid([]date.TimeRFC1123{
		date.TimeRFC1123{t1},
		date.TimeRFC1123{t2},
		date.TimeRFC1123{t3},
	})
	c.Assert(err, chk.IsNil)
}

//'2000-12-01', '1980-01-02', '1492-10-12'
func (s *ArrayGroupSuite) TestPutDateValid(c *chk.C) {
	dateArray := []date.Date{date.Date{Time: time.Date(2000, time.December, 01, 0, 0, 0, 0, time.UTC)},
		date.Date{Time: time.Date(1980, time.January, 02, 0, 0, 0, 0, time.UTC)},
		date.Date{Time: time.Date(1492, time.October, 12, 0, 0, 0, 0, time.UTC)},
	}
	_, err := arrayClient.PutDateValid(dateArray)
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutDoubleValid(c *chk.C) {
	_, err := arrayClient.PutDoubleValid([]float64{0, -0.01, -1.2e20})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutDurationValid(c *chk.C) {
	_, err := arrayClient.PutDurationValid([]string{"P123DT22H14M12.011S", "P5DT1H"})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutFloatValid(c *chk.C) {
	_, err := arrayClient.PutFloatValid([]float64{0, -0.01, -1.2e20})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutIntegerValid(c *chk.C) {
	_, err := arrayClient.PutIntegerValid([]int32{1, -1, 3, 300})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutStringValid(c *chk.C) {
	_, err := arrayClient.PutStringValid([]string{"foo1", "foo2", "foo3"})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestPutLongValid(c *chk.C) {
	_, err := arrayClient.PutLongValid([]int64{1, -1, 3, 300})
	c.Assert(err, chk.IsNil)
}

func (s *ArrayGroupSuite) TestGetUUIDInvalidChars(c *chk.C) {
	_, err := arrayClient.GetUUIDInvalidChars()
	c.Assert(err, chk.NotNil)
}

func (s *ArrayGroupSuite) TestGetUUIDValid(c *chk.C) {
	res, err := arrayClient.GetUUIDValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.DeepEquals, getUUID())
}

func (s *ArrayGroupSuite) TestPutUUIDValid(c *chk.C) {
	_, err := arrayClient.PutUUIDValid(getUUID())
	c.Assert(err, chk.IsNil)
}

func getProductArray(str string) []Product {
	var i, j, k int32 = 1, 3, 5
	x, y, z := "2", "4", "6"
	var complexArray []Product
	switch str {
	case "valid":
		complexArray = []Product{
			{&i, &x},
			{&j, &y},
			{&k, &z},
		}
	case "itemEmpty":
		complexArray = []Product{
			{&i, &x},
			{},
			{&k, &z},
		}
	case "itemNull":
		complexArray = []Product{
			{&i, &x},
			{nil, nil},
			{&k, &z},
		}
	case "empty":
		complexArray = []Product{}
	}

	return complexArray
}

// GetUUIDValid get uuid array value ['6dcc7237-45fe-45c4-8a6b-3a8a3f625652',
// 'd1399005-30f7-40d6-8da6-dd7c89ad34db',
// 'f42f6aa1-a5bc-4ddf-907e-5f915de43205']
func getUUID() []uuid.UUID {
	u1, _ := uuid.FromString("6dcc7237-45fe-45c4-8a6b-3a8a3f625652")
	u2, _ := uuid.FromString("d1399005-30f7-40d6-8da6-dd7c89ad34db")
	u3, _ := uuid.FromString("f42f6aa1-a5bc-4ddf-907e-5f915de43205")
	return []uuid.UUID{
		u1,
		u2,
		u3,
	}
}
