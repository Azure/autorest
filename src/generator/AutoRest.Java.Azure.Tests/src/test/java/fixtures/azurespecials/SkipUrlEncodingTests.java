package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class SkipUrlEncodingTests {
    private static final int OK_STATUS_CODE = 200;
    private static final int NOT_FOUND_STATUS_CODE = 404;

    private static String baseUrl = "http://localhost:3000";
    private static String unencodedPath = "path1/path2/path3";
    private static String unencodedQuery = "value1&q2=value2&q3=value3";

    private static SkipUrlEncodings client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl(baseUrl, null).skipUrlEncodings();
    }

    @Test
    public void getMethodPathValid() throws Exception {
        ServiceResponse<Void> response = client.getMethodPathValid(unencodedPath);
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Test
    public void getPathPathValid() throws Exception {
        ServiceResponse<Void> response = client.getPathPathValid(unencodedPath);
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Test
    public void getSwaggerPathValid() throws Exception {
        ServiceResponse<Void> response = client.getSwaggerPathValid();
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getMethodQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getMethodQueryValid(unencodedQuery);
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getPathQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getPathQueryValid(unencodedQuery);
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getSwaggerQueryValid() throws Exception {
        ServiceResponse<Void> response = client.getSwaggerQueryValid();
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

    @Test
    public void getMethodQueryNull() throws Exception {
        ServiceResponse<Void> response = client.getMethodQueryNull(null);
        Assert.assertEquals(OK_STATUS_CODE, response.getResponse().code());
    }

}
