package fixtures.lro;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.implementation.ProductInner;

public class LROsCustomHeaderTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
        client.restClient().headers().addHeader("x-ms-client-request-id", "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0");
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @AfterClass
    public static void cleanup() {
        client.restClient().headers().removeHeader("x-ms-client-request-id");
    }

    @Ignore("Pending headermap")
    public void putAsyncRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        ProductInner response = client.lROsCustomHeaders().putAsyncRetrySucceeded(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Ignore("Pending headermap")
    public void put201CreatingSucceeded200() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        ProductInner response = client.lROsCustomHeaders().put201CreatingSucceeded200(product);
        Assert.assertEquals("Succeeded", response.provisioningState());
    }

    @Ignore("Pending headermap")
    public void post202Retry200() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        client.lROsCustomHeaders().post202Retry200(product);
    }

    @Ignore("Pending headermap")
    public void postAsyncRetrySucceeded() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        client.lROsCustomHeaders().postAsyncRetrySucceeded(product);
    }
}
