package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ApiVersionLocalTests {
    static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000");
    }

    @Test
    public void GetMethodLocalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionLocal().getMethodLocalValid("2.0");
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionLocal().getMethodLocalNull(null);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionLocal().getPathLocalValid("2.0");
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionLocal().getSwaggerLocalValid("2.0");
        Assert.assertEquals(200, response.getResponse().code());
    }
}
