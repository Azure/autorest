package fixtures.lro;

import com.microsoft.azure.AzureResponseBuilder;
import com.microsoft.azure.CloudException;
import com.microsoft.azure.serializer.AzureJacksonAdapter;
import com.microsoft.rest.RestClient;
import com.microsoft.rest.ServiceCallback;
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
        RestClient restClient = new RestClient.Builder()
                .withBaseUrl("http://localhost:3000")
                .withSerializerAdapter(new AzureJacksonAdapter())
                .withResponseBuilderFactory(new AzureResponseBuilder.Factory())
                .build();
        client = new AutoRestLongRunningOperationTestServiceImpl(restClient);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put200Succeeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().put200Succeeded(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void put200SucceededNoState() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().put200SucceededNoState(product);
        Assert.assertEquals("100", response.id());
    }

    @Test
    public void put202Retry200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().put202Retry200(product);
        Assert.assertEquals("100", response.id());
    }

    @Ignore("Can cause flakiness - only run manually")
    public void put202Retry200Async() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        long startTime = System.currentTimeMillis();
        final long[] callbackTime = new long[1];
        Product product = new Product();
        product.withLocation("West US");
        client.getAzureClient().setLongRunningOperationRetryTimeout(1);
        client.lROs().put202Retry200Async(product, new ServiceCallback<Product>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(Product result) {
                Assert.assertEquals("100", result.id());
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
        product.withLocation("West US");
        Product response = client.lROs().put201CreatingSucceeded200(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void put200UpdatingSucceeded204() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().put200UpdatingSucceeded204(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void put201CreatingFailed200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            Product response = client.lROs().put201CreatingFailed200(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Failed", e.getMessage());
        }
    }

    @Test
    public void put200Acceptedcanceled200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            Product response = client.lROs().put200Acceptedcanceled200(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Canceled", e.getMessage());
        }
    }

    @Test
    public void putNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().putNoHeaderInRetry(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().putAsyncRetrySucceeded(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().putAsyncNoRetrySucceeded(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putAsyncRetryFailed() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            Product response = client.lROs().putAsyncRetryFailed(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Failed", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoRetrycanceled() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        try {
            Product response = client.lROs().putAsyncNoRetrycanceled(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Canceled", e.getMessage());
        }
    }

    @Test
    public void putAsyncNoHeaderInRetry() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().putAsyncNoHeaderInRetry(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putNonResource() throws Exception {
        Sku sku = new Sku();
        Sku response = client.lROs().putNonResource(sku);
        Assert.assertEquals("100", response.id());
    }

    @Test
    public void putAsyncNonResource() throws Exception {
        Sku sku = new Sku();
        Sku response = client.lROs().putAsyncNonResource(sku);
        Assert.assertEquals("100", response.id());
    }

    @Test
    public void putSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        SubProduct response = client.lROs().putSubResource(subProduct);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putAsyncSubResource() throws Exception {
        SubProduct subProduct = new SubProduct();
        SubProduct response = client.lROs().putAsyncSubResource(subProduct);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        Product response = client.lROs().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void deleteProvisioning202DeletingFailed200() throws Exception {
        Product response = client.lROs().deleteProvisioning202DeletingFailed200();
        Assert.assertEquals("Failed", response.provisioningState());
    }

    @Test
    public void deleteProvisioning202Deletingcanceled200() throws Exception {
        Product response = client.lROs().deleteProvisioning202Deletingcanceled200();
        Assert.assertEquals("Canceled", response.provisioningState());
    }

    @Test
    public void delete204Succeeded() throws Exception {
        client.lROs().delete204Succeeded();
    }

    @Test
    public void delete202Retry200() throws Exception {
        Product response = client.lROs().delete202Retry200();
    }

    @Test
    public void delete202NoRetry204() throws Exception {
        Product response = client.lROs().delete202NoRetry204();
    }

    @Test
    public void deleteNoHeaderInRetry() throws Exception {
        client.lROs().deleteNoHeaderInRetry();
    }

    @Test
    public void deleteAsyncNoHeaderInRetry() throws Exception {
        client.lROs().deleteAsyncNoHeaderInRetry();
    }

    @Test
    public void deleteAsyncRetrySucceeded() throws Exception {
        client.lROs().deleteAsyncRetrySucceeded();
    }

    @Test
    public void deleteAsyncNoRetrySucceeded() throws Exception {
        client.lROs().deleteAsyncNoRetrySucceeded();
    }

    @Test
    public void deleteAsyncRetryFailed() throws Exception {
        try {
            client.lROs().deleteAsyncRetryFailed();
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Failed", e.getMessage());
        }
    }

    @Test
    public void deleteAsyncRetrycanceled() throws Exception {
        try {
            client.lROs().deleteAsyncRetrycanceled();
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Canceled", e.getMessage());
        }
    }

    @Test
    public void post200WithPayload() throws Exception {
        Sku response = client.lROs().post200WithPayload();
        Assert.assertEquals("1", response.id());
    }

    @Test
    public void post202Retry200() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        client.lROs().post202Retry200(product);
    }

    @Test
    public void post202NoRetry204() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().post202NoRetry204(product);
    }

    @Test
    public void postAsyncRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().postAsyncRetrySucceeded(product);
    }

    @Test
    public void postAsyncNoRetrySucceeded() throws Exception {
        Product product = new Product();
        product.withLocation("West US");
        Product response = client.lROs().postAsyncNoRetrySucceeded(product);
    }

    @Test
    public void postAsyncRetryFailed() throws Exception {
        try {
            Product product = new Product();
            product.withLocation("West US");
            client.lROs().postAsyncRetryFailed(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Failed", e.getMessage());
        }
    }

    @Test
    public void postAsyncRetrycanceled() throws Exception {
        try {
            Product product = new Product();
            product.withLocation("West US");
            client.lROs().postAsyncRetrycanceled(product);
            fail();
        } catch (CloudException e) {
            Assert.assertEquals("Async operation failed with provisioning state: Canceled", e.getMessage());
        }
    }
}
