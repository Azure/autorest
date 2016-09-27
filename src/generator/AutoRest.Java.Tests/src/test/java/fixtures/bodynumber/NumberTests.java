package fixtures.bodynumber;

import com.fasterxml.jackson.core.JsonParseException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodynumber.implementation.AutoRestNumberTestServiceImpl;

import static org.junit.Assert.fail;

public class NumberTests {
    private static AutoRestNumberTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestNumberTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        try {
            client.numbers().getNull();
            fail();
        } catch (NullPointerException e) {
            // expected
        }
    }

    @Test
    public void getInvalidFloat() throws Exception {
        try {
            client.numbers().getInvalidFloat();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getCause().getClass());
        }
    }

    @Test
    public void getInvalidDouble() throws Exception {
        try {
            client.numbers().getInvalidDouble();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getCause().getClass());
        }
    }

    @Test
    public void putBigFloat() throws Exception {
        client.numbers().putBigFloat(3.402823e+20);
    }

    @Test
    public void putBigDouble() throws Exception {
        client.numbers().putBigDouble(2.5976931e+101);
    }

    @Test
    public void getBigFloat() throws Exception {
        double result = client.numbers().getBigFloat();
        Assert.assertEquals(3.402823e+20, result, 0.0f);
    }

    @Test
    public void getBigDouble() throws Exception {
        double result = client.numbers().getBigDouble();
        Assert.assertEquals(2.5976931e+101, result, 0.0f);
    }

    @Test
    public void putBigDoublePositiveDecimal() throws Exception {
        client.numbers().putBigDoublePositiveDecimal(99999999.99);
    }

    @Test
    public void getBigDoublePositiveDecimal() throws Exception {
        double result = client.numbers().getBigDoublePositiveDecimal();
        Assert.assertEquals(99999999.99, result, 0.0f);
    }

    @Test
    public void putBigDoubleNegativeDecimal() throws Exception {
        client.numbers().putBigDoubleNegativeDecimal(-99999999.99);
    }

    @Test
    public void getBigDoubleNegativeDecimal() throws Exception {
        double result = client.numbers().getBigDoubleNegativeDecimal();
        Assert.assertEquals(-99999999.99, result, 0.0f);
    }

    @Test
    public void putSmallFloat() throws Exception {
        client.numbers().putSmallFloat(3.402823e-20);
    }

    @Test
    public void getSmallFloat() throws Exception {
        double result = client.numbers().getSmallFloat();
        Assert.assertEquals(3.402823e-20, result, 0.0f);
    }

    @Test
    public void putSmallDouble() throws Exception {
        client.numbers().putSmallDouble(2.5976931e-101);
    }

    @Test
    public void getSmallDouble() throws Exception {
        double result = client.numbers().getSmallDouble();
        Assert.assertEquals(2.5976931e-101, result, 0.0f);
    }
}
