package fixtures.bodyboolean;

import com.fasterxml.jackson.core.JsonParseException;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodyboolean.implementation.AutoRestBoolTestServiceImpl;

public class BoolTests {
    private static AutoRestBoolTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestBoolTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.bools().getNull().getBody());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.bools().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }

    @Test
    public void getTrue() throws Exception {
        boolean result = client.bools().getTrue().getBody();
        Assert.assertTrue(result);
    }

    @Test
    public void getFalse() throws Exception {
        boolean result = client.bools().getFalse().getBody();
        Assert.assertFalse(result);
    }

    @Test
    public void putTrue() throws Exception {
        client.bools().putTrue(true);
    }

    @Test
    public void putFalse() throws Exception {
        client.bools().putFalse(false);
    }
}
