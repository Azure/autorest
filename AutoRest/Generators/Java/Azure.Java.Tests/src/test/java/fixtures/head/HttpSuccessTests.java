package fixtures.head;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class HttpSuccessTests {
    private static AutoRestHeadTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHeadTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void head200() throws Exception {
        Assert.assertTrue(client.getHttpSuccessOperations().head200().getBody());
    }

    @Test
    public void head204() throws Exception {
        Assert.assertTrue(client.getHttpSuccessOperations().head204().getBody());
    }

    @Test
    public void head404() throws Exception {
        Assert.assertFalse(client.getHttpSuccessOperations().head404().getBody());
    }
}
