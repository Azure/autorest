package fixtures.paging;

import com.microsoft.azure.CloudException;
import com.microsoft.azure.ListOperationCallback;
import com.microsoft.rest.ServiceResponse;
import okhttp3.logging.HttpLoggingInterceptor;
import fixtures.paging.models.PagingGetMultiplePagesWithOffsetOptions;
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
        client = new AutoRestPagingTestServiceImpl("http://localhost.:3000", null);
        client.setLogLevel(HttpLoggingInterceptor.Level.BODY);
    }

    @Test
    public void getSinglePages() throws Exception {
        List<Product> response = client.getPagingOperations().getSinglePages().getBody();
        Assert.assertEquals(1, response.size());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<Product> response = client.getPagingOperations().getMultiplePages("client-id", null).getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesWithOffset() throws Exception {
        PagingGetMultiplePagesWithOffsetOptions options = new PagingGetMultiplePagesWithOffsetOptions();
        options.setOffset(100);
        List<Product> response = client.getPagingOperations().getMultiplePagesWithOffset(options, "client-id").getBody();
        Assert.assertEquals(10, response.size());
        Assert.assertEquals(110, (int) response.get(response.size() - 1).getProperties().getId());
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
                lock.countDown();
            }

            @Override
            public PagingBahavior progress(List<Product> partial) {
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
        List<Product> response = client.getPagingOperations().getMultiplePagesRetryFirst().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        List<Product> response = client.getPagingOperations().getMultiplePagesRetrySecond().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            List<Product> response = client.getPagingOperations().getSinglePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            List<Product> response = client.getPagingOperations().getMultiplePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            List<Product> response = client.getPagingOperations().getMultiplePagesFailureUri().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }
}
