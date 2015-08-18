package fixtures.bodystring;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import fixtures.bodyinteger.AutoRestIntegerTestService;
import fixtures.bodyinteger.AutoRestIntegerTestServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class StringOperationsTests {
    static AutoRestSwaggerBATService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        String result = client.getStringOperations().getNull();
        Assert.assertNull(result);
    }

    @Test
    public void putNull() throws Exception {
        try {
            client.getStringOperations().putNull(null);
        } catch (Exception ex) {
            Assert.assertEquals(ServiceException.class, ex.getClass());
            Assert.assertTrue(ex.getCause().getMessage().contains("Body parameter value must not be null"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        String result = client.getStringOperations().getEmpty();
        Assert.assertEquals("", result);
    }

    @Test
    public void putEmpty() throws Exception {
        client.getStringOperations().putEmptyAsync("", new ServiceCallback<Void>() {
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
