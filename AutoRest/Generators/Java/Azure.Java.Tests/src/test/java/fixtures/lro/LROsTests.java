package fixtures.lro;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.models.Product;
import fixtures.lro.models.Sku;
import fixtures.lro.models.SubProduct;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

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

    @Ignore("Can cause flakiness - only run manually")
    public void put202Retry200Async() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        long startTime = System.currentTimeMillis();
        final long[] callbackTime = new long[1];
        Product product = new Product();
        product.setLocation("West US");
        client.getAzureClient().setLongRunningOperationRetryTimeout(1);
        client.getLROs().put202Retry200Async(product, new ServiceCallback<Product>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Product> result) {
                Assert.assertEquals(200, result.getResponse().code());
                Assert.assertEquals("100", result.getBody().getId());
                callbackTime[0] = System.currentTimeMillis();
                lock.countDown();
            }
        });
        long endTime = System.currentTimeMillis();
        Assert.assertTrue(500 > endTime - startTime);
        Assert.assertTrue(lock.await(3000, TimeUnit.MILLISECONDS));
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
        Assert.assertTrue(1000 < callbackTime[0] - startTime);
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

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        ServiceResponse<Product> response = client.getLROs().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void deleteProvisioning202DeletingFailed200() throws Exception {
        ServiceResponse<Product> response = client.getLROs().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void deleteProvisioning202Deletingcanceled200() throws Exception {
        ServiceResponse<Product> response = client.getLROs().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

    @Test
    public void delete204Succeeded() throws Exception {
        ServiceResponse<Void> response = client.getLROs().delete204Succeeded();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void delete202Retry200() throws Exception {
        ServiceResponse<Product> response = client.getLROs().delete202Retry200();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void delete202NoRetry204() throws Exception {
        ServiceResponse<Product> response = client.getLROs().delete202NoRetry204();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteNoHeaderInRetry() throws Exception {
        ServiceResponse<Void> response = client.getLROs().deleteNoHeaderInRetry();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteAsyncNoHeaderInRetry() throws Exception {
        ServiceResponse<Void> response = client.getLROs().deleteAsyncNoHeaderInRetry();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.getLROs().deleteAsyncRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncNoRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.getLROs().deleteAsyncNoRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRetryFailed() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROs().deleteAsyncRetryFailed();
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void deleteAsyncRetrycanceled() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROs().deleteAsyncRetrycanceled();
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void post200WithPayload() throws Exception {
        ServiceResponse<Sku> response = client.getLROs().post200WithPayload();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("1", response.getBody().getId());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.getLROs().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void post202NoRetry204() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().post202NoRetry204(product);
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().postAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().postAsyncNoRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRetryFailed() throws Exception {
        try {
            Product product = new Product();
            product.setLocation("West US");
            ServiceResponse<Void> response = client.getLROs().postAsyncRetryFailed(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void postAsyncRetrycanceled() throws Exception {
        try {
            Product product = new Product();
            product.setLocation("West US");
            ServiceResponse<Void> response = client.getLROs().postAsyncRetrycanceled(product);
            fail();
        } catch (ServiceException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }
}
