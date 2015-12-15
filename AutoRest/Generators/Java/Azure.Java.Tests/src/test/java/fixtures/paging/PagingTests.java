package fixtures.paging;

import com.microsoft.rest.CloudError;
import com.microsoft.rest.CloudException;
import com.microsoft.rest.Page;
import com.microsoft.rest.ServiceException;
import fixtures.paging.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getSinglePages() throws Exception {
        Page<Product> response = client.getPaging().getSinglePages().getBody();
        Assert.assertNull(response.getNextPageLink());
    }

    @Test
    public void getMultiplePages() throws Exception {
        Page<Product> response = client.getPaging().getMultiplePages("client-id").getBody();
        Assert.assertNotNull(response.getNextPageLink());
        int count = 1;
        while (response.getNextPageLink() != null) {
            response = client.getPaging().getMultiplePagesNext(response.getNextPageLink(), "client-id").getBody();
            count++;
        }
        Assert.assertEquals(10, count);
    }

    @Test
    public void getMultiplePagesRetryFirst() throws Exception {
        Page<Product> response = client.getPaging().getMultiplePagesRetryFirst().getBody();
        Assert.assertNotNull(response.getNextPageLink());
        int count = 1;
        while (response.getNextPageLink() != null) {
            response = client.getPaging().getMultiplePagesNext(response.getNextPageLink(), "client-id").getBody();
            count++;
        }
        Assert.assertEquals(10, count);
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        Page<Product> response = client.getPaging().getMultiplePagesRetrySecond().getBody();
        Assert.assertNotNull(response.getNextPageLink());
        int count = 1;
        while (response.getNextPageLink() != null) {
            response = client.getPaging().getMultiplePagesNext(response.getNextPageLink(), "client-id").getBody();
            count++;
        }
        Assert.assertEquals(10, count);
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            Page<Product> response = client.getPaging().getSinglePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            Page<Product> response = client.getPaging().getMultiplePagesFailure().getBody();
            Assert.assertNotNull(response.getNextPageLink());
            response = client.getPaging().getMultiplePagesNext(response.getNextPageLink(), "client-id").getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            Page<Product> response = client.getPaging().getMultiplePagesFailureUri().getBody();
            Assert.assertNotNull(response.getNextPageLink());
            response = client.getPaging().getMultiplePagesFailureUriNext(response.getNextPageLink()).getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }
}
