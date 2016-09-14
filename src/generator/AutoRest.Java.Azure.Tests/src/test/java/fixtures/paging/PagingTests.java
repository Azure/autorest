package fixtures.paging;

import com.microsoft.azure.CloudException;
import com.microsoft.azure.ListOperationCallback;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import fixtures.paging.implementation.AutoRestPagingTestServiceImpl;
import fixtures.paging.models.PagingGetMultiplePagesWithOffsetOptions;
import fixtures.paging.models.Product;
import fixtures.paging.models.ProductProperties;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void getSinglePages() throws Exception {
        List<Product> response = client.pagings().getSinglePages();
        Assert.assertEquals(1, response.size());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<Product> response = client.pagings().getMultiplePages();
        Product p1 = new Product();
        p1.withProperties(new ProductProperties());
        response.add(p1);
        response.get(3);
        Product p4 = new Product();
        p4.withProperties(new ProductProperties());
        response.add(p4);
        int i = 0;
        for (Product p : response) {
            if (++i == 7) {
                break;
            }
        }
        Assert.assertEquals(12, response.size());
        Assert.assertEquals(1, response.indexOf(p1));
        Assert.assertEquals(4, response.indexOf(p4));
    }

    @Test
    public void getOdataMultiplePages() throws Exception {
        List<Product> response = client.pagings().getOdataMultiplePages();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesWithOffset() throws Exception {
        PagingGetMultiplePagesWithOffsetOptions options = new PagingGetMultiplePagesWithOffsetOptions();
        options.withOffset(100);
        List<Product> response = client.pagings().getMultiplePagesWithOffset(options, "client-id");
        Assert.assertEquals(10, response.size());
        Assert.assertEquals(110, (int) response.get(response.size() - 1).properties().id());
    }

    @Test
    public void getMultiplePagesAsync() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        client.pagings().getMultiplePagesAsync("client-id", null, new ListOperationCallback<Product>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success() {
                lock.countDown();
            }

            @Override
            public PagingBehavior progress(List<Product> partial) {
                if (pageCount() == 7) {
                    return PagingBehavior.STOP;
                } else {
                    return PagingBehavior.CONTINUE;
                }
            }
        });
        Assert.assertTrue(lock.await(10000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void getMultiplePagesRetryFirst() throws Exception {
        List<Product> response = client.pagings().getMultiplePagesRetryFirst();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        List<Product> response = client.pagings().getMultiplePagesRetrySecond();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            List<Product> response = client.pagings().getSinglePagesFailure();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            List<Product> response = client.pagings().getMultiplePagesFailure();
            response.size();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            List<Product> response = client.pagings().getMultiplePagesFailureUri();
            response.size();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }
}
