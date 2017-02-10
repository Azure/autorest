package fixtures.http;

import com.microsoft.rest.RestException;
import com.microsoft.rest.ServiceResponse;
import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;
import fixtures.http.models.A;
import fixtures.http.models.C;
import fixtures.http.models.D;
import fixtures.http.models.Error;
import fixtures.http.models.ErrorException;
import fixtures.http.models.MyException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import rx.functions.Action1;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class MultipleResponsesTests {
    private static AutoRestHttpInfrastructureTestServiceImpl client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void get200Model204NoModelDefaultError200Valid() throws Exception {
        A result = client.multipleResponses().get200Model204NoModelDefaultError200Valid();
        Assert.assertEquals(A.class, result.getClass());
        Assert.assertEquals("200", result.statusCode());
    }

    @Test
    public void get200Model204NoModelDefaultError204Valid() throws Exception {
        A result = client.multipleResponses().get200Model204NoModelDefaultError204Valid();
        Assert.assertNull(result);
    }

    @Test
    public void get200Model204NoModelDefaultError201Invalid() throws Exception {
        try {
            client.multipleResponses().get200Model204NoModelDefaultError201Invalid();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(201, ex.response().code());
        }
    }

    @Test
    public void get200Model204NoModelDefaultError202None() throws Exception {
        try {
            A result = client.multipleResponses().get200Model204NoModelDefaultError202None();
        } catch (ErrorException ex) {
            Assert.assertEquals(202, ex.response().code());
        }
    }

    @Test
    public void get200Model204NoModelDefaultError400Valid() throws Exception {
        try {
            client.multipleResponses().get200Model204NoModelDefaultError400Valid();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get200Model201ModelDefaultError200Valid() throws Exception {
        A result = client.multipleResponses().get200Model201ModelDefaultError200Valid();
        Assert.assertEquals("200", result.statusCode());
    }

    @Test
    public void get200Model201ModelDefaultError201Valid() throws Exception {
        A result = client.multipleResponses().get200Model201ModelDefaultError201Valid();
        Assert.assertEquals("201", result.statusCode());
    }

    @Test
    public void get200Model201ModelDefaultError400Valid() throws Exception {
        try {
            client.multipleResponses().get200Model201ModelDefaultError400Valid();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
            Assert.assertEquals(400, ex.body().status().intValue());
            Assert.assertEquals("client error", ex.body().message());
        }
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError200Valid() throws Exception {
        Object result = client.multipleResponses().get200ModelA201ModelC404ModelDDefaultError200Valid();
        A actual = (A) result;
        Assert.assertEquals("200", actual.statusCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError201Valid() throws Exception {
        Object result = client.multipleResponses().get200ModelA201ModelC404ModelDDefaultError201Valid();
        C actual = (C) result;
        Assert.assertEquals("201", actual.httpCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError404Valid() throws Exception {
        Object result = client.multipleResponses().get200ModelA201ModelC404ModelDDefaultError404Valid();
        D actual = (D) result;
        Assert.assertEquals("404", actual.httpStatusCode());
    }

    @Test
    public void get200ModelA201ModelC404ModelDDefaultError400Valid() throws Exception {
        try {
            client.multipleResponses().get200ModelA201ModelC404ModelDDefaultError400Valid();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
            Error model = ex.body();
            Assert.assertEquals(400, model.status().intValue());
            Assert.assertEquals("client error", model.message());
        }
    }

    @Test
    public void get202None204NoneDefaultError202None() throws Exception {
        client.multipleResponses().get202None204NoneDefaultError202NoneWithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(202, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get202None204NoneDefaultError204None() throws Exception {
        client.multipleResponses().get202None204NoneDefaultError204NoneWithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(204, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get202None204NoneDefaultError400Valid() throws Exception {
        try {
            client.multipleResponses().get202None204NoneDefaultError400Valid();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
            Error model = ex.body();
            Assert.assertEquals(400, model.status().intValue());
            Assert.assertEquals("client error", model.message());
        }
    }

    @Test
    public void get202None204NoneDefaultNone202Invalid() throws Exception {
        client.multipleResponses().get202None204NoneDefaultNone202Invalid();
    }

    @Test
    public void get202None204NoneDefaultNone204None() throws Exception {
        client.multipleResponses().get202None204NoneDefaultNone204None();
    }

    @Test
    public void get202None204NoneDefaultNone400None() throws Exception {
        try {
            client.multipleResponses().get202None204NoneDefaultNone400None();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get202None204NoneDefaultNone400Invalid() throws Exception {
        try {
            client.multipleResponses().get202None204NoneDefaultNone400Invalid();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void getDefaultModelA200Valid() throws Exception {
        A result = client.multipleResponses().getDefaultModelA200Valid();
        Assert.assertEquals("200", result.statusCode());
    }

    @Test
    public void getDefaultModelA200None() throws Exception {
        A result = client.multipleResponses().getDefaultModelA200None();
        Assert.assertNull(result);
    }

    @Test
    public void getDefaultModelA400Valid() throws Exception {
        try {
            client.multipleResponses().getDefaultModelA400Valid();
            fail();
        } catch (MyException ex) {
            Assert.assertEquals(400, ex.response().code());
            Assert.assertEquals("400", ex.body().statusCode());
        }
    }

    @Test
    public void getDefaultModelA400None() throws Exception {
        try {
            client.multipleResponses().getDefaultModelA400None();
            fail();
        } catch (MyException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void getDefaultNone200Invalid() throws Exception {
        client.multipleResponses().getDefaultNone200Invalid();
    }

    @Test
    public void getDefaultNone200None() throws Exception {
        client.multipleResponses().getDefaultNone200None();
    }

    @Test
    public void getDefaultNone400Invalid() throws Exception {
        try {
            client.multipleResponses().getDefaultNone400Invalid();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void getDefaultNone400None() throws Exception {
        try {
            client.multipleResponses().getDefaultNone400None();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get200ModelA200None() throws Exception {
        A result = client.multipleResponses().get200ModelA200None();
        Assert.assertNull(result);
    }

    @Test
    public void get200ModelA200Valid() throws Exception {
        A result = client.multipleResponses().get200ModelA200Valid();
        Assert.assertEquals("200", result.statusCode());
    }

    @Test
    public void get200ModelA200Invalid() throws Exception {
        Assert.assertEquals(null, client.multipleResponses().get200ModelA200Invalid().statusCode());
    }

    @Test
    public void get200ModelA400None() throws Exception {
        try {
            client.multipleResponses().get200ModelA400None();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
            Assert.assertNull(ex.body());
        }
    }

    @Test
    public void get200ModelA400Valid() throws Exception {
        try {
            client.multipleResponses().get200ModelA400Valid();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get200ModelA400Invalid() throws Exception {
        try {
            client.multipleResponses().get200ModelA400Invalid();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get200ModelA202Valid() throws Exception {
        try {
            client.multipleResponses().get200ModelA202Valid();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(202, ex.response().code());
        }
    }
}

