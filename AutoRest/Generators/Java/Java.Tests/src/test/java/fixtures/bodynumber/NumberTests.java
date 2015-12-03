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
        Assert.assertNull(client.getNumber().getNull().getBody());
    }

    @Test
    public void getInvalidFloat() throws Exception {
        try {
            client.getNumber().getInvalidFloat();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }

    @Test
    public void getInvalidDouble() throws Exception {
        try {
            client.getNumber().getInvalidDouble();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }

    @Test
    public void putBigFloat() throws Exception {
        client.getNumber().putBigFloat(3.402823e+20);
    }

    @Test
    public void putBigDouble() throws Exception {
        client.getNumber().putBigDouble(2.5976931e+101);
    }

    @Test
    public void getBigFloat() throws Exception {
        double result = client.getNumber().getBigFloat().getBody();
        Assert.assertEquals(3.402823e+20, result, 0.0f);
    }

    @Test
    public void getBigDouble() throws Exception {
        double result = client.getNumber().getBigDouble().getBody();
        Assert.assertEquals(2.5976931e+101, result, 0.0f);
    }

    @Test
    public void putBigDoublePositiveDecimal() throws Exception {
        client.getNumber().putBigDoublePositiveDecimal(99999999.99);
    }

    @Test
    public void getBigDoublePositiveDecimal() throws Exception {
        double result = client.getNumber().getBigDoublePositiveDecimal().getBody();
        Assert.assertEquals(99999999.99, result, 0.0f);
    }

    @Test
    public void putBigDoubleNegativeDecimal() throws Exception {
        client.getNumber().putBigDoubleNegativeDecimal(-99999999.99);
    }

    @Test
    public void getBigDoubleNegativeDecimal() throws Exception {
        double result = client.getNumber().getBigDoubleNegativeDecimal().getBody();
        Assert.assertEquals(-99999999.99, result, 0.0f);
    }

    @Test
    public void putSmallFloat() throws Exception {
        client.getNumber().putSmallFloat(3.402823e-20);
    }

    @Test
    public void getSmallFloat() throws Exception {
        double result = client.getNumber().getSmallFloat().getBody();
        Assert.assertEquals(3.402823e-20, result, 0.0f);
    }

    @Test
    public void putSmallDouble() throws Exception {
        client.getNumber().putSmallDouble(2.5976931e-101);
    }

    @Test
    public void getSmallDouble() throws Exception {
        double result = client.getNumber().getSmallDouble().getBody();
        Assert.assertEquals(2.5976931e-101, result, 0.0f);
    }
}
