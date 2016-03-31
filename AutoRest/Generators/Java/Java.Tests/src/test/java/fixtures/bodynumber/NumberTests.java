package fixtures.bodynumber;

import com.fasterxml.jackson.core.JsonParseException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class NumberTests {
    private static AutoRestNumberTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestNumberTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.number().getNull().getBody());
    }

    @Test
    public void getInvalidFloat() throws Exception {
        try {
            client.number().getInvalidFloat();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }

    @Test
    public void getInvalidDouble() throws Exception {
        try {
            client.number().getInvalidDouble();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }

    @Test
    public void putBigFloat() throws Exception {
        client.number().putBigFloat(3.402823e+20);
    }

    @Test
    public void putBigDouble() throws Exception {
        client.number().putBigDouble(2.5976931e+101);
    }

    @Test
    public void getBigFloat() throws Exception {
        double result = client.number().getBigFloat().getBody();
        Assert.assertEquals(3.402823e+20, result, 0.0f);
    }

    @Test
    public void getBigDouble() throws Exception {
        double result = client.number().getBigDouble().getBody();
        Assert.assertEquals(2.5976931e+101, result, 0.0f);
    }

    @Test
    public void putBigDoublePositiveDecimal() throws Exception {
        client.number().putBigDoublePositiveDecimal(99999999.99);
    }

    @Test
    public void getBigDoublePositiveDecimal() throws Exception {
        double result = client.number().getBigDoublePositiveDecimal().getBody();
        Assert.assertEquals(99999999.99, result, 0.0f);
    }

    @Test
    public void putBigDoubleNegativeDecimal() throws Exception {
        client.number().putBigDoubleNegativeDecimal(-99999999.99);
    }

    @Test
    public void getBigDoubleNegativeDecimal() throws Exception {
        double result = client.number().getBigDoubleNegativeDecimal().getBody();
        Assert.assertEquals(-99999999.99, result, 0.0f);
    }

    @Test
    public void putSmallFloat() throws Exception {
        client.number().putSmallFloat(3.402823e-20);
    }

    @Test
    public void getSmallFloat() throws Exception {
        double result = client.number().getSmallFloat().getBody();
        Assert.assertEquals(3.402823e-20, result, 0.0f);
    }

    @Test
    public void putSmallDouble() throws Exception {
        client.number().putSmallDouble(2.5976931e-101);
    }

    @Test
    public void getSmallDouble() throws Exception {
        double result = client.number().getSmallDouble().getBody();
        Assert.assertEquals(2.5976931e-101, result, 0.0f);
    }
}
