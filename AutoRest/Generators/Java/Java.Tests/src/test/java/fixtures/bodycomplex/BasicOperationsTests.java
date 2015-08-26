package fixtures.bodycomplex;

import com.microsoft.rest.ServiceException;
import fixtures.bodyboolean.AutoRestBoolTestService;
import fixtures.bodyboolean.AutoRestBoolTestServiceImpl;
import fixtures.bodycomplex.models.Basic;
import fixtures.bodycomplex.models.CMYKColors;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class BasicOperationsTests {
    static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        Basic result = client.getBasicOperations().getValid();
        Assert.assertEquals(2, result.getId().intValue());
        Assert.assertEquals("abc", result.getName());
        Assert.assertEquals(CMYKColors.YELLOW, result.getColor());
    }

    @Test
    public void putValid() throws Exception {
        Basic body = new Basic();
        body.setId(2);
        body.setName("abc");
        body.setColor(CMYKColors.MAGENTA);
        client.getBasicOperations().putValid(body);
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getBasicOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        Basic result = client.getBasicOperations().getEmpty();
        Assert.assertNull(result.getName());
    }

    @Test
    public void getNull() throws Exception {
        Basic result = client.getBasicOperations().getNull();
        Assert.assertNull(result.getName());
    }

    @Test
    public void getNotProvided() throws Exception {
        Assert.assertNull(client.getBasicOperations().getNotProvided());
    }
}
