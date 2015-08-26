package fixtures.bodydate;

import com.microsoft.rest.ServiceException;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;

public class DateOperationsTests {
    static AutoRestDateTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestDateTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDateOperations().getNull());
    }

    @Test
    public void getInvalidDate() throws Exception {
        try {
            client.getDateOperations().getInvalidDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("Invalid format"));
        }
    }

    @Test
    public void getOverflowDate() throws Exception {
        try {
            client.getDateOperations().getOverflowDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("Invalid format"));
        }
    }

    @Test
    public void getUnderflowDate() throws Exception {
        try {
            client.getDateOperations().getUnderflowDate();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("IllegalFieldValueException"));
        }
    }

    @Test
    public void putMaxDate() throws Exception {
        LocalDate body = new LocalDate(9999, 12, 31);
        client.getDateOperations().putMaxDate(body);
    }

    @Test
    public void getMaxDate() throws Exception {
        LocalDate expected = new LocalDate(9999, 12, 31);
        LocalDate result = client.getDateOperations().getMaxDate();
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putMinDate() throws Exception {
        LocalDate body = new LocalDate(1, 1, 1);
        client.getDateOperations().putMinDate(body);
    }

    @Test
    public void getMinDate() throws Exception {
        LocalDate expected = new LocalDate(1, 1, 1);
        LocalDate result = client.getDateOperations().getMinDate();
        Assert.assertEquals(expected, result);
    }
}
