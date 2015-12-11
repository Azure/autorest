package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ApiVersionDefaultTests {
    private static AutoRestAzureSpecialParametersTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost.:3000");
    }

    @Test
    public void getMethodGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionDefault().getMethodGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionDefault().getMethodGlobalNotProvidedValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionDefault().getPathGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.getApiVersionDefault().getSwaggerGlobalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
