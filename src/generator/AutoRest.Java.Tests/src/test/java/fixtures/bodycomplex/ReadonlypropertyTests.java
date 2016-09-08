package fixtures.bodycomplex;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.ReadonlyObj;

public class ReadonlypropertyTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void putReadOnlyPropertyValid() throws Exception {
        ReadonlyObj o = client.readonlypropertys().getValid();
        client.readonlypropertys().putValid(o);
    }
}
