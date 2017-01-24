package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionLocalTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void getMethodLocalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getMethodLocalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getMethodLocalNullWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getPathLocalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getSwaggerLocalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }
}
