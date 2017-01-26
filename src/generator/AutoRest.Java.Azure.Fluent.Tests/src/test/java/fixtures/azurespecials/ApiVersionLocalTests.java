package fixtures.azurespecials;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.azurespecials.implementation.AutoRestAzureSpecialParametersTestClientImpl;

public class ApiVersionLocalTests {
    private static AutoRestAzureSpecialParametersTestClientImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestAzureSpecialParametersTestClientImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void getMethodLocalValid() throws Exception {
        client.apiVersionLocals().getMethodLocalValid();
    }

    @Test
    public void getMethodGlobalNotProvidedValid() throws Exception {
        client.apiVersionLocals().getMethodLocalNull(null);
    }

    @Test
    public void getPathGlobalValid() throws Exception {
        client.apiVersionLocals().getPathLocalValid();
    }

    @Test
    public void getSwaggerGlobalValid() throws Exception {
        client.apiVersionLocals().getSwaggerLocalValid();
    }
}
