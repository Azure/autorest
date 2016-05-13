package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.TokenCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

import fixtures.azurespecials.implementation.api.AutoRestAzureSpecialParametersTestClientImpl;

import static org.junit.Assert.fail;

public class SubscriptionInMethodTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000", new TokenCredentials(null, UUID.randomUUID().toString()));
        client.setSubscriptionId("1234-5678-9012-3456");
    }

    @Test
    public void postMethodLocalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInMethods().postMethodLocalValid("1234-5678-9012-3456");
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postMethodLocalNull() throws Exception {
        try {
            ServiceResponse<Void> response = client.subscriptionInMethods().postMethodLocalNull(null);
            fail();
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter subscriptionId is required"));
        }
    }

    @Test
    public void postPathLocalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInMethods().postPathLocalValid("1234-5678-9012-3456");
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postSwaggerLocalValid() throws Exception {
        ServiceResponse<Void> response = client.subscriptionInMethods().postSwaggerLocalValid("1234-5678-9012-3456");
        Assert.assertEquals(200, response.getResponse().code());
    }
}
