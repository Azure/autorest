package fixtures.bodyboolean;

import com.microsoft.rest.ServiceException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class BoolTests {
    static AutoRestBoolTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestBoolTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getBool().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getBool().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getTrue() throws Exception {
        boolean result = client.getBool().getTrue();
        Assert.assertTrue(result);
    }

    @Test
    public void getFalse() throws Exception {
        boolean result = client.getBool().getFalse();
        Assert.assertFalse(result);
    }

    @Test
    public void putTrue() throws Exception {
        client.getBool().putTrue(true);
    }

    @Test
    public void putFalse() throws Exception {
        client.getBool().putFalse(false);
    }
}
