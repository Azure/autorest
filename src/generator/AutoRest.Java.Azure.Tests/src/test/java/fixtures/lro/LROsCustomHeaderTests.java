package fixtures.lro;

import com.microsoft.azure.CustomHeaderInterceptor;
import com.microsoft.rest.ServiceResponse;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.Map;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.models.Product;

public class LROsCustomHeaderTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;
    private static Map<String, String> customHeaders;
    private static CustomHeaderInterceptor customHeaderInterceptor;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost:3000", null);
        client.restClient().headers().addHeader("x-ms-client-request-id", "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        client.getAzureClient().withLongRunningOperationRetryTimeout(0);
    }

    @AfterClass
    public static void cleanup() {
        client.restClient().headers().removeHeader("x-ms-client-request-id");
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROsCustomHeaders().putAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROsCustomHeaders().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Void> response = client.lROsCustomHeaders().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Void> response = client.lROsCustomHeaders().postAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
