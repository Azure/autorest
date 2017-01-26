package fixtures.azurespecials;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class SkipUrlEncodingTests {
    private static String baseUrl = "http://localhost:3000";
    private static String unencodedPath = "path1/path2/path3";
    private static String unencodedQuery = "value1&q2=value2&q3=value3";

    private static SkipUrlEncodings client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl(baseUrl, new BasicAuthenticationCredentials(null, null)).skipUrlEncodings();
    }

    @Test
    public void getMethodPathValid() throws Exception {
        client.getMethodPathValid(unencodedPath);
    }

    @Test
    public void getPathPathValid() throws Exception {
        client.getPathPathValid(unencodedPath);
    }

    @Test
    public void getSwaggerPathValid() throws Exception {
        client.getSwaggerPathValid();
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getMethodQueryValid() throws Exception {
        client.getMethodQueryValid(unencodedQuery);
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getPathQueryValid() throws Exception {
        client.getPathQueryValid(unencodedQuery);
    }

    @Ignore("Not supported by OkHttp: https://github.com/square/okhttp/issues/2623")
    public void getSwaggerQueryValid() throws Exception {
        client.getSwaggerQueryValid();
    }

    @Test
    public void getMethodQueryNull() throws Exception {
        client.getMethodQueryNull(null);
    }

}
