package fixtures.bodydatetimerfc1123;

import com.fasterxml.jackson.databind.JsonMappingException;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodydatetimerfc1123.implementation.AutoRestRFC1123DateTimeTestServiceImpl;

public class DateTimeRfc1123OperationsTests {
    private static AutoRestRFC1123DateTimeTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRFC1123DateTimeTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.datetimerfc1123s().getNull());
    }

    @Test
    public void getInvalidDate() throws Exception {
        try {
            client.datetimerfc1123s().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonMappingException.class, exception.getCause().getClass());
        }
    }

    @Test
    public void getOverflowDate() throws Exception {
        DateTime result = client.datetimerfc1123s().getOverflow();
        DateTime expected = new DateTime(10000, 1, 1, 00, 00, 00, 0, DateTimeZone.UTC);
        expected = expected.toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUnderflowDate() throws Exception {
        try {
            client.datetimerfc1123s().getUnderflow();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonMappingException.class, exception.getCause().getClass());
        }
    }

    @Test
    public void putUtcMaxDateTime() throws Exception {
        DateTime body = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        client.datetimerfc1123s().putUtcMaxDateTime(body);
    }

    @Test
    public void getUtcLowercaseMaxDateTime() throws Exception {
        DateTime result = client.datetimerfc1123s().getUtcLowercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUtcUppercaseMaxDateTime() throws Exception {
        DateTime result = client.datetimerfc1123s().getUtcUppercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putUtcMinDateTime() throws Exception {
        DateTime body = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        client.datetimerfc1123s().putUtcMinDateTime(body);
    }

    @Test
    public void getUtcMinDateTime() throws Exception {
        DateTime result = client.datetimerfc1123s().getUtcMinDateTime();
        DateTime expected = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }
}
