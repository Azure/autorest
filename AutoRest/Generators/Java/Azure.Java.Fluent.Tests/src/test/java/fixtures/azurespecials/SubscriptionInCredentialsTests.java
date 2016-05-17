package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.TokenCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

import fixtures.azurespecials.implementation.api.AutoRestAzureSpecialParametersTestClientImpl;

public class SubscriptionInCredentialsTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000", new TokenCredentials(null, UUID.randomUUID().toString()));
        client.setSubscriptionId("1234-5678-9012-3456");
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
