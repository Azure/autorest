package fixtures.url;

import org.junit.BeforeClass;
import org.junit.Test;

public class PathItemsTests {
    private static AutoRestUrlTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestUrlTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getAllWithValues() throws Exception {
        client.setGlobalStringPath("globalStringPath");
        client.setGlobalStringQuery("globalStringQuery");
        client.getPathItemsOperations().getAllWithValues(
                "localStringPath",
                "pathItemStringPath",
                "localStringQuery",
                "pathItemStringQuery"
        );
    }

    @Test
    public void getGlobalQueryNull() throws Exception {
        client.setGlobalStringPath("globalStringPath");
        client.setGlobalStringQuery(null);
        client.getPathItemsOperations().getGlobalQueryNull(
                "localStringPath",
                "pathItemStringPath",
                "localStringQuery",
                "pathItemStringQuery"
        );
    }

    @Test
    public void getGlobalAndLocalQueryNull() throws Exception {
        client.setGlobalStringPath("globalStringPath");
        client.setGlobalStringQuery(null);
        client.getPathItemsOperations().getGlobalAndLocalQueryNull(
                "localStringPath",
                "pathItemStringPath",
                null,
                "pathItemStringQuery"
        );
    }

    @Test
    public void getLocalPathItemQueryNull() throws Exception {
        client.setGlobalStringPath("globalStringPath");
        client.setGlobalStringQuery("globalStringQuery");
        client.getPathItemsOperations().getLocalPathItemQueryNull(
                "localStringPath",
                "pathItemStringPath",
                null,
                null
        );
    }
}
