package numbergrouptest

import (
	"testing"

	_ "github.com/shopspring/decimal"
	chk "gopkg.in/check.v1"

	"tests/acceptancetests/utils"
	. "tests/generated/body-number"
)

// TODO: decimal tests

func Test(t *testing.T) { chk.TestingT(t) }

type NumberSuite struct{}

var _ = chk.Suite(&NumberSuite{})

var numberClient = getNumberClient()

func getNumberClient() NumberClient {
	c := NewNumberClient()
	c.BaseURI = utils.GetBaseURI()
	return c
}

func (s *NumberSuite) TestGetBigDouble(c *chk.C) {
	res, err := numberClient.GetBigDouble()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, 2.5976931e+101)
}

func (s *NumberSuite) TestGetBigDoubleNegativeDecimal(c *chk.C) {
	res, err := numberClient.GetBigDoubleNegativeDecimal()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, -99999999.99)
}

func (s *NumberSuite) TestGetBigDoublePositiveDecimal(c *chk.C) {
	res, err := numberClient.GetBigDoublePositiveDecimal()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, 99999999.99)
}

func (s *NumberSuite) TestGetBigFloat(c *chk.C) {
	res, err := numberClient.GetBigFloat()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, 3.402823e+20)
}

func (s *NumberSuite) TestGetInvalidDouble(c *chk.C) {
	_, err := numberClient.GetInvalidDouble()
	c.Assert(err, chk.NotNil)
}

func (s *NumberSuite) TestGetInvalidFloat(c *chk.C) {
	_, err := numberClient.GetInvalidFloat()
	c.Assert(err, chk.NotNil)
}

func (s *NumberSuite) TestGetNullNumber(c *chk.C) {
	res, err := numberClient.GetNull()
	c.Assert(err, chk.IsNil)
	c.Assert(res.Value, chk.IsNil)
}

func (s *NumberSuite) TestGetSmallDouble(c *chk.C) {
	res, err := numberClient.GetSmallDouble()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, 2.5976931e-101)
}

func (s *NumberSuite) TestGetSmallFloat(c *chk.C) {
	res, err := numberClient.GetSmallFloat()
	c.Assert(err, chk.IsNil)
	c.Assert(*res.Value, chk.Equals, 3.402823e-20)
}

func (s *NumberSuite) TestPutBigDouble(c *chk.C) {
	_, err := numberClient.PutBigDouble(2.5976931e+101)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestPutBigDoubleNegativeDecimal(c *chk.C) {
	_, err := numberClient.PutBigDoubleNegativeDecimal(-99999999.99)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestPutBigDoublePositiveDecimal(c *chk.C) {
	_, err := numberClient.PutBigDoublePositiveDecimal(99999999.99)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestPutBigFloat(c *chk.C) {
	_, err := numberClient.PutBigFloat(3.402823e+20)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestPutSmallDouble(c *chk.C) {
	_, err := numberClient.PutSmallDouble(2.5976931e-101)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestPutSmallFloat(c *chk.C) {
	_, err := numberClient.PutSmallFloat(3.402823e-20)
	c.Assert(err, chk.IsNil)
}

func (s *NumberSuite) TestGetInvalidDecimal(c *chk.C) {
	_, err := numberClient.GetInvalidDecimal()
	c.Assert(err, chk.NotNil)
}

// func (s *NumberSuite) TestGetBigDecimal(c *chk.C) {
// 	res, err := numberClient.GetBigDecimal()
// 	c.Assert(err, chk.IsNil)
// 	fmt.Println(*res.Value)
// 	fmt.Println(decimal.NewFromFloatWithExponent(2.5976931, 101))
// 	//c.Assert(*(res.Value).String(), chk.DeepEquals, decimal.NewFromFloatWithExponent(2.5976931, 101).String())
// }

// func (s *NumberSuite) TestGetSmallDecimal(c *chk.C) {
// 	res, err := numberClient.GetSmallDecimal()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(*res.Value, chk.DeepEquals, decimal.NewFromFloatWithExponent(2.5976931, -101))
// }

// func (s *NumberSuite) TestGetBigDecimalPositiveDecimal(c *chk.C) {
// 	res, err := numberClient.GetBigDecimalPositiveDecimal()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(*res.Value, chk.DeepEquals, decimal.NewFromFloat(99999999.99))
// }

// func (s *NumberSuite) TestGetBigDecimalNegativeDecimal(c *chk.C) {
// 	res, err := numberClient.GetBigDecimalNegativeDecimal()
// 	c.Assert(err, chk.IsNil)
// 	c.Assert(*res.Value, chk.DeepEquals, decimal.NewFromFloat(-99999999.99))
// }

// func (s *NumberSuite) TestPutBigDecimal(c *chk.C) {
// 	_, err := numberClient.PutBigDecimal(decimal.NewFromFloatWithExponent(2.5976931, 101))
// 	c.Assert(err, chk.IsNil)
// }

// func (s *NumberSuite) TestPutSmallDecimal(c *chk.C) {
// 	_, err := numberClient.PutSmallDecimal(decimal.NewFromFloatWithExponent(2.5976931, -101))
// 	c.Assert(err, chk.IsNil)
// }

// func (s *NumberSuite) TestPutBigDecimalPositiveDecimal(c *chk.C) {
// 	_, err := numberClient.PutBigDecimalPositiveDecimal(decimal.NewFromFloat(99999999.99))
// 	c.Assert(err, chk.IsNil)
// }

// func (s *NumberSuite) TestPutBigDecimalNegativeDecimal(c *chk.C) {
// 	_, err := numberClient.PutBigDecimalNegativeDecimal(decimal.NewFromFloat(-99999999.99))
// 	c.Assert(err, chk.IsNil)
// }
