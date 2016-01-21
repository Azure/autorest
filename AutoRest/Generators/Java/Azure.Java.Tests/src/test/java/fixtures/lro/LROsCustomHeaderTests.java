package fixtures.lro;

import com.microsoft.azure.CustomHeaderInterceptor;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.models.Product;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class LROsCustomHeaderTests {
    private static AutoRestLongRunningOperationTestService client;
    private static Map<String, String> customHeaders;
    private static CustomHeaderInterceptor customHeaderInterceptor;

    @BeforeClass
    public static void setup() {
        OkHttpClient httpClient = new OkHttpClient();
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        httpClient.setCookieHandler(cookieManager);
        Executor executor = Executors.newCachedThreadPool();
        Retrofit.Builder builder = new Retrofit.Builder()
                .addConverterFactory(JacksonConverterFactory.create(new AzureJacksonMapperAdapter().getObjectMapper()))
                .callbackExecutor(executor);

        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", null, httpClient, builder);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
        customHeaders = new HashMap<>();
        customHeaders.put("x-ms-client-request-id", "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        customHeaderInterceptor = new CustomHeaderInterceptor().addHeaderMap(customHeaders);
        client.getClientInterceptors().add(customHeaderInterceptor);
    }

    @AfterClass
    public static void cleanup() {
        client.getClientInterceptors().remove(customHeaderInterceptor);
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROsCustomHeaderOperations().putAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROsCustomHeaderOperations().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.getLROsCustomHeaderOperations().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.getLROsCustomHeaderOperations().postAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
