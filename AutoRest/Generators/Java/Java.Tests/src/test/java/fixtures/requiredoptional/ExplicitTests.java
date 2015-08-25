package fixtures.requiredoptional;

import com.microsoft.rest.ServiceException;
import fixtures.bodyboolean.AutoRestBoolTestService;
import fixtures.bodyboolean.AutoRestBoolTestServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ExplicitTests {
    static AutoRestRequiredOptionalTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRequiredOptionalTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void postRequiredIntegerParameter() throws Exception {
//        try {
//            client.getExplicit().postRequiredIntegerParameter(null);
//            Assert.assertTrue(false);
//        } catch (Exception exception) {
//            // expected
//            Assert.assertEquals(ServiceException.class, exception.getClass());
//            Assert.assertTrue(exception.getMessage().contains("JsonMappingException"));
//        }
    }
}
