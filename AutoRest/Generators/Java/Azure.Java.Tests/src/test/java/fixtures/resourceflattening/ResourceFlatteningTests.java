package fixtures.resourceflattening;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.AzureJacksonHelper;
import com.squareup.okhttp.OkHttpClient;
import fixtures.lro.AutoRestLongRunningOperationTestServiceImpl;
import fixtures.resourceflattening.models.FlattenedProduct;
import fixtures.resourceflattening.models.Resource;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import retrofit.JacksonConverterFactory;
import retrofit.Retrofit;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class ResourceFlatteningTests {
    static AutoRestResourceFlatteningTestService client;

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

        client = new AutoRestResourceFlatteningTestServiceImpl("http://localhost.:3000", httpClient, builder);
        client.setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void getArray() throws Exception {
        List<FlattenedProduct> result = client.getArray().getBody();
        Assert.assertEquals(3, result.size());
        // Resource 1
        Assert.assertEquals("1", result.get(0).getId());
        Assert.assertEquals("OK", result.get(0).getProvisioningStateValues());
        Assert.assertEquals("Product1", result.get(0).getPname());
        Assert.assertEquals("Flat", result.get(0).getFlattenedProductType());
        Assert.assertEquals("Building 44", result.get(0).getLocation());
        Assert.assertEquals("Resource1", result.get(0).getName());
        Assert.assertEquals("Succeeded", result.get(0).getProvisioningState());
        Assert.assertEquals("Microsoft.Web/sites", result.get(0).getType());
        Assert.assertEquals("value1", result.get(0).getTags().get("tag1"));
        Assert.assertEquals("value3", result.get(0).getTags().get("tag2"));
        // Resource 2
        Assert.assertEquals("2", result.get(1).getId());
        Assert.assertEquals("Resource2", result.get(1).getName());
        Assert.assertEquals("Building 44", result.get(1).getLocation());
        // Resource 3
        Assert.assertEquals("3", result.get(2).getId());
        Assert.assertEquals("Resource3", result.get(2).getName());
    }

    @Test
    public void putArray() throws Exception {
        List<Resource> body = new ArrayList<>();
        FlattenedProduct product = new FlattenedProduct();
        product.setLocation("West US");
        product.setTags(new HashMap<>());
        product.getTags().put("tag1", "value1");
        product.getTags().put("tag2", "value3");
        body.add(product);
        FlattenedProduct product1 = new FlattenedProduct();
        product1.setLocation("Building 44");
        body.add(product1);
        ServiceResponse<Void> response = client.putArray(body);
        Assert.assertEquals(200, response.getResponse().code());
    }

    @Test
    public void getDictionary() throws Exception {
        Map<String, FlattenedProduct> result = client.getDictionary().getBody();
        Assert.assertEquals(3, result.size());
        // Resource 1
        Assert.assertEquals("1", result.get("Product1").getId());
        Assert.assertEquals("OK", result.get("Product1").getProvisioningStateValues());
        Assert.assertEquals("Product1", result.get("Product1").getPname());
        Assert.assertEquals("Flat", result.get("Product1").getFlattenedProductType());
        Assert.assertEquals("Building 44", result.get("Product1").getLocation());
        Assert.assertEquals("Resource1", result.get("Product1").getName());
        Assert.assertEquals("Succeeded", result.get("Product1").getProvisioningState());
        Assert.assertEquals("Microsoft.Web/sites", result.get("Product1").getType());
        Assert.assertEquals("value1", result.get("Product1").getTags().get("tag1"));
        Assert.assertEquals("value3", result.get("Product1").getTags().get("tag2"));
        // Resource 2
        Assert.assertEquals("2", result.get("Product2").getId());
        Assert.assertEquals("Resource2", result.get("Product2").getName());
        Assert.assertEquals("Building 44", result.get("Product2").getLocation());
        // Resource 3
        Assert.assertEquals("3", result.get("Product3").getId());
        Assert.assertEquals("Resource3", result.get("Product3").getName());
    }

    @Test
    public void putDictionary() throws Exception {
        Map<String, FlattenedProduct> body = new HashMap<>();
        FlattenedProduct product = new FlattenedProduct();
        product.setLocation("West US");
        product.setTags(new HashMap<>());
        product.getTags().put("tag1", "value1");
        product.getTags().put("tag2", "value3");
        product.setPname("Product1");
        product.setFlattenedProductType("Flat");
        body.put("Resource1", product);
        FlattenedProduct product1 = new FlattenedProduct();
        product1.setLocation("Building 44");
        product1.setPname("Product2");
        product1.setFlattenedProductType("Flat");
        body.put("Resource2", product1);
        ServiceResponse<Void> response = client.putDictionary(body);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
