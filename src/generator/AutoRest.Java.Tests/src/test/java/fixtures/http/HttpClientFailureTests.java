package fixtures.http;

import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;
import fixtures.http.models.ErrorException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class HttpClientFailureTests {
    private static AutoRestHttpInfrastructureTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head400() throws Exception {
        try {
            client.httpClientFailures().head400();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void get400() throws Exception {
        try {
            client.httpClientFailures().get400();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void put400() throws Exception {
        try {
            client.httpClientFailures().put400(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void patch400() throws Exception {
        try {
            client.httpClientFailures().patch400(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void post400() throws Exception {
        try {
            client.httpClientFailures().post400(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void delete400() throws Exception {
        try {
            client.httpClientFailures().delete400(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void head401() throws Exception {
        try {
            client.httpClientFailures().head401();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(401, ex.response().code());
        }
    }

    @Test
    public void get402() throws Exception {
        try {
            client.httpClientFailures().get402();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(402, ex.response().code());
        }
    }

    @Test
    public void get403() throws Exception {
        try {
            client.httpClientFailures().get403();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(403, ex.response().code());
        }
    }

    @Test
    public void put404() throws Exception {
        try {
            client.httpClientFailures().put404(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(404, ex.response().code());
        }
    }

    @Test
    public void patch405() throws Exception {
        try {
            client.httpClientFailures().patch405(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(405, ex.response().code());
        }
    }

    @Test
    public void post406() throws Exception {
        try {
            client.httpClientFailures().post406(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(406, ex.response().code());
        }
    }

    @Test
    public void delete407() throws Exception {
        try {
            client.httpClientFailures().delete407(true);
            fail();
        } catch (RuntimeException ex) {
            Assert.assertTrue(ex.getMessage().contains("Received HTTP_PROXY_AUTH (407) code while not using proxy"));
        }
    }

    @Test
    public void put409() throws Exception {
        try {
            client.httpClientFailures().put409(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(409, ex.response().code());
        }
    }

    @Test
    public void head410() throws Exception {
        try {
            client.httpClientFailures().head410();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(410, ex.response().code());
        }
    }

    @Test
    public void get411() throws Exception {
        try {
            client.httpClientFailures().get411();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(411, ex.response().code());
        }
    }

    @Test
    public void get412() throws Exception {
        try {
            client.httpClientFailures().get412();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(412, ex.response().code());
        }
    }

    @Test
    public void put413() throws Exception {
        try {
            client.httpClientFailures().put413(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(413, ex.response().code());
        }
    }

    @Test
    public void patch414() throws Exception {
        try {
            client.httpClientFailures().patch414(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(414, ex.response().code());
        }
    }

    @Test
    public void post415() throws Exception {
        try {
            client.httpClientFailures().post415(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(415, ex.response().code());
        }
    }

    @Test
    public void get416() throws Exception {
        try {
            client.httpClientFailures().get416();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(416, ex.response().code());
        }
    }

    @Test
    public void delete417() throws Exception {
        try {
            client.httpClientFailures().delete417(true);
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(417, ex.response().code());
        }
    }

    @Test
    public void head429() throws Exception {
        try {
            client.httpClientFailures().head429();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(429, ex.response().code());
        }
    }
}
