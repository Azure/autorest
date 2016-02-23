package fixtures.bodycomplex;

import fixtures.bodycomplex.models.ReadonlyObj;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.lang.reflect.Field;

public class ReadonlypropertyTest {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void putReadOnlyPropertyValid() throws Exception {
        ReadonlyObj o = client.getReadonlypropertyOperations().getValid().getBody();
        Assert.assertEquals(200, client.getReadonlypropertyOperations().putValid(o).getResponse().code());
    }
}
