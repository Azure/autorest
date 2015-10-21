package fixtures.lro;

import com.microsoft.rest.ServiceResponse;
import fixtures.lro.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class LROsTests {
    static AutoRestLongRunningOperationTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestLongRunningOperationTestServiceImpl("http://localhost.:3000");
        client.setLongRunningOperationRetryTimeout(0);
    }

    @Test
    public void put200Succeeded() throws Exception {
        Product product = new Product();
        product.setLocation("West US");
        ServiceResponse<Product> response = client.getLROs().put200Succeeded(product);
        Assert.assertEquals(200, response.getResponse().code());
        Assert.assertEquals("Succeeded", response.getBody().getProvisioningState());
    }

}
