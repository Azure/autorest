package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.credentials.TokenCredentials;
import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

public class XMsClientRequestIdTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new TokenCredentials(null, UUID.randomUUID().toString()));
        client.withSubscriptionId("1234-5678-9012-3456");
    }

    @Test
    public void get() throws Exception {
        client.restClient().headers().removeHeader("x-ms-client-request-id");
        client.restClient().headers().addHeader("x-ms-client-request-id", "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        ServiceResponse<Void> response = client.xMsClientRequestIds().getWithServiceResponseAsync().toBlocking().last();
        client.restClient().headers().removeHeader("x-ms-client-request-id");
        Assert.assertEquals(200, response.response().code());
    }

    @Test
    public void paramGet() throws Exception {
        client.restClient().headers().removeHeader("x-ms-client-request-id");
        ServiceResponse<Void> response = client.xMsClientRequestIds().paramGetWithServiceResponseAsync("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0").toBlocking().last();
        Assert.assertEquals(200, response.response().code());
    }
}
