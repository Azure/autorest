package fixtures.http;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class HttpRetryTests {
    static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void head408() throws Exception {
        client.getHttpRetry().head408Async(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put500() throws Exception {
        client.getHttpRetry().put500Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch500() throws Exception {
        client.getHttpRetry().patch500Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get502() throws Exception {
        client.getHttpRetry().get502Async(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post503() throws Exception {
        client.getHttpRetry().post503Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete503() throws Exception {
        client.getHttpRetry().delete503Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put504() throws Exception {
        client.getHttpRetry().put504Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch504() throws Exception {
        client.getHttpRetry().patch504Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }
}
