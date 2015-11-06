package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class SubscriptionInCredentialsTests {
    static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000");
        client.setSubscriptionId("1234-5678-9012-3456");
    }

    @Test
    public void postMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getSubscriptionInCredentials().postMethodGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
