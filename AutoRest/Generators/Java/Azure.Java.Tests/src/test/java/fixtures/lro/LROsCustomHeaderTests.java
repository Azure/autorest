package fixtures.lro;

import com.microsoft.azure.CustomHeaderInterceptor;
import com.microsoft.rest.ServiceResponse;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import fixtures.lro.implementation.api.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.models.implementation.api.ProductInner;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;

public class LROsCustomHeaderTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;
    private static Map<String, String> customHeaders;
    private static CustomHeaderInterceptor customHeaderInterceptor;

    @BeforeClass
    public static void setup() {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder();
        customHeaders = new HashMap<>();
        customHeaders.put("x-ms-client-request-id", "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        customHeaderInterceptor = new CustomHeaderInterceptor().addHeaderMap(customHeaders);

        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", null, clientBuilder, new Retrofit.Builder());
        client.getClientInterceptors().add(customHeaderInterceptor);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
        client.setLogLevel(HttpLoggingInterceptor.Level.BODY);
    }

    @AfterClass
    public static void cleanup() {
        client.getClientInterceptors().remove(customHeaderInterceptor);
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.setLocation("West US");
        ServiceResponse<ProductInner> response = client.lROsCustomHeaders().putAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        ProductInner product = new ProductInner();
        product.setLocation("West US");
        ServiceResponse<ProductInner> response = client.lROsCustomHeaders().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void post202Retry200() throws Exception {
        ProductInner product = new ProductInner();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.lROsCustomHeaders().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.lROsCustomHeaders().postAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
