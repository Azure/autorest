package fixtures.bodydatetime;

import com.microsoft.rest.ServiceException;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class DatetimeOperationsTests {
    static AutoRestDateTimeTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestDateTimeTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDatetimeOperations().getNull());
    }

    @Test
    public void getInvalidDate() throws Exception {
        try {
            client.getDatetimeOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("Invalid format"));
        }
    }

    @Test
    public void getOverflowDate() throws Exception {
        DateTime result = client.getDatetimeOperations().getOverflow();
        // 9999-12-31T23:59:59.999-14:000
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(-14));
        expected = expected.toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUnderflowDate() throws Exception {
        try {
            client.getDatetimeOperations().getUnderflow();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("IllegalFieldValueException"));
        }
    }

    @Test
    public void putUtcMaxDateTime() throws Exception {
        DateTime body = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.UTC);
        client.getDatetimeOperations().putUtcMaxDateTime(body);
    }

    @Test
    public void getUtcLowercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getUtcLowercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getUtcUppercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getUtcUppercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLocalPositiveOffsetMaxDateTime() throws Exception {
        DateTime body = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(14));
        client.getDatetimeOperations().putLocalPositiveOffsetMaxDateTime(body);
    }

    @Test
    public void getLocalPositiveOffsetLowercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalPositiveOffsetLowercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getLocalPositiveOffsetUppercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalPositiveOffsetUppercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLocalNegativeOffsetMaxDateTime() throws Exception {
        DateTime body = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(-14));
        client.getDatetimeOperations().putLocalNegativeOffsetMaxDateTime(body);
    }

    @Test
    public void getLocalNegativeOffsetLowercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalNegativeOffsetLowercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(-14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void getLocalNegativeOffsetUppercaseMaxDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalNegativeOffsetUppercaseMaxDateTime();
        DateTime expected = new DateTime(9999, 12, 31, 23, 59, 59, 999, DateTimeZone.forOffsetHours(-14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putUtcMinDateTime() throws Exception {
        DateTime body = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        client.getDatetimeOperations().putUtcMinDateTime(body);
    }

    @Test
    public void getUtcMinDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getUtcMinDateTime();
        DateTime expected = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLocalPositiveOffsetMinDateTime() throws Exception {
        DateTime body =new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.forOffsetHours(14));
        client.getDatetimeOperations().putLocalPositiveOffsetMinDateTime(body);
    }

    @Test
    public void getLocalPositiveOffsetMinDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalPositiveOffsetMinDateTime();
        DateTime expected = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.forOffsetHours(14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLocalNegativeOffsetMinDateTime() throws Exception {
        DateTime body =new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.forOffsetHours(-14));
        client.getDatetimeOperations().putLocalNegativeOffsetMinDateTime(body);
    }

    @Test
    public void getLocalNegativeOffsetMinDateTime() throws Exception {
        DateTime result = client.getDatetimeOperations().getLocalNegativeOffsetMinDateTime();
        DateTime expected = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeZone.forOffsetHours(-14)).toDateTime(DateTimeZone.UTC);
        Assert.assertEquals(expected, result);
    }
}
