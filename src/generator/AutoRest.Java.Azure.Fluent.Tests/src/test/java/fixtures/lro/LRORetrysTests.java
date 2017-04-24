package fixtures.lro;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.implementation.ProductInner;


public class LRORetrysTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        ProductInner response = client.lRORetrys().put201CreatingSucceeded200(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void putAsyncRelativeRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        ProductInner response = client.lRORetrys().putAsyncRelativeRetrySucceeded(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        ProductInner response = client.lRORetrys().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Test
    public void delete202Retry200() throws Exception {
        client.lRORetrys().delete202Retry200();
    }

    @Test
    public void deleteAsyncRelativeRetrySucceeded() throws Exception {
        client.lRORetrys().deleteAsyncRelativeRetrySucceeded();
    }

    @Test
    public void post202Retry200() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        client.lRORetrys().post202Retry200(product);
    }

    @Test
    public void postAsyncRelativeRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        client.lRORetrys().postAsyncRelativeRetrySucceeded(product);
    }
}
