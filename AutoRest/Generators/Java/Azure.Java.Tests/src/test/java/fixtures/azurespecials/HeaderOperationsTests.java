package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class HeaderOperationsTests {
    static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000");
    }

    @Test
    public void customNamedRequestId() throws Exception {
        ServiceResponse<Void> response = client.getHeaderOperations().customNamedRequestId("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        Assert.assertEquals(200, response.getResponse().code());
    }
}
