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

public class HttpSuccessTests {
    static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void head200() throws Exception {
        client.getHttpSuccess().head200Async(new ServiceCallback<Void>() {
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
    public void get200() throws Exception {
        client.getHttpSuccess().get200Async(new ServiceCallback<Boolean>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Boolean> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put200() throws Exception {
        client.getHttpSuccess().put200Async(true, new ServiceCallback<Void>() {
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
    public void patch200() throws Exception {
        client.getHttpSuccess().patch200Async(true, new ServiceCallback<Void>() {
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
    public void post200() throws Exception {
        client.getHttpSuccess().post200Async(true, new ServiceCallback<Void>() {
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
    public void delete200() throws Exception {
        client.getHttpSuccess().delete200Async(true, new ServiceCallback<Void>() {
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
    public void put201() throws Exception {
        client.getHttpSuccess().put201Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(201, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post201() throws Exception {
        client.getHttpSuccess().post201Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(201, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put202() throws Exception {
        client.getHttpSuccess().put202Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(202, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch202() throws Exception {
        client.getHttpSuccess().patch202Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(202, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post202() throws Exception {
        client.getHttpSuccess().post202Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(202, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete202() throws Exception {
        client.getHttpSuccess().delete202Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(202, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void head204() throws Exception {
        client.getHttpSuccess().head204Async(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(204, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put204() throws Exception {
        client.getHttpSuccess().put204Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(204, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch204() throws Exception {
        client.getHttpSuccess().patch204Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(204, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post204() throws Exception {
        client.getHttpSuccess().post204Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(204, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete204() throws Exception {
        client.getHttpSuccess().delete204Async(true, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(204, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void head404() throws Exception {
        client.getHttpSuccess().head404Async(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(404, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }
}
