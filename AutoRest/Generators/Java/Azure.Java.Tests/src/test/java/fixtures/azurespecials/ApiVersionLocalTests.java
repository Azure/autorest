package fixtures.azurespecials;

import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionLocalTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", null);
    }

    @Test
    public void getMethodLocalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getMethodLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getMethodLocalNull(null);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getPathLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        ServiceResponse<Void> response = client.apiVersionLocals().getSwaggerLocalValid();
        Assert.assertEquals(200, response.getResponse().code());
    }
}
