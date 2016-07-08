package fixtures.lro;

import com.fasterxml.jackson.core.JsonParseException;
import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.MalformedURLException;

import fixtures.lro.implementation.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.lro.implementation.ProductInner;

import static org.junit.Assert.fail;

public class LROSADsTests {
    private static AutoRestLongRunningOperationTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", null);
        client.getAzureClient().withLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void putNonRetry400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putNonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putNonRetry201Creating400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putNonRetry201Creating400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putAsyncRelativeRetry400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putAsyncRelativeRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteNonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().deleteNonRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void delete202NonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().delete202NonRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteAsyncRelativeRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().deleteAsyncRelativeRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postNonRetry400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().postNonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void post202NonRetry400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().post202NonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postAsyncRelativeRetry400() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().postAsyncRelativeRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putError201NoProvisioningStatePayload() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putError201NoProvisioningStatePayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatus() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putAsyncRelativeRetryNoStatus(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatusPayload() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putAsyncRelativeRetryNoStatusPayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void delete204Succeeded() throws Exception {
        ServiceResponse<Void> response = client.lROSADs().delete204Succeeded();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRelativeRetryNoStatus() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().deleteAsyncRelativeRetryNoStatus();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void post202NoLocation() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().post202NoLocation(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(202, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("No header in response"));
        }
    }

    @Test
    public void postAsyncRelativeRetryNoPayload() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().postAsyncRelativeRetryNoPayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void put200InvalidJson() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().put200InvalidJson(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void putAsyncRelativeRetryInvalidHeader() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putAsyncRelativeRetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void putAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<ProductInner> response = client.lROSADs().putAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void delete202RetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().delete202RetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().deleteAsyncRelativeRetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        try {
            ServiceResponse<Void> response = client.lROSADs().deleteAsyncRelativeRetryInvalidJsonPolling();
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void post202RetryInvalidHeader() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().post202RetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void postAsyncRelativeRetryInvalidHeader() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().postAsyncRelativeRetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void postAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        ProductInner product = new ProductInner();
        product.withLocation("West US");
        try {
            ServiceResponse<Void> response = client.lROSADs().postAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }
}
