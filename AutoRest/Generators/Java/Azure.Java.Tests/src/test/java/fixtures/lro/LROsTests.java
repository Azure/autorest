package fixtures.lro;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.microsoft.rest.serializer.JacksonHelper;
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

public class LROsTests {
    static AutoRestLongRunningOperationTestService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient httpClient = new OkHttpClient();
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        httpClient.setCookieHandler(cookieManager);
        Executor executor = Executors.newCachedThreadPool();
        Retrofit.Builder builder = new Retrofit.Builder()
                .addConverterFactory(JacksonConverterFactory.create(new AzureJacksonHelper().getObjectMapper()))
                .callbackExecutor(executor);

        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", httpClient, builder);
        client.setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put200Succeeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put200Succeeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

}
