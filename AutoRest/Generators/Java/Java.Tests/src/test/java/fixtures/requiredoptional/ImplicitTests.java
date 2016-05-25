package fixtures.requiredoptional;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class ImplicitTests {
    private static AutoRestRequiredOptionalTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRequiredOptionalTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getRequiredPath() throws Exception {
        try {
            client.getImplicitOperations().getRequiredPath(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter pathParameter is required"));
        }
    }

    @Test
    public void putOptionalQuery() throws Exception {
        client.getImplicitOperations().putOptionalQuery(null);
    }

    @Test
    public void putOptionalHeader() throws Exception {
        client.getImplicitOperations().putOptionalHeader(null);
    }

    @Test
    public void putOptionalBody() throws Exception {
        try {
            client.getImplicitOperations().putOptionalBody(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Body parameter value must not be null"));
        }
    }

    @Test
    public void getRequiredGlobalPath() throws Exception {
        try {
            client.getImplicitOperations().getRequiredGlobalPath();
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("this.client.getRequiredGlobalPath() is required"));
        }
    }

    @Test
    public void getRequiredGlobalQuery() throws Exception {
        try {
            client.getImplicitOperations().getRequiredGlobalQuery();
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("this.client.getRequiredGlobalQuery() is required"));
        }
    }

    @Test
    public void getOptionalGlobalQuery() throws Exception {
        client.getImplicitOperations().getOptionalGlobalQuery();
    }
}
