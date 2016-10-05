package complexgrouptest

import (
	"encoding/json"
	"fmt"
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest/date"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-complex"
)

func Test(t *testing.T) { chk.TestingT(t) }

type ComplexGroupSuite struct{}

var _ = chk.Suite(&ComplexGroupSuite{})

var complexPrimitiveClient = getPrimitiveClient()
var complexArrayClient = getArrayComplexClient()
var complexDictionaryClient = getDictionaryComplexClient()
var complexBasicOperationsClient = getBasicOperationsClient()
var complexInheritanceClient = getInheritanceClient()
var complexPolymorphicClient = getPolymorphismClient()
var complexReadOnlyClient = getReadOnlyClient()

func getArrayComplexClient() ArrayClient {
	c := NewArrayClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getBasicOperationsClient() BasicOperationsClient {
	c := NewBasicOperationsClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getDictionaryComplexClient() DictionaryClient {
	c := NewDictionaryClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getPrimitiveClient() PrimitiveClient {
	c := NewPrimitiveClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getInheritanceClient() InheritanceClient {
	c := NewInheritanceClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getPolymorphismClient() PolymorphismClient {
	c := NewPolymorphismClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func getReadOnlyClient() ReadonlypropertyClient {
	c := NewReadonlypropertyClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

// Read only property tests
func (s *ComplexGroupSuite) TestReadOnlyComplex(c *chk.C) {
	res, err := complexReadOnlyClient.GetValid()
	c.Assert(err, chk.IsNil)
	_, err = complexReadOnlyClient.PutValid(res)
	c.Assert(err, chk.NotNil)
	expected := fmt.Errorf("autorest/validation: validation failed: parameter=%s constraint=%s value=%#v details: %s",
		"complexBody.ID", "ReadOnly", "1234", "readonly parameter; must send as nil or empty in request")
	c.Assert(err, chk.ErrorMatches,
		fmt.Sprintf("complexgroup.ReadonlypropertyClient#PutValid: Invalid input: %v", expected))
}

// Primitive tests
func (s *ComplexGroupSuite) TestGetBoolComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetBool()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.FieldTrue, chk.Equals, true)
	c.Assert(*res.FieldFalse, chk.Equals, false)
}

func (s *ComplexGroupSuite) TestGetByteComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetByte()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Field, chk.DeepEquals, []byte{0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6})
}

func (s *ComplexGroupSuite) TestGetDateComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetDate()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field, chk.DeepEquals, date.Date{time.Date(0001, time.January, 1, 0, 0, 0, 0, time.UTC)})
	c.Assert(*res.Leap, chk.DeepEquals, date.Date{time.Date(2016, time.February, 29, 0, 0, 0, 0, time.UTC)})
}

func (s *ComplexGroupSuite) TestGetDateTimeComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetDateTime()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field, chk.DeepEquals, utils.ToDateTime("0001-01-01T00:00:00Z"))
	c.Assert(*res.Now, chk.DeepEquals, utils.ToDateTime("2015-05-18T18:38:00Z"))
}

func (s *ComplexGroupSuite) TestGetDateTimeRfc1123Complex(c *chk.C) {
	res, err := complexPrimitiveClient.GetDateTimeRfc1123()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field, chk.DeepEquals, utils.ToDateTimeRFC1123("Mon, 01 Jan 0001 00:00:00 GMT"))
	c.Assert(*res.Now, chk.DeepEquals, utils.ToDateTimeRFC1123("Mon, 18 May 2015 11:38:00 GMT"))
}

func (s *ComplexGroupSuite) TestGetDoubleComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetDouble()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field1, chk.Equals, 3e-100)
	c.Assert(*res.Field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose, chk.Equals, -0.000000000000000000000000000000000000000000000000000000005)
}

func (s *ComplexGroupSuite) TestGetDurationComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetDuration()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Field, chk.Equals, "P123DT22H14M12.011S")
}

func (s *ComplexGroupSuite) TestGetFloatComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetFloat()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field1, chk.Equals, 1.05)
	c.Assert(*res.Field2, chk.Equals, -0.003)
}

func (s *ComplexGroupSuite) TestGetIntComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetInt()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Field1, chk.Equals, int32(-1))
	c.Assert(*res.Field2, chk.Equals, int32(2))
}

func (s *ComplexGroupSuite) TestGetLongComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetLong()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Field1, chk.Equals, int64(1099511627775))
	c.Assert(*res.Field2, chk.Equals, int64(-999511627788))
}

func (s *ComplexGroupSuite) TestGetStringComplex(c *chk.C) {
	res, err := complexPrimitiveClient.GetString()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.Field, chk.Equals, "goodrequest")
	c.Assert(*res.Empty, chk.Equals, "")
	c.Assert(res.Null, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutBoolComplex(c *chk.C) {
	a, b := true, false
	_, err := complexPrimitiveClient.PutBool(BooleanWrapper{FieldTrue: &a, FieldFalse: &b})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutByteComplex(c *chk.C) {
	_, err := complexPrimitiveClient.PutByte(
		ByteWrapper{Field: &[]byte{0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6}})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutDateComplex(c *chk.C) {
	_, err := complexPrimitiveClient.PutDate(
		DateWrapper{Field: &date.Date{time.Date(0001, time.January, 1, 0, 0, 0, 0, time.UTC)},
			Leap: &date.Date{time.Date(2016, time.February, 29, 0, 0, 0, 0, time.UTC)}})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutDateTimeComplex(c *chk.C) {
	dt1, dt2 := utils.ToDateTime("0001-01-01T00:00:00Z"), utils.ToDateTime("2015-05-18T18:38:00Z")
	_, err := complexPrimitiveClient.PutDateTime(DatetimeWrapper{Field: &dt1, Now: &dt2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutDateTimeRFC1123Complex(c *chk.C) {
	dt1, dt2 := utils.ToDateTimeRFC1123("Mon, 01 Jan 0001 00:00:00 GMT"), utils.ToDateTimeRFC1123("Mon, 18 May 2015 11:38:00 GMT")
	_, err := complexPrimitiveClient.PutDateTimeRfc1123(Datetimerfc1123Wrapper{Field: &dt1, Now: &dt2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutDoubleComplex(c *chk.C) {
	d1, d2 := 3e-100, -0.000000000000000000000000000000000000000000000000000000005
	_, err := complexPrimitiveClient.PutDouble(DoubleWrapper{Field1: &d1,
		Field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose: &d2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutDurationComplex(c *chk.C) {
	duration := "P123DT22H14M12.011S"
	_, err := complexPrimitiveClient.PutDuration(DurationWrapper{Field: &duration})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutFloatComplex(c *chk.C) {
	f1, f2 := 1.05, -0.003
	_, err := complexPrimitiveClient.PutFloat(FloatWrapper{Field1: &f1, Field2: &f2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutIntComplex(c *chk.C) {
	var i1, i2 int32 = -1, 2
	_, err := complexPrimitiveClient.PutInt(IntWrapper{Field1: &i1, Field2: &i2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutLongComplex(c *chk.C) {
	var l1, l2 int64 = 1099511627775, -999511627788
	_, err := complexPrimitiveClient.PutLong(LongWrapper{Field1: &l1, Field2: &l2})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutStringComplex(c *chk.C) {
	s1, s2 := "goodrequest", ""
	_, err := complexPrimitiveClient.PutString(StringWrapper{Field: &s1, Empty: &s2, Null: nil})
	c.Assert(err, chk.IsNil)
}

//Array Complex tests
func (s *ComplexGroupSuite) TestGetEmptyArrayComplex(c *chk.C) {
	res, err := complexArrayClient.GetEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Array, chk.DeepEquals, []string{})
}

func (s *ComplexGroupSuite) TestGetNotProvidedArrayComplex(c *chk.C) {
	res, err := complexArrayClient.GetNotProvided()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Array, chk.IsNil)
}

func (s *ComplexGroupSuite) TestGetValidArrayComplex(c *chk.C) {
	// string can't be null
	array := []string{"1, 2, 3, 4", "", "", "&S#$(*Y", "The quick brown fox jumps over the lazy dog"}
	res, err := complexArrayClient.GetValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Array, chk.DeepEquals, array)
}

func (s *ComplexGroupSuite) TestPutEmptyArrayComplex(c *chk.C) {
	_, err := complexArrayClient.PutEmpty(ArrayWrapper{Array: &[]string{}})
	c.Assert(err, chk.IsNil)
}

// func (s *ComplexGroupSuite) TestPutComplexArrayValid(c *chk.C) {
// 	// string can't be null
// 	array := []string{"1, 2, 3, 4", "", "", "&S#$(*Y", "The quick brown fox jumps over the lazy dog"}
// 	_, err := complexArrayClient.PutValid(ArrayWrapper{Array: &array})
// 	c.Assert(err, chk.IsNil)
// }

// Dictionary complex tests
func (s *ComplexGroupSuite) TestGetEmptyDictionaryComplex(c *chk.C) {
	res, err := complexDictionaryClient.GetEmpty()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.DefaultProgram, chk.DeepEquals, map[string]*string{})
}

func (s *ComplexGroupSuite) TestGetNotProvidedDictionaryComplex(c *chk.C) {
	res, err := complexDictionaryClient.GetNotProvided()
	c.Assert(err, chk.IsNil)
	c.Assert(res.DefaultProgram, chk.IsNil)
}

func (s *ComplexGroupSuite) TestGetNullDictionaryComplex(c *chk.C) {
	res, err := complexDictionaryClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.DefaultProgram, chk.IsNil)
}

func (s *ComplexGroupSuite) TestGetValidDictionaryComplex(c *chk.C) {
	s1, s2, s3, s4 := "notepad", "mspaint", "excel", ""
	dic := map[string]*string{"txt": &s1, "bmp": &s2, "xls": &s3, "exe": &s4, "": nil}
	res, err := complexDictionaryClient.GetValid()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.DefaultProgram, chk.DeepEquals, dic)
}

func (s *ComplexGroupSuite) TestPutEmptyDictionaryComplex(c *chk.C) {
	_, err := complexDictionaryClient.PutEmpty(DictionaryWrapper{DefaultProgram: &map[string]*string{}})
	c.Assert(err, chk.IsNil)
}

func (s *ComplexGroupSuite) TestPutValidDictionaryComplex(c *chk.C) {
	jsonBlob := `{"defaultProgram":{"txt":"notepad","bmp":"mspaint","xls":"excel","exe":"","":null}}`
	var dw DictionaryWrapper
	err := json.Unmarshal([]byte(jsonBlob), &dw)
	c.Assert(err, chk.IsNil)
	_, err = complexDictionaryClient.PutValid(dw)
	c.Assert(err, chk.IsNil)
}

// Basic operations tests
func (s *ComplexGroupSuite) TestGetEmptyBasicOperationsComplex(c *chk.C) {
	res, err := complexBasicOperationsClient.GetEmpty()
	c.Assert(err, chk.IsNil)

	c.Assert(res.ID, chk.IsNil)
	c.Assert(res.Name, chk.IsNil)

	c.Assert(string(res.Color), chk.Equals, "")
}

func (s *ComplexGroupSuite) TestGetInvalidBasicOperationsComplex(c *chk.C) {
	_, err := complexBasicOperationsClient.GetInvalid()
	c.Assert(err, chk.NotNil)
}

func (s *ComplexGroupSuite) TestGetNotProvidedBasicOperationsComplex(c *chk.C) {
	res, err := complexBasicOperationsClient.GetNotProvided()
	c.Assert(err, chk.IsNil)

	c.Assert(res.ID, chk.IsNil)
	c.Assert(res.Name, chk.IsNil)

	c.Assert(string(res.Color), chk.Equals, "")
}

func (s *ComplexGroupSuite) TestGetValidBasicOperationsComplex(c *chk.C) {
	res, err := complexBasicOperationsClient.GetValid()
	c.Assert(err, chk.IsNil)

	c.Assert(*res.ID, chk.Equals, int32(2))
	c.Assert(*res.Name, chk.Equals, "abc")

	c.Assert(string(res.Color), chk.Equals, "YELLOW")
}

func (s *ComplexGroupSuite) TestGetNullBasicOperationsComplex(c *chk.C) {
	res, err := complexBasicOperationsClient.GetNull()
	c.Assert(err, chk.IsNil)

	c.Assert(res.ID, chk.IsNil)
	c.Assert(res.Name, chk.IsNil)

	c.Assert(string(res.Color), chk.Equals, "")
}

func (s *ComplexGroupSuite) TestPutValidBasicOperationsComplex(c *chk.C) {
	m, n := int32(2), "abc"
	expected := Basic{ID: &m, Name: &n, Color: "Magenta"}
	_, err := complexBasicOperationsClient.PutValid(expected)
	c.Assert(err, chk.IsNil)
}

// Inheritance tests
func (s *ComplexGroupSuite) TestGetValidInheritanceComplex(c *chk.C) {
	res, err := complexInheritanceClient.GetValid()
	c.Assert(err, chk.IsNil)
	dogs := []Dog{getDogObject("tomato", 1, "Potato"), getDogObject("french fries", -1, "Tomato")}

	c.Assert(*res.ID, chk.Equals, int32(2))
	c.Assert(*res.Name, chk.Equals, "Siameeee")
	c.Assert(*res.Color, chk.Equals, "green")
	c.Assert(*res.Breed, chk.Equals, "persian")
	c.Assert(*res.Hates, chk.DeepEquals, dogs)
}

func (s *ComplexGroupSuite) TestPutValidInheritanceComplex(c *chk.C) {
	a, b, x, y := int32(2), "Siameeee", "persian", "green"
	cat := Siamese{
		ID:    &a,
		Name:  &b,
		Breed: &x,
		Color: &y,
		Hates: &[]Dog{
			getDogObject("tomato", 1, "Potato"),
			getDogObject("french fries", -1, "Tomato"),
		},
	}
	_, err := complexInheritanceClient.PutValid(cat)
	c.Assert(err, chk.IsNil)
}

func getDogObject(food string, id int32, name string) Dog {
	return Dog{Food: &food, ID: &id, Name: &name}
}

// Polymorphic tests
var validPolymorphic = `{
  "fishtype": "salmon",
  "location": "alaska",
  "iswild": true,
  "species": "king",
  "length": 1,
  "siblings": [
    {
      "fishtype": "shark",
      "age": 6,
      "birthday": "2012-01-05T01:00:00Z",
      "length": 20,
      "species": "predator"
    },
    {
      "fishtype": "sawshark",
      "age": 105,
      "birthday": "1900-01-05T01:00:00Z",
      "length": 10,
      "picture": "//////4=",
      "species": "dangerous"
    },
    {
      "fishtype": "goblin",
      "age": 1,
      "birthday": "2015-08-08T00:00:00Z",
      "length": 30,
      "species": "scary",
      "jawsize": 5
    }
  ]
}`

func (s *ComplexGroupSuite) TestGetComplexPolymorphicValid(c *chk.C) {
	res, err := complexPolymorphicClient.GetValid()
	c.Assert(err, chk.IsNil)
	var f Fish
	err = json.Unmarshal([]byte(validPolymorphic), &f)
	c.Assert(err, chk.IsNil)
	f.Response = res.Response
	c.Assert(res, chk.DeepEquals, f)
}

// func (s *ComplexGroupSuite) TestPutComplexPolymorphismValid(c *chk.C) {
// 	var f Fish
// 	err := json.Unmarshal([]byte(validPolymorphic), &f)
// 	c.Assert(err, chk.IsNil)
// 	_, err = complexPolymorphicClient.PutValid(f)
// 	c.Assert(err, chk.IsNil)
// }
