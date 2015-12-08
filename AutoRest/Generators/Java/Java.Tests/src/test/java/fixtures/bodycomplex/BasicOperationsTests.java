package fixtures.bodycomplex;

import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import fixtures.bodycomplex.models.Basic;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class BasicOperationsTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        Basic result = client.getBasicOperations().getValid().getBody();
        Assert.assertEquals(2, result.getId().intValue());
        Assert.assertEquals("abc", result.getName());
        Assert.assertEquals("YELLOW", result.getColor());
    }

    @Test
    public void putValid() throws Exception {
        Basic body = new Basic();
        body.setId(2);
        body.setName("abc");
        body.setColor("Magenta");
        client.getBasicOperations().putValid(body);
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getBasicOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(InvalidFormatException.class, exception.getClass());
        }
    }

    @Test
    public void getEmpty() throws Exception {
        Basic result = client.getBasicOperations().getEmpty().getBody();
        Assert.assertNull(result.getName());
    }

    @Test
    public void getNull() throws Exception {
        Basic result = client.getBasicOperations().getNull().getBody();
        Assert.assertNull(result.getName());
    }

    @Test
    public void getNotProvided() throws Exception {
        Assert.assertNull(client.getBasicOperations().getNotProvided().getBody());
    }
}
