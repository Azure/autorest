package fixtures.bodydatetimerfc1123;

import com.fasterxml.jackson.databind.JsonMappingException;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class DateTimeRfc1123OperationsTests {
    private static AutoRestRFC1123DateTimeTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRFC1123DateTimeTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDatetimerfc1123Operations().getNull().getBody());
    }

    @Test
    public void getInvalidDate() throws Exception {
        try {
            client.getDatetimerfc1123Operations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonMappingException.class, exception.getClass());
        }
    }

    @Test
    public void getOverflowDate() throws Exception {
        DateTime result = client.getDatetimerfc1123Operations().getOverflow().getBody();
        DateTime expected = new DateTime(10000, 1, 1, 00, 00, 00, 0, DateTimeZone.UTC);
        expected = expected.toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUnderflowDate() throws Exception {
        try {
            client.getDatetimerfc1123Operations().getUnderflow();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonMappingException.class, exception.getClass());
        }
    }

    @Test
    public void putUtcMaxDateTime() throws Exception {
        DateTime body = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        client.getDatetimerfc1123Operations().putUtcMaxDateTime(body);
    }

    @Test
    public void getUtcLowercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimerfc1123Operations().getUtcLowercaseMaxDateTime().getBody();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUtcUppercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimerfc1123Operations().getUtcUppercaseMaxDateTime().getBody();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putUtcMinDateTime() throws Exception {
        DateTime body = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        client.getDatetimerfc1123Operations().putUtcMinDateTime(body);
    }

    @Test
    public void getUtcMinDateTime() throws Exception {
        DateTime result = client.getDatetimerfc1123Operations().getUtcMinDateTime().getBody();
        DateTime expected = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }
}
