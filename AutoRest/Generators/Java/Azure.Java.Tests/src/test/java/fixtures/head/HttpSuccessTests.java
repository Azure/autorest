package fixtures.head;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class HttpSuccessTests {
    private static AutoRestHeadTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHeadTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void head200() throws Exception {
        Assert.assertTrue(client.getHttpSuccess().head200().getBody());
    }

    @Test
    public void head204() throws Exception {
        Assert.assertTrue(client.getHttpSuccess().head204().getBody());
    }

    @Test
    public void head404() throws Exception {
        Assert.assertFalse(client.getHttpSuccess().head404().getBody());
    }
}
