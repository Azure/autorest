package fixtures.lro;

import com.fasterxml.jackson.core.JsonParseException;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonUtils;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.MalformedURLException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import static org.junit.Assert.fail;

public class LROSADsTests {
    static AutoRestLongRunningOperationTestService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient httpClient = new OkHttpClient();
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        httpClient.setCookieHandler(cookieManager);
        Executor executor = Executors.newCachedThreadPool();
        Retrofit.Builder builder = new Retrofit.Builder()
                .addConverterFactory(JacksonConverterFactory.create(new AzureJacksonUtils().getObjectMapper()))
                .callbackExecutor(executor);

        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000", null, httpClient, builder);
        client.getAzureClient().setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void putNonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putNonRetry400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putNonRetry201Creating400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putNonRetry201Creating400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putAsyncRelativeRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putAsyncRelativeRetry400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteNonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().deleteNonRetry400();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void delete202NonRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().delete202NonRetry400();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void deleteAsyncRelativeRetry400() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().deleteAsyncRelativeRetry400();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postNonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADs().postNonRetry400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void post202NonRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADs().post202NonRetry400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void postAsyncRelativeRetry400() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADs().postAsyncRelativeRetry400(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }

    @Test
    public void putError201NoProvisioningStatePayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putError201NoProvisioningStatePayload(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatus() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putAsyncRelativeRetryNoStatus(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void putAsyncRelativeRetryNoStatusPayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().putAsyncRelativeRetryNoStatusPayload(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void delete204Succeeded() throws Exception {
        ServiceResponse<Void> response = client.getLROSADs().delete204Succeeded();
        Assert.assertEquals(204, response.getResponse().code());
    }

    @Test
    public void deleteAsyncRelativeRetryNoStatus() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().deleteAsyncRelativeRetryNoStatus();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void post202NoLocation() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADs().post202NoLocation(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(202, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("No header in response"));
        }
    }

    @Test
    public void postAsyncRelativeRetryNoPayload() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Void> response = client.getLROSADs().postAsyncRelativeRetryNoPayload(product);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().code());
            Assert.assertTrue(ex.getMessage().contains("no body"));
        }
    }

    @Test
    public void put200InvalidJson() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        try {
            ServiceResponse<Product> response = client.getLROSADs().put200InvalidJson(product);
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
            ServiceResponse<Product> response = client.getLROSADs().putAsyncRelativeRetryInvalidHeader(product);
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
            ServiceResponse<Product> response = client.getLROSADs().putAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void delete202RetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().delete202RetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidHeader() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().deleteAsyncRelativeRetryInvalidHeader();
            fail();
        } catch (MalformedURLException ex) {
            Assert.assertTrue(ex.getMessage().contains("no protocol: /foo"));
        }
    }

    @Test
    public void deleteAsyncRelativeRetryInvalidJsonPolling() throws Exception {
        try {
            ServiceResponse<Void> response = client.getLROSADs().deleteAsyncRelativeRetryInvalidJsonPolling();
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
            ServiceResponse<Void> response = client.getLROSADs().post202RetryInvalidHeader(product);
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
            ServiceResponse<Void> response = client.getLROSADs().postAsyncRelativeRetryInvalidHeader(product);
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
            ServiceResponse<Void> response = client.getLROSADs().postAsyncRelativeRetryInvalidJsonPolling(product);
            fail();
        } catch (JsonParseException ex) {
            Assert.assertTrue(ex.getMessage().contains("Unexpected end-of-input"));
        }
    }
}
