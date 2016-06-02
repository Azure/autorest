package fixtures.lro;

import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.models.Product;
import fixtures.lro.models.Sku;
import fixtures.lro.models.SubProduct;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class LROsTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost:3000", null);
        client.getAzureClient().withLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put200Succeeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().put200Succeeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void put200SucceededNoState() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().put200SucceededNoState(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().id());
    }

    @Test
    public void put202Retry200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().put202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().id());
    }

    @Ignore("Can cause flakiness - only run manually")
    public void put202Retry200Async() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        long startTime = System.currentTimeMillis();
        final long[] callbackTime = new long[1];
        Product product = new Product();
        product.withLocation("West US");
        client.getAzureClient().withLongRunningOperationRetryTimeout(1);
        client.lROs().put202Retry200Async(product, new ServiceCallback<Product>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Product> result) {
                Assert.assertEquals(200, result.getResponse().code());
                Assert.assertEquals("100", result.getBody().id());
                callbackTime[0] = System.currentTimeMillis();
                lock.countDown();
            }
        });
        long endTime = System.currentTimeMillis();
        Assert.assertTrue(500 > endTime - startTime);
        Assert.assertTrue(lock.await(3000, TimeUnit.MILLISECONDS));
        client.getAzureClient().withLongRunningOperationRetryTimeout(0);
        Assert.assertTrue(1000 < callbackTime[0] - startTime);
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void put200UpdatingSucceeded204() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().put200UpdatingSucceeded204(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void put201CreatingFailed200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            ServiceResponse<Product> response = client.lROs().put201CreatingFailed200(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void put200Acceptedcanceled200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            ServiceResponse<Product> response = client.lROs().put200Acceptedcanceled200(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().putNoHeaderInRetry(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().putAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().putAsyncNoRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putAsyncRetryFailed() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            ServiceResponse<Product> response = client.lROs().putAsyncRetryFailed(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoRetrycanceled() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            ServiceResponse<Product> response = client.lROs().putAsyncNoRetrycanceled(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().putAsyncNoHeaderInRetry(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putNonResource() throws Exception {
        Sku sku = new Sku();
        ServiceResponse<Sku> response = client.lROs().putNonResource(sku);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().id());
    }

    @Test
    public void putAsyncNonResource() throws Exception {
        Sku sku = new Sku();
        ServiceResponse<Sku> response = client.lROs().putAsyncNonResource(sku);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("100", response.getBody().id());
    }

    @Test
    public void putSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        ServiceResponse<SubProduct> response = client.lROs().putSubResource(subProduct);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putAsyncSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        ServiceResponse<SubProduct> response = client.lROs().putAsyncSubResource(subProduct);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        ServiceResponse<Product> response = client.lROs().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void deleteProvisioning202DeletingFailed200() throws Exception {
        ServiceResponse<Product> response = client.lROs().deleteProvisioning202DeletingFailed200();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Failed", response.getBody().provisioningState());
    }

    @Test
    public void deleteProvisioning202Deletingcanceled200() throws Exception {
        ServiceResponse<Product> response = client.lROs().deleteProvisioning202Deletingcanceled200();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Canceled", response.getBody().provisioningState());
    }

    @Test
    public void delete204Succeeded() throws Exception {
        ServiceResponse<Void> response = client.lROs().delete204Succeeded();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void delete202Retry200() throws Exception {
        ServiceResponse<Product> response = client.lROs().delete202Retry200();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void delete202NoRetry204() throws Exception {
        ServiceResponse<Product> response = client.lROs().delete202NoRetry204();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteNoHeaderInRetry() throws Exception {
        ServiceResponse<Void> response = client.lROs().deleteNoHeaderInRetry();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteAsyncNoHeaderInRetry() throws Exception {
        ServiceResponse<Void> response = client.lROs().deleteAsyncNoHeaderInRetry();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.lROs().deleteAsyncRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncNoRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.lROs().deleteAsyncNoRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRetryFailed() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROs().deleteAsyncRetryFailed();
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void deleteAsyncRetrycanceled() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROs().deleteAsyncRetrycanceled();
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void post200WithPayload() throws Exception {
        ServiceResponse<Sku> response = client.lROs().post200WithPayload();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("1", response.getBody().id());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Void> response = client.lROs().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void post202NoRetry204() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().post202NoRetry204(product);
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().postAsyncRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        ServiceResponse<Product> response = client.lROs().postAsyncNoRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRetryFailed() throws Exception {
        try {
            Product product = new Product();
            product.withLocation("West US");
            ServiceResponse<Void> response = client.lROs().postAsyncRetryFailed(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }

    @Test
    public void postAsyncRetrycanceled() throws Exception {
        try {
            Product product = new Product();
            product.withLocation("West US");
            ServiceResponse<Void> response = client.lROs().postAsyncRetrycanceled(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed", e.getMessage());
        }
    }
}
