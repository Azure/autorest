package fixtures.lro;

import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.models.ProductImpl;

public class LRORetrysTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", null);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put201CreatingSucceeded200() throws Exception {
        ProductImpl product = new ProductImpl();
        product.setLocation("West US");
        ServiceResponse<ProductImpl> response = client.lRORetrys().put201CreatingSucceeded200(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void putAsyncRelativeRetrySucceeded() throws Exception {
        ProductImpl product = new ProductImpl();
        product.setLocation("West US");
        ServiceResponse<ProductImpl> response = client.lRORetrys().putAsyncRelativeRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void deleteProvisioning202Accepted200Succeeded() throws Exception {
        ServiceResponse<ProductImpl> response = client.lRORetrys().deleteProvisioning202Accepted200Succeeded();
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().provisioningState());
    }

    @Test
    public void delete202Retry200() throws Exception {
        ServiceResponse<Void> response = client.lRORetrys().delete202Retry200();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRelativeRetrySucceeded() throws Exception {
        ServiceResponse<Void> response = client.lRORetrys().deleteAsyncRelativeRetrySucceeded();
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void post202Retry200() throws Exception {
        ProductImpl product = new ProductImpl();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.lRORetrys().post202Retry200(product);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void postAsyncRelativeRetrySucceeded() throws Exception {
        ProductImpl product = new ProductImpl();
        product.setLocation("West US");
        ServiceResponse<Void> response = client.lRORetrys().postAsyncRelativeRetrySucceeded(product);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
