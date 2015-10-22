package fixtures.lro;

import com.microsoft.rest.CloudError;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.microsoft.rest.serializer.JacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.models.Product;
import fixtures.lro.models.Sku;
import fixtures.lro.models.SubProduct;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import javax.xml.ws.Service;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import static org.junit.Assert.fail;

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

    @Test
    public void put200SucceededNoState() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put200SucceededNoState(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().getId());
    }

    @Test
    public void put202Retry200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().getId());
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void put200UpdatingSucceeded204() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put200UpdatingSucceeded204(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void put201CreatingFailed200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROs().put201CreatingFailed200(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void put200Acceptedcanceled200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROs().put200Acceptedcanceled200(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().putNoHeaderInRetry(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().putAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().putAsyncNoRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putAsyncRetryFailed() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROs().putAsyncRetryFailed(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoRetrycanceled() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROs().putAsyncNoRetrycanceled(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().putAsyncNoHeaderInRetry(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putNonResource() throws Exception {
        Sku sku = new Sku();
        ServiceResponse<Sku> response = client.getLROs().putNonResource(sku);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().getId());
    }

    @Test
    public void putAsyncNonResource() throws Exception {
        Sku sku = new Sku();
        ServiceResponse<Sku> response = client.getLROs().putAsyncNonResource(sku);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().getId());
    }

    @Test
    public void putSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        ServiceResponse<SubProduct> response = client.getLROs().putSubResource(subProduct);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void putAsyncSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        ServiceResponse<SubProduct> response = client.getLROs().putAsyncSubResource(subProduct);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }
}
