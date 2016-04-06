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
import fixtures.paging.models.PagingGetMultiplePagesWithOffsetOptionsImpl;
import fixtures.paging.models.ProductImpl;
import fixtures.paging.models.ProductPropertiesImpl;
import okhttp3.logging.HttpLoggingInterceptor;

import static org.junit.Assert.fail;

public class PagingTests {
    private static AutoRestPagingTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestPagingTestServiceImpl("http://localhost.:3000", null);
        client.setLogLevel(HttpLoggingInterceptor.Level.BASIC);
    }

    @Test
    public void getSinglePages() throws Exception {
        List<ProductImpl> response = client.pagings().getSinglePages().getBody();
        Assert.assertEquals(1, response.size());
    }

    @Test
    public void getMultiplePages() throws Exception {
        List<ProductImpl> response = client.pagings().getMultiplePages().getBody();
        ProductImpl p1 = new ProductImpl();
        p1.setProperties(new ProductPropertiesImpl());
        response.add(p1);
        response.get(3);
        ProductImpl p4 = new ProductImpl();
        p4.setProperties(new ProductPropertiesImpl());
        response.add(p4);
        int i = 0;
        for (ProductImpl p : response) {
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
        PagingGetMultiplePagesWithOffsetOptionsImpl options = new PagingGetMultiplePagesWithOffsetOptionsImpl();
        options.setOffset(100);
        List<ProductImpl> response = client.pagings().getMultiplePagesWithOffset(options, "client-id").getBody();
        Assert.assertEquals(10, response.size());
        Assert.assertEquals(110, (int) response.get(response.size() - 1).properties().id());
    }

    @Test
    public void getMultiplePagesAsync() throws Exception {
        final CountDownLatch lock = new CountDownLatch(1);
        client.pagings().getMultiplePagesAsync("client-id", null, new ListOperationCallback<ProductImpl>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<List<ProductImpl>> result) {
                lock.countDown();
            }

            @Override
            public PagingBahavior progress(List<ProductImpl> partial) {
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
        List<ProductImpl> response = client.pagings().getMultiplePagesRetryFirst().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getMultiplePagesRetrySecond() throws Exception {
        List<ProductImpl> response = client.pagings().getMultiplePagesRetrySecond().getBody();
        Assert.assertEquals(10, response.size());
    }

    @Test
    public void getSinglePagesFailure() throws Exception {
        try {
            List<ProductImpl> response = client.pagings().getSinglePagesFailure().getBody();
            fail();
        } catch (CloudException ex) {
            Assert.assertNotNull(ex.getResponse());
        }
    }

    @Test
    public void getMultiplePagesFailure() throws Exception {
        try {
            List<ProductImpl> response = client.pagings().getMultiplePagesFailure().getBody();
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }

    @Test
    public void getMultiplePagesFailureUri() throws Exception {
        try {
            List<ProductImpl> response = client.pagings().getMultiplePagesFailureUri().getBody();
            response.size();
            fail();
        } catch (WebServiceException ex) {
            Assert.assertNotNull(ex.getCause());
        }
    }
}
