package fixtures.paging;

import com.microsoft.azure.CloudException;
import com.microsoft.azure.Page;
import com.microsoft.azure.ListOperationCallback;
import com.microsoft.rest.ServiceResponse;

import fixtures.paging.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getSinglePages() throws Exception {
        Page<Product> response = client.getPagingOperations().getSinglePages().getBody();
        Assert.assertNull(response.getNextPageLink());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<Product> response = client.getPagingOperations().getMultiplePages("client-id", null).getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesAsync() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        client.getPagingOperations().getMultiplePagesAsync("client-id", null, new ListOperationCallback<Product>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<List<Product>> result) {
                System.out.println(result.getBody().size());
                lock.countDown();
            }

            @Override
            public PagingBahavior progress(List<Product> partial) {
                System.out.println(partial.get(0).getProperties().getId());
                if (pageCount() == 7) {
                    return PagingBahavior.STOP;
                } else {
                    return PagingBahavior.CONTINUE;
                }
            }
        });
        Assert.assertTrue(lock.await(10000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void getMultiplePagesRetryFirst() throws Exception {
        Page<Product> response = client.getPagingOperations().getMultiplePagesRetryFirst().getBody();
        Assert.assertNotNull(response.getNextPageLink());
        int count = 1;
        while (response.getNextPageLink() != null) {
            response = client.getPagingOperations().getMultiplePagesRetryFirstNext(response.getNextPageLink()).getBody();
            count++;
        }
        Assert.assertEquals(10, count);
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        Page<Product> response = client.getPagingOperations().getMultiplePagesRetrySecond().getBody();
        Assert.assertNotNull(response.getNextPageLink());
        int count = 1;
        while (response.getNextPageLink() != null) {
            response = client.getPagingOperations().getMultiplePagesRetrySecondNext(response.getNextPageLink()).getBody();
            count++;
        }
        Assert.assertEquals(10, count);
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            Page<Product> response = client.getPagingOperations().getSinglePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            Page<Product> response = client.getPagingOperations().getMultiplePagesFailure().getBody();
            Assert.assertNotNull(response.getNextPageLink());
            response = client.getPagingOperations().getMultiplePagesFailureNext(response.getNextPageLink()).getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            Page<Product> response = client.getPagingOperations().getMultiplePagesFailureUri().getBody();
            Assert.assertNotNull(response.getNextPageLink());
            response = client.getPagingOperations().getMultiplePagesFailureUriNext(response.getNextPageLink()).getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }
}
