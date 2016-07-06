package fixtures.url;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.url.implementation.AutoRestUrlTestServiceImpl;

public class PathItemsTests {
    private static AutoRestUrlTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestUrlTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getAllWithValues() throws Exception {
        client.withGlobalStringPath("globalStringPath");
        client.withGlobalStringQuery("globalStringQuery");
        client.pathItems().getAllWithValues(
                "localStringPath",
                "pathItemStringPath",
                "localStringQuery",
                "pathItemStringQuery"
        );
    }

    @Test
    public void getGlobalQueryNull() throws Exception {
        client.withGlobalStringPath("globalStringPath");
        client.withGlobalStringQuery(null);
        client.pathItems().getGlobalQueryNull(
                "localStringPath",
                "pathItemStringPath",
                "localStringQuery",
                "pathItemStringQuery"
        );
    }

    @Test
    public void getGlobalAndLocalQueryNull() throws Exception {
        client.withGlobalStringPath("globalStringPath");
        client.withGlobalStringQuery(null);
        client.pathItems().getGlobalAndLocalQueryNull(
                "localStringPath",
                "pathItemStringPath",
                null,
                "pathItemStringQuery"
        );
    }

    @Test
    public void getLocalPathItemQueryNull() throws Exception {
        client.withGlobalStringPath("globalStringPath");
        client.withGlobalStringQuery("globalStringQuery");
        client.pathItems().getLocalPathItemQueryNull(
                "localStringPath",
                "pathItemStringPath",
                null,
                null
        );
    }
}
