package fixtures.bodydate;

import org.joda.time.IllegalFieldValueException;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;

import fixtures.bodydate.implementation.AutoRestDateTestServiceImpl;

public class DateOperationsTests {
    private static AutoRestDateTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestDateTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.dates().getNull());
    }

    @Test
    public void getInvalidDate() throws Exception {
        try {
            client.dates().getInvalidDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(IllegalArgumentException.class, exception.getClass());
        }
    }

    @Test
    public void getOverflowDate() throws Exception {
        try {
            client.dates().getOverflowDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(IllegalArgumentException.class, exception.getClass());
        }
    }

    @Test
    public void getUnderflowDate() throws Exception {
        try {
            client.dates().getUnderflowDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(IllegalFieldValueException.class, exception.getClass());
        }
    }

    @Test
    public void putMaxDate() throws Exception {
        LocalDate body = new LocalDate(9999, 12, 31);
        client.dates().putMaxDate(body);
    }

    @Test
    public void getMaxDate() throws Exception {
        LocalDate expected = new LocalDate(9999, 12, 31);
        LocalDate result = client.dates().getMaxDate();
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putMinDate() throws Exception {
        LocalDate body = new LocalDate(1, 1, 1);
        client.dates().putMinDate(body);
    }

    @Test
    public void getMinDate() throws Exception {
        LocalDate expected = new LocalDate(1, 1, 1);
        LocalDate result = client.dates().getMinDate();
        Assert.assertEquals(expected, result);
    }
}
