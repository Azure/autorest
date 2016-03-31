package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ApiVersionLocalTests {
    private static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000", null);
    }

    @Test
    public void getMethodLocalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocal().getMethodLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocal().getMethodLocalNull(null);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocal().getPathLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocal().getSwaggerLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
