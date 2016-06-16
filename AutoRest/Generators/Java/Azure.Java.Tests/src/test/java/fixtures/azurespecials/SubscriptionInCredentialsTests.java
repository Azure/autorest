package fixtures.azurespecials;

import com.microsoft.azure.RequestIdHeaderInterceptor;
import com.microsoft.azure.RestClient;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.TokenCredentials;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class SubscriptionInCredentialsTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        RestClient restClient = new RestClient.Builder()
                .withBaseUrl("http://localhost:3000")
                .withCredentials(new TokenCredentials(null, UUID.randomUUID().toString()))
                .withInterceptor(new RequestIdHeaderInterceptor())
                .build();
        client = new AutoRestAzureSpecialParametersTestClientImpl(restClient);
        client.withSubscriptionId("1234-5678-9012-3456");
    }

    @Test
    public void postMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInCredentials().postMethodGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInCredentials().postMethodGlobalNotProvidedValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInCredentials().postPathGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInCredentials().postSwaggerGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
