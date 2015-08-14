package fixtures.bodyinteger;

import com.microsoft.rest.ServiceException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class IntOperationsTests {
    static AutoRestIntegerTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestIntegerTestServiceImpl("localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        try {
            client.getIntOperations().getNull();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(NullPointerException.class, exception.getClass());
        }
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getIntOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("Expected an int but was STRING"));
        }
    }

    @Test
    public void getOverflowInt32() throws Exception {
        try {
            client.getIntOperations().getOverflowInt32();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
        }
    }
}
