package fixtures.requiredoptional;

import fixtures.requiredoptional.models.ArrayOptionalWrapper;
import fixtures.requiredoptional.models.ArrayWrapper;
import fixtures.requiredoptional.models.ClassOptionalWrapper;
import fixtures.requiredoptional.models.ClassWrapper;
import fixtures.requiredoptional.models.IntOptionalWrapper;
import fixtures.requiredoptional.models.StringOptionalWrapper;
import fixtures.requiredoptional.models.StringWrapper;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class ExplicitTests {
    private static AutoRestRequiredOptionalTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestRequiredOptionalTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void postRequiredIntegerParameter() throws Exception {
        // Compile time error
        //client.explicit().postRequiredIntegerParameter(null);
    }

    @Test
    public void postOptionalIntegerParameter() throws Exception {
        try {
            client.explicit().postOptionalIntegerParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
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
        client.explicit().postOptionalIntegerProperty(body);
    }

    @Test
    public void postRequiredIntegerHeader() throws Exception {
        // Compile time error
        //client.explicit().postRequiredIntegerHeader(null);
    }

    @Test
    public void postOptionalIntegerHeader() throws Exception {
        client.explicit().postOptionalIntegerHeader(null);
    }

    @Test
    public void postRequiredStringParameter() throws Exception {
        try {
            client.explicit().postRequiredStringParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalStringParameter() throws Exception {
        try {
            client.explicit().postOptionalIntegerParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredStringProperty() throws Exception {
        try {
            StringWrapper body = new StringWrapper();
            body.setValue(null);
            client.explicit().postRequiredStringProperty(body);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalStringProperty() throws Exception {
        StringOptionalWrapper body = new StringOptionalWrapper();
        body.setValue(null);
        client.explicit().postOptionalStringProperty(body);
    }

    @Test
    public void postRequiredStringHeader() throws Exception {
        try {
            client.explicit().postRequiredStringHeader(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter headerParameter is required"));
        }
    }

    @Test
    public void postOptionalStringHeader() throws Exception {
        client.explicit().postOptionalStringHeader(null);
    }

    @Test
    public void postRequiredClassParameter() throws Exception {
        try {
            client.explicit().postRequiredClassParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalClassParameter() throws Exception {
        try {
            client.explicit().postOptionalClassParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredClassProperty() throws Exception {
        try {
            ClassWrapper body = new ClassWrapper();
            body.setValue(null);
            client.explicit().postRequiredClassProperty(body);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalClassProperty() throws Exception {
        ClassOptionalWrapper body = new ClassOptionalWrapper();
        body.setValue(null);
        client.explicit().postOptionalClassProperty(body);
    }

    @Test
    public void postRequiredArrayParameter() throws Exception {
        try {
            client.explicit().postRequiredArrayParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bodyParameter is required"));
        }
    }

    @Test
    public void postOptionalArrayParameter() throws Exception {
        try {
            client.explicit().postOptionalArrayParameter(null);
            fail();
        } catch (IllegalArgumentException ex) {
            // Body parameter cannot be null
        }
    }

    @Test
    public void postRequiredArrayProperty() throws Exception {
        try {
            ArrayWrapper body = new ArrayWrapper();
            body.setValue(null);
            client.explicit().postRequiredArrayProperty(body);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void postOptionalArrayProperty() throws Exception {
        ArrayOptionalWrapper body = new ArrayOptionalWrapper();
        body.setValue(null);
        client.explicit().postOptionalArrayProperty(body);
    }

    @Test
    public void postRequiredArrayHeader() throws Exception {
        try {
            client.explicit().postRequiredArrayHeader(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter headerParameter is required"));
        }
    }

    @Test
    public void postOptionalArrayHeader() throws Exception {
        client.explicit().postOptionalArrayHeader(null);
    }
}
