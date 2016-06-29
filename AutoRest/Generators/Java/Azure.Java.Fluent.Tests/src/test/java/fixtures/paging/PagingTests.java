package fixtures.paging;

import com.microsoft.azure.CloudException;
import com.microsoft.azure.ListOperationCallback;
import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import javax.xml.ws.WebServiceException;

import fixtures.paging.implementation.AutoRestPagingTestServiceImpl;
import fixtures.paging.implementation.PagingGetMultiplePagesWithOffsetOptionsInner;
import fixtures.paging.implementation.ProductInner;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void getSinglePages() throws Exception {
        List<ProductInner> response = client.pagings().getSinglePages().getBody();
        Assert.assertEquals(1, response.size());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<ProductInner> response = client.pagings().getMultiplePages().getBody();
        ProductInner p1 = new ProductInner();
        p1.withProperties(new ProductProperties());
        response.add(p1);
        response.get(3);
        ProductInner p4 = new ProductInner();
        p4.withProperties(new ProductProperties());
        response.add(p4);
        int i = 0;
        for (ProductInner p : response) {
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
        PagingGetMultiplePagesWithOffsetOptionsInner options = new PagingGetMultiplePagesWithOffsetOptionsInner();
        options.withOffset(100);
        List<ProductInner> response = client.pagings().getMultiplePagesWithOffset(options, "client-id").getBody();
        Assert.assertEquals(10, response.size());
        Assert.assertEquals(110, (int) response.get(response.size() - 1).properties().id());
    }

    @Test
    public void getMultiplePagesAsync() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        client.pagings().getMultiplePagesAsync("client-id", null, new ListOperationCallback<ProductInner>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<List<ProductInner>> result) {
                lock.countDown();
            }

            @Override
            public PagingBahavior progress(List<ProductInner> partial) {
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
        List<ProductInner> response = client.pagings().getMultiplePagesRetryFirst().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        List<ProductInner> response = client.pagings().getMultiplePagesRetrySecond().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            List<ProductInner> response = client.pagings().getSinglePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            List<ProductInner> response = client.pagings().getMultiplePagesFailure().getBody();
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            List<ProductInner> response = client.pagings().getMultiplePagesFailureUri().getBody();
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }
}
