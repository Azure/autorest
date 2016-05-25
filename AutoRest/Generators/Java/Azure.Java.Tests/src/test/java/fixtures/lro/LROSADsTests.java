package fixtures.lro;

import com.fasterxml.jackson.core.JsonParseException;
import com.microsoft.azure.CloudException;
import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.MalformedURLException;

import fixtures.lro.models.Product;

import static org.junit.Assert.fail;

public class LROSADsTests {
    private static AutoRestLongRunningOperationTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost:3000", null);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void putNonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putNonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putNonRetry201Creating400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putNonRetry201Creating400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putAsyncRelativeRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putAsyncRelativeRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteNonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().deleteNonRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void delete202NonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().delete202NonRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteAsyncRelativeRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().deleteAsyncRelativeRetry400();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postNonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().postNonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void post202NonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().post202NonRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postAsyncRelativeRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().postAsyncRelativeRetry400(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putError201NoProvisioningStatePayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putError201NoProvisioningStatePayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatus() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putAsyncRelativeRetryNoStatus(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatusPayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putAsyncRelativeRetryNoStatusPayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void delete204Succeeded() throws Exception {
        ServiceResponse<Void> response = client.getLROSADsOperations().delete204Succeeded();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRelativeRetryNoStatus() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().deleteAsyncRelativeRetryNoStatus();
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void post202NoLocation() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().post202NoLocation(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(202, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("No header in response"));
        }
    }

    @Test
    public void postAsyncRelativeRetryNoPayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().postAsyncRelativeRetryNoPayload(product);
            fail();
        } catch (CloudException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void put200InvalidJson() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().put200InvalidJson(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void putAsyncRelativeRetryInvalidHeader() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putAsyncRelativeRetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void putAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADsOperations().putAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void delete202RetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().delete202RetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().deleteAsyncRelativeRetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().deleteAsyncRelativeRetryInvalidJsonPolling();
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void post202RetryInvalidHeader() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().post202RetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void postAsyncRelativeRetryInvalidHeader() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().postAsyncRelativeRetryInvalidHeader(product);
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void postAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADsOperations().postAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }
}
