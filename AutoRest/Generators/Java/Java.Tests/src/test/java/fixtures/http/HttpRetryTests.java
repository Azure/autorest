package fixtures.http;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class HttpRetryTests {
    private static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head408() throws Exception {
        client.getHttpRetryOperations().head408Async(new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getHeadResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put500() throws Exception {
        client.getHttpRetryOperations().put500Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch500() throws Exception {
        client.getHttpRetryOperations().patch500Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get502() throws Exception {
        client.getHttpRetryOperations().get502Async(new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post503() throws Exception {
        client.getHttpRetryOperations().post503Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete503() throws Exception {
        client.getHttpRetryOperations().delete503Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put504() throws Exception {
        client.getHttpRetryOperations().put504Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch504() throws Exception {
        client.getHttpRetryOperations().patch504Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().code());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }
}
