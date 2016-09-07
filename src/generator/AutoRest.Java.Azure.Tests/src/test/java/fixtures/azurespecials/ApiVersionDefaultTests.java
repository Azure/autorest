package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionDefaultTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", null);
    }

    @Test
    public void getMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getMethodGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getMethodGlobalNotProvidedValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getPathGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionDefaults().getSwaggerGlobalValidWithServiceResponseAsync().toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
