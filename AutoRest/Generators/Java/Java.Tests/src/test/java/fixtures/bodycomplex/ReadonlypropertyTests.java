package fixtures.bodycomplex;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.ReadonlyObj;
import org.junit.BeforeClass;
import org.junit.Test;

public class ReadonlypropertyTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void putReadOnlyPropertyValid() throws Exception {
        ReadonlyObj o = client.readonlypropertys().getValid().getBody();
        client.readonlypropertys().putValid(o).getResponse().code();
    }
}
