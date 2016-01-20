package fixtures.resourceflattening;

import com.microsoft.rest.ServiceResponse;
import com.microsoft.azure.serializer.AzureJacksonMapperAdapter;
import com.squareup.okhttp.OkHttpClient;
import fixtures.resourceflattening.models.FlattenedProduct;
import fixtures.resourceflattening.models.Resource;
import fixtures.resourceflattening.models.ResourceCollection;
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
    private static AutoRestResourceFlatteningTestService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient httpClient = new OkHttpClient();
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        httpClient.setCookieHandler(cookieManager);
        Executor executor = Executors.newCachedThreadPool();
        Retrofit.Builder builder = new Retrofit.Builder()
                .addConverterFactory(JacksonConverterFactory.create(new AzureJacksonMapperAdapter().getObjectMapper()))
                .callbackExecutor(executor);

        client = new AutoRestResourceFlatteningTestServiceImpl("http://localhost.:3000", null, httpClient, builder);
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
        product.setTags(new HashMap<String, String>());
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
        product.setTags(new HashMap<String, String>());
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

    @Test
    public void getResourceCollection() throws Exception {
        ResourceCollection resultResource = client.getResourceCollection().getBody();
        //Dictionaryofresources
        Assert.assertEquals(3, resultResource.getDictionaryofresources().size());
        // Resource 1
        Assert.assertEquals("1", resultResource.getDictionaryofresources().get("Product1").getId());
        Assert.assertEquals("OK", resultResource.getDictionaryofresources().get("Product1").getProvisioningStateValues());
        Assert.assertEquals("Product1", resultResource.getDictionaryofresources().get("Product1").getPname());
        Assert.assertEquals("Flat", resultResource.getDictionaryofresources().get("Product1").getFlattenedProductType());
        Assert.assertEquals("Building 44", resultResource.getDictionaryofresources().get("Product1").getLocation());
        Assert.assertEquals("Resource1", resultResource.getDictionaryofresources().get("Product1").getName());
        Assert.assertEquals("Succeeded", resultResource.getDictionaryofresources().get("Product1").getProvisioningState());
        Assert.assertEquals("Microsoft.Web/sites", resultResource.getDictionaryofresources().get("Product1").getType());
        Assert.assertEquals("value1", resultResource.getDictionaryofresources().get("Product1").getTags().get("tag1"));
        Assert.assertEquals("value3", resultResource.getDictionaryofresources().get("Product1").getTags().get("tag2"));
        // Resource 2
        Assert.assertEquals("2", resultResource.getDictionaryofresources().get("Product2").getId());
        Assert.assertEquals("Resource2", resultResource.getDictionaryofresources().get("Product2").getName());
        Assert.assertEquals("Building 44", resultResource.getDictionaryofresources().get("Product2").getLocation());
        // Resource 3
        Assert.assertEquals("3", resultResource.getDictionaryofresources().get("Product3").getId());
        Assert.assertEquals("Resource3", resultResource.getDictionaryofresources().get("Product3").getName());

        //Arrayofresources
        Assert.assertEquals(3, resultResource.getArrayofresources().size());
        // Resource 1
        Assert.assertEquals("4", resultResource.getArrayofresources().get(0).getId());
        Assert.assertEquals("OK", resultResource.getArrayofresources().get(0).getProvisioningStateValues());
        Assert.assertEquals("Product4", resultResource.getArrayofresources().get(0).getPname());
        Assert.assertEquals("Flat", resultResource.getArrayofresources().get(0).getFlattenedProductType());
        Assert.assertEquals("Building 44", resultResource.getArrayofresources().get(0).getLocation());
        Assert.assertEquals("Resource4", resultResource.getArrayofresources().get(0).getName());
        Assert.assertEquals("Succeeded", resultResource.getArrayofresources().get(0).getProvisioningState());
        Assert.assertEquals("Microsoft.Web/sites", resultResource.getArrayofresources().get(0).getType());
        Assert.assertEquals("value1", resultResource.getArrayofresources().get(0).getTags().get("tag1"));
        Assert.assertEquals("value3", resultResource.getArrayofresources().get(0).getTags().get("tag2"));
        // Resource 2
        Assert.assertEquals("5", resultResource.getArrayofresources().get(1).getId());
        Assert.assertEquals("Resource5", resultResource.getArrayofresources().get(1).getName());
        Assert.assertEquals("Building 44", resultResource.getArrayofresources().get(1).getLocation());
        // Resource 3
        Assert.assertEquals("6", resultResource.getArrayofresources().get(2).getId());
        Assert.assertEquals("Resource6", resultResource.getArrayofresources().get(2).getName());

        //productresource
        Assert.assertEquals("7", resultResource.getProductresource().getId());
        Assert.assertEquals("Resource7", resultResource.getProductresource().getName());
    }

    @Test
    public void putResourceCollection() throws Exception {
        Map<String, FlattenedProduct> resources = new HashMap<>();
        resources.put("Resource1", new FlattenedProduct());
        resources.get("Resource1").setLocation("West US");
        resources.get("Resource1").setPname("Product1");
        resources.get("Resource1").setFlattenedProductType("Flat");
        resources.get("Resource1").setTags(new HashMap<String, String>());
        resources.get("Resource1").getTags().put("tag1", "value1");
        resources.get("Resource1").getTags().put("tag2", "value3");

        resources.put("Resource2", new FlattenedProduct());
        resources.get("Resource2").setLocation("Building 44");
        resources.get("Resource2").setPname("Product2");
        resources.get("Resource2").setFlattenedProductType("Flat");

        ResourceCollection complexObj = new ResourceCollection();
        complexObj.setDictionaryofresources(resources);
        complexObj.setArrayofresources(new ArrayList<FlattenedProduct>());
        complexObj.getArrayofresources().add(resources.get("Resource1"));
        FlattenedProduct p1 = new FlattenedProduct();
        p1.setLocation("East US");
        p1.setPname("Product2");
        p1.setFlattenedProductType("Flat");
        complexObj.getArrayofresources().add(p1);
        FlattenedProduct pr = new FlattenedProduct();
        pr.setLocation("India");
        pr.setPname("Azure");
        pr.setFlattenedProductType("Flat");
        complexObj.setProductresource(pr);

        ServiceResponse<Void> response = client.putResourceCollection(complexObj);
        Assert.assertEquals(200, response.getResponse().code());
    }
}
