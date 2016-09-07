package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponseWithHeaders;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;
import fixtures.azurespecials.models.HeaderCustomNamedRequestIdHeaders;
import fixtures.azurespecials.models.HeaderCustomNamedRequestIdParamGroupingHeaders;
import fixtures.azurespecials.models.HeaderCustomNamedRequestIdParamGroupingParameters;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class HeaderOperationsTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", null);
    }

    @Test
    public void customNamedRequestId() throws Exception {
        ServiceResponseWithHeaders<Void, HeaderCustomNamedRequestIdHeaders> response = client.headers().customNamedRequestIdWithServiceResponseAsync("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0").toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("123", response.getHeaders().fooRequestId());
    }

    @Test
    public void customNamedRequestIdParamGrouping() throws Exception {
        HeaderCustomNamedRequestIdParamGroupingParameters group = new HeaderCustomNamedRequestIdParamGroupingParameters();
        group.withFooClientRequestId("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        ServiceResponseWithHeaders<Void, HeaderCustomNamedRequestIdParamGroupingHeaders> response = client.headers().customNamedRequestIdParamGroupingWithServiceResponseAsync(group).toBlocking().last();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("123", response.getHeaders().fooRequestId());
    }
}
