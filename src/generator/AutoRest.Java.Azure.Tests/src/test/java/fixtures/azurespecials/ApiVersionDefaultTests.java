package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionDefaultTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void getMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getMethodGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getMethodGlobalNotProvidedValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getPathGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getSwaggerGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }
}
