package fixtures.lro;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class LRORetrysTests {
    private static AutoRestLongRunningOperationTestService client;

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
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLRORetrysOperations().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putAsyncRelativeRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLRORetrysOperations().putAsyncRelativeRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        ServiceResponse<Product> response = client.getLRORetrysOperations().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void delete202Retry200() throws Exception {
        ServiceResponse<Void> response = client.getLRORetrysOperations().delete202Retry200();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRelativeRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.getLRORetrysOperations().deleteAsyncRelativeRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.getLRORetrysOperations().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRelativeRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.getLRORetrysOperations().postAsyncRelativeRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
