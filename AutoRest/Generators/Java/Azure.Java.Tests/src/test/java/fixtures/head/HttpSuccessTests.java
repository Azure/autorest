package fixtures.head;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.head.implementation.AutoRestHeadTestServiceImpl;

public class HttpSuccessTests {
    private static AutoRestHeadTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHeadTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void head200() throws Exception {
        Assert.assertTrue(client.httpSuccess().head200().getBody());
    }

    @Test
    public void head204() throws Exception {
        Assert.assertTrue(client.httpSuccess().head204().getBody());
    }

    @Test
    public void head404() throws Exception {
        Assert.assertFalse(client.httpSuccess().head404().getBody());
    }
}
