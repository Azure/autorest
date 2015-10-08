package fixtures.requiredoptional;

import com.microsoft.rest.ServiceException;
import fixtures.requiredoptional.models.*;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class ExplicitTests {
    static AutoRestRequiredOptionalTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRequiredOptionalTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void postRequiredIntegerParameter() throws Exception {
        // Compile time error
        //client.getExplicit().postRequiredIntegerParameter(null);
    }

    @Test
    public void postOptionalIntegerParameter() throws Exception {
        try {
            client.getExplicit().postOptionalIntegerParameter(null);
            fail();
        } catch (ServiceException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredIntegerProperty() throws Exception {
        // Compile time error
        //IntWrapper body = new IntWrapper();
        //body.setValue(null);
    }

    @Test
    public void postOptionalIntegerProperty() throws Exception {
        IntOptionalWrapper body = new IntOptionalWrapper();
        body.setValue(null);
        client.getExplicit().postOptionalIntegerProperty(body);
    }

    @Test
    public void postRequiredIntegerHeader() throws Exception {
        // Compile time error
        //client.getExplicit().postRequiredIntegerHeader(null);
    }

    @Test
    public void postOptionalIntegerHeader() throws Exception {
        client.getExplicit().postOptionalIntegerHeader(null);
    }

    @Test
    public void postRequiredStringParameter() throws Exception {
        try {
            client.getExplicit().postRequiredStringParameter(null);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalStringParameter() throws Exception {
        try {
            client.getExplicit().postOptionalIntegerParameter(null);
            fail();
        } catch (ServiceException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredStringProperty() throws Exception {
        try {
            StringWrapper body = new StringWrapper();
            body.setValue(null);
            client.getExplicit().postRequiredStringProperty(body);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(IllegalArgumentException.class, ex.getCause().getClass());
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalStringProperty() throws Exception {
        StringOptionalWrapper body = new StringOptionalWrapper();
        body.setValue(null);
        client.getExplicit().postOptionalStringProperty(body);
    }

    @Test
    public void postRequiredStringHeader() throws Exception {
        try {
            client.getExplicit().postRequiredStringHeader(null);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter headerParameter is required"));
        }
    }

    @Test
    public void postOptionalStringHeader() throws Exception {
        client.getExplicit().postOptionalStringHeader(null);
    }

    @Test
    public void postRequiredClassParameter() throws Exception {
        try {
            client.getExplicit().postRequiredClassParameter(null);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalClassParameter() throws Exception {
        try {
            client.getExplicit().postOptionalClassParameter(null);
            fail();
        } catch (ServiceException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredClassProperty() throws Exception {
        try {
            ClassWrapper body = new ClassWrapper();
            body.setValue(null);
            client.getExplicit().postRequiredClassProperty(body);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(IllegalArgumentException.class, ex.getCause().getClass());
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalClassProperty() throws Exception {
        ClassOptionalWrapper body = new ClassOptionalWrapper();
        body.setValue(null);
        client.getExplicit().postOptionalClassProperty(body);
    }

    @Test
    public void postRequiredArrayParameter() throws Exception {
        try {
            client.getExplicit().postRequiredArrayParameter(null);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalArrayParameter() throws Exception {
        try {
            client.getExplicit().postOptionalArrayParameter(null);
            fail();
        } catch (ServiceException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredArrayProperty() throws Exception {
        try {
            ArrayWrapper body = new ArrayWrapper();
            body.setValue(null);
            client.getExplicit().postRequiredArrayProperty(body);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(IllegalArgumentException.class, ex.getCause().getClass());
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalArrayProperty() throws Exception {
        ArrayOptionalWrapper body = new ArrayOptionalWrapper();
        body.setValue(null);
        client.getExplicit().postOptionalArrayProperty(body);
    }

    @Test
    public void postRequiredArrayHeader() throws Exception {
        try {
            client.getExplicit().postRequiredArrayHeader(null);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getCause().getMessage().contains("Parameter headerParameter is required"));
        }
    }

    @Test
    public void postOptionalArrayHeader() throws Exception {
        client.getExplicit().postOptionalArrayHeader(null);
    }
}
