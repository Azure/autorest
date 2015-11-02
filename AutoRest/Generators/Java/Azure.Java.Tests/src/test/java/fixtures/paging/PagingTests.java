package fixtures.paging;

import com.fasterxml.jackson.core.JsonParseException;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.AutoRestLongRunningOperationTestService;
import fixtures.lro.AutoRestLongRunningOperationTestServiceImpl;
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

public class PagingTests {
    static AutoRestLongRunningOperationTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000");
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
}
