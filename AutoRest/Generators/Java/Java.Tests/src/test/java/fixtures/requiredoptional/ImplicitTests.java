package fixtures.requiredoptional;

import com.microsoft.rest.ServiceException;
import fixtures.requiredoptional.models.*;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ImplicitTests {
    static AutoRestRequiredOptionalTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRequiredOptionalTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getRequiredPath() throws Exception {
        try {
            client.getImplicit().getRequiredPath(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Parameter pathParameter is required"));
        }
    }

    @Test
    public void putOptionalQuery() throws Exception {
        try {
            client.getImplicit().putOptionalQuery(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("method PUT must have a request body"));
        }
    }

    @Test
    public void putOptionalHeader() throws Exception {
        try {
            client.getImplicit().putOptionalHeader(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("method PUT must have a request body"));
        }
    }

    @Test
    public void putOptionalBody() throws Exception {
        try {
            client.getImplicit().putOptionalBody(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Body parameter value must not be null"));
        }
    }

    @Test
    public void getRequiredGlobalPath() throws Exception {
        try {
            client.getImplicit().getRequiredGlobalPath();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("this.client.getRequiredGlobalPath() is required"));
        }
    }

    @Test
    public void getRequiredGlobalQuery() throws Exception {
        try {
            client.getImplicit().getRequiredGlobalQuery();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("this.client.getRequiredGlobalQuery() is required"));
        }
    }

    @Test
    public void getOptionalGlobalQuery() throws Exception {
        client.getImplicit().getOptionalGlobalQuery();
    }
}
