package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;

import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import fixtures.azurespecials.implementation.api.AutoRestAzureSpecialParametersTestClientImpl;
import fixtures.azurespecials.implementation.api.SkipUrlEncodingsInner;


public class SkipUrlEncodingTests {
    private static final int OK_STATUS_CODE = 200;
    private static final int NOT_FOUND_STATUS_CODE = 404;

    private static String baseUrl = "http://localhost.:3000";
    private static String unencodedPath = "path1/path2/path3";
    private static String unencodedQuery = "value1&q2=value2&q3=value3";

    private static SkipUrlEncodingsInner client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl(baseUrl, null).skipUrlEncodings();
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getMethodPathValid() throws Exception {
        ServiceResponse<Void> response = client.getMethodPathValid(unencodedPath);
        // Will throw ServiceException if not 200.
        //Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getPathPathValid() throws Exception {
        ServiceResponse<Void> response = client.getPathPathValid(unencodedPath);
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getSwaggerPathValid() throws Exception {
        ServiceResponse<Void> response = client.getSwaggerPathValid();
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getMethodQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getMethodQueryValid(unencodedQuery);
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getPathQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getPathQueryValid(unencodedQuery);
    }

    @Ignore("wait for this release -- https://github.com/square/retrofit/commit/2ea70568bd057fa9235ae5183cebbde1659af84d")
    public void getSwaggerQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getSwaggerQueryValid();
    }

    @Test
    public void getMethodQueryNull() throws Exception {
        ServiceResponse<Void> response = client.getMethodQueryNull(null);
    }

}
