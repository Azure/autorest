package fixtures.http;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import com.microsoft.rest.serializer.JacksonHelper;
import fixtures.http.models.A;
import fixtures.http.models.C;
import fixtures.http.models.D;
import fixtures.http.models.Error;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class MultipleResponsesTests {
    static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void get200Model204NoModelDefaultError200Valid() throws Exception {
        A result = client.getMultipleResponses().get200Model204NoModelDefaultError200Valid();
        Assert.assertEquals(A.class, result.getClass());
        Assert.assertEquals("200", result.getStatusCode());
    }

    @Test
    public void get200Model204NoModelDefaultError204Valid() throws Exception {
        A result = client.getMultipleResponses().get200Model204NoModelDefaultError204Valid();
        Assert.assertNull(result);
    }

    @Test
    public void get200Model204NoModelDefaultError201Invalid() throws Exception {
        try {
            client.getMultipleResponses().get200Model204NoModelDefaultError201Invalid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(201, ex.getResponse().getStatus());
            Assert.assertNotNull(ex.getErrorModel());
        }
    }

    @Test
    public void get200Model204NoModelDefaultError202None() throws Exception {
        try {
            A result = client.getMultipleResponses().get200Model204NoModelDefaultError202None();
        } catch (ServiceException ex) {
            Assert.assertEquals(202, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get200Model204NoModelDefaultError400Valid() throws Exception {
        try {
            client.getMultipleResponses().get200Model204NoModelDefaultError400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get200Model201ModelDefaultError200Valid() throws Exception {
        A result = client.getMultipleResponses().get200Model201ModelDefaultError200Valid();
        Assert.assertEquals("200", result.getStatusCode());
    }

    @Test
    public void get200Model201ModelDefaultError201Valid() throws Exception {
        A result = client.getMultipleResponses().get200Model201ModelDefaultError201Valid();
        Assert.assertEquals("201", result.getStatusCode());
    }

    @Test
    public void get200Model201ModelDefaultError400Valid() throws Exception {
        try {
            client.getMultipleResponses().get200Model201ModelDefaultError400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
            Error model = JacksonHelper.getObjectMapper().convertValue(
                    ex.getErrorModel(), Error.class);
            Assert.assertEquals(400, model.getStatus().intValue());
            Assert.assertEquals("client error", model.getMessage());
        }
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError200Valid() throws Exception {
        Object result = client.getMultipleResponses().get200ModelA201ModelC404ModelDDefaultError200Valid();
        A actual = (A)result;
        Assert.assertEquals("200", actual.getStatusCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError201Valid() throws Exception {
        Object result = client.getMultipleResponses().get200ModelA201ModelC404ModelDDefaultError201Valid();
        C actual = (C)result;
        Assert.assertEquals("201", actual.getHttpCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError404Valid() throws Exception {
        Object result = client.getMultipleResponses().get200ModelA201ModelC404ModelDDefaultError404Valid();
        D actual = (D)result;
        Assert.assertEquals("404", actual.getHttpStatusCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError400Valid() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA201ModelC404ModelDDefaultError400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
            Error model = JacksonHelper.getObjectMapper().convertValue(
                    ex.getErrorModel(), Error.class);
            Assert.assertEquals(400, model.getStatus().intValue());
            Assert.assertEquals("client error", model.getMessage());
        }
    }

    @Test
    public void get202None204NoneDefaultError202None() throws Exception {
        client.getMultipleResponses().get202None204NoneDefaultError202NoneAsync(new ServiceCallback<Void>() {
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
    public void get202None204NoneDefaultError204None() throws Exception {
        client.getMultipleResponses().get202None204NoneDefaultError204NoneAsync(new ServiceCallback<Void>() {
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
    public void get202None204NoneDefaultError400Valid() throws Exception {
        try {
            client.getMultipleResponses().get202None204NoneDefaultError400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
            Error model = JacksonHelper.getObjectMapper().convertValue(
                    ex.getErrorModel(), Error.class);
            Assert.assertEquals(400, model.getStatus().intValue());
            Assert.assertEquals("client error", model.getMessage());
        }
    }

    @Test
    public void get202None204NoneDefaultNone202Invalid() throws Exception {
        client.getMultipleResponses().get202None204NoneDefaultNone202Invalid();
    }

    @Test
    public void get202None204NoneDefaultNone204None() throws Exception {
        client.getMultipleResponses().get202None204NoneDefaultNone204None();
    }

    @Test
    public void get202None204NoneDefaultNone400None() throws Exception {
        try {
            client.getMultipleResponses().get202None204NoneDefaultNone400None();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get202None204NoneDefaultNone400Invalid() throws Exception {
        try {
            client.getMultipleResponses().get202None204NoneDefaultNone400Invalid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void getDefaultModelA200Valid() throws Exception {
        A result = client.getMultipleResponses().getDefaultModelA200Valid();
        Assert.assertEquals("200", result.getStatusCode());
    }

    @Test
    public void getDefaultModelA200None() throws Exception {
        A result = client.getMultipleResponses().getDefaultModelA200None();
        Assert.assertNull(result);
    }

    @Test
    public void getDefaultModelA400Valid() throws Exception {
        try {
            client.getMultipleResponses().getDefaultModelA400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
            A model = JacksonHelper.getObjectMapper().convertValue(
                    ex.getErrorModel(), A.class);
            Assert.assertEquals("400", model.getStatusCode());
        }
    }

    @Test
    public void getDefaultModelA400None() throws Exception {
        try {
            client.getMultipleResponses().getDefaultModelA400None();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void getDefaultNone200Invalid() throws Exception {
        client.getMultipleResponses().getDefaultNone200Invalid();
    }

    @Test
    public void getDefaultNone200None() throws Exception {
        client.getMultipleResponses().getDefaultNone200None();
    }

    @Test
    public void getDefaultNone400Invalid() throws Exception {
        try {
            client.getMultipleResponses().getDefaultNone400Invalid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void getDefaultNone400None() throws Exception {
        try {
            client.getMultipleResponses().getDefaultNone400None();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get200ModelA200None() throws Exception {
        A result = client.getMultipleResponses().get200ModelA200None();
        Assert.assertNull(result);
    }

    @Test
    public void get200ModelA200Valid() throws Exception {
        A result = client.getMultipleResponses().get200ModelA200Valid();
        Assert.assertEquals("200", result.getStatusCode());
    }

    @Test
    public void get200ModelA200Invalid() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA200Invalid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(200, ex.getResponse().getStatus());
            Assert.assertTrue(ex.getMessage().contains("UnrecognizedPropertyException"));
        }
    }

    @Test
    public void get200ModelA400None() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA400None();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
            Assert.assertNull(ex.getErrorModel());
        }
    }

    @Test
    public void get200ModelA400Valid() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA400Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get200ModelA400Invalid() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA400Invalid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get200ModelA202Valid() throws Exception {
        try {
            client.getMultipleResponses().get200ModelA202Valid();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(202, ex.getResponse().getStatus());
        }
    }
}

