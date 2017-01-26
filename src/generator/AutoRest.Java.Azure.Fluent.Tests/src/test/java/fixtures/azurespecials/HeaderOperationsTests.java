package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponseWithHeaders;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;
import fixtures.azurespecials.implementation.HeaderCustomNamedRequestIdHeadersInner;


public class HeaderOperationsTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void customNamedRequestId() throws Exception {
        ServiceResponseWithHeaders<Void, HeaderCustomNamedRequestIdHeadersInner> response = client.headers().customNamedRequestIdWithServiceResponseAsync("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0").toBlocking().last();
        Assert.assertEquals(200, response.response().code());
        Assert.assertEquals("123", response.headers().fooRequestId());
    }
}
