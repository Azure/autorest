package fixtures.paging;

import com.microsoft.azure.CloudException;
import com.microsoft.azure.ListOperationCallback;
import com.microsoft.rest.ServiceResponse;

import fixtures.paging.models.ProductProperties;
import okhttp3.logging.HttpLoggingInterceptor;
import fixtures.paging.models.PagingGetMultiplePagesWithOffsetOptions;
import fixtures.paging.models.Product;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import javax.xml.ws.WebServiceException;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost:3000", null);
        client.setLogLevel(HttpLoggingInterceptor.Level.BASIC);
    }

    @Test
    public void getSinglePages() throws Exception {
        List<Product> response = client.getPagingOperations().getSinglePages().getBody();
        Assert.assertEquals(1, response.size());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<Product> response = client.getPagingOperations().getMultiplePages().getBody();
        Product p1 = new Product();
        p1.setProperties(new ProductProperties());
        response.add(p1);
        response.get(3);
        Product p4 = new Product();
        p4.setProperties(new ProductProperties());
        response.add(p4);
        int i = 0;
        for (Product p : response) {
            if (++i == 7) {
                break;
            }
        }
        System.out.println("Asserting...");
        Assert.assertEquals(12, response.size());
        Assert.assertEquals(1, response.indexOf(p1));
        Assert.assertEquals(4, response.indexOf(p4));
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
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            List<Product> response = client.getPagingOperations().getMultiplePagesFailureUri().getBody();
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }
}
