package fixtures.azurespecials;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionDefaultTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void getMethodGlobalValid() throws Exception {
        client.apiVersionDefaults().getMethodGlobalValid();
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        client.apiVersionDefaults().getMethodGlobalNotProvidedValid();
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        client.apiVersionDefaults().getPathGlobalValid();
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        client.apiVersionDefaults().getSwaggerGlobalValid();
    }
}
