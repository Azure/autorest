package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.TokenCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

public class SubscriptionInCredentialsTests {
    private static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new TokenCredentials(null, UUID.randomUUID().toString()));
        client.setSubscriptionId("1234-5678-9012-3456");
    }

    @Test
    public void postMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getSubscriptionInCredentialsOperations().postMethodGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.getSubscriptionInCredentialsOperations().postMethodGlobalNotProvidedValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getSubscriptionInCredentialsOperations().postPathGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getSubscriptionInCredentialsOperations().postSwaggerGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
