package fixtures.bodyinteger;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class IntOperationsTests {
    static AutoRestIntegerTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestIntegerTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getIntOperations().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getIntOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getOverflowInt32() throws Exception {
        try {
            client.getIntOperations().getOverflowInt32();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getUnderflowInt32() throws Exception {
        try {
            client.getIntOperations().getUnderflowInt32();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getOverflowInt64() throws Exception {
        try {
            long value = client.getIntOperations().getOverflowInt64();
            Assert.assertEquals(Long.MAX_VALUE, value);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getUnderflowInt64() throws Exception {
        try {
            long value = client.getIntOperations().getUnderflowInt64();
            Assert.assertEquals(Long.MIN_VALUE, value);
        } catch (Exception exception) {
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void putMax32() throws Exception {
        client.getIntOperations().putMax32Async(Integer.MAX_VALUE, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {}

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void putMax64() throws Exception {
        client.getIntOperations().putMax64Async(Long.MAX_VALUE, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
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
    public void putMin32() throws Exception {
        client.getIntOperations().putMin32Async(Integer.MIN_VALUE, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {}

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void putMin64() throws Exception {
        client.getIntOperations().putMin64Async(Long.MIN_VALUE, new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
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
