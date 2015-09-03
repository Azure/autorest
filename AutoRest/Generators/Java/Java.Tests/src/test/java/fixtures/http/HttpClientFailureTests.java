package fixtures.http;

import com.microsoft.rest.ServiceException;
import fixtures.bodyboolean.AutoRestBoolTestService;
import fixtures.bodyboolean.AutoRestBoolTestServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class HttpClientFailureTests {
    static AutoRestHttpInfrastructureTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head400() throws Exception {
        try {
            client.getHttpClientFailure().head400();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get400() throws Exception {
        try {
            client.getHttpClientFailure().get400();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void put400() throws Exception {
        try {
            client.getHttpClientFailure().put400(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void patch400() throws Exception {
        try {
            client.getHttpClientFailure().patch400(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void post400() throws Exception {
        try {
            client.getHttpClientFailure().post400(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void delete400() throws Exception {
        try {
            client.getHttpClientFailure().delete400(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }

    @Test
    public void head401() throws Exception {
        try {
            client.getHttpClientFailure().head401();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(401, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get402() throws Exception {
        try {
            client.getHttpClientFailure().get402();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(402, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get403() throws Exception {
        try {
            client.getHttpClientFailure().get403();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(403, ex.getResponse().getStatus());
        }
    }

    @Test
    public void put404() throws Exception {
        try {
            client.getHttpClientFailure().put404(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(404, ex.getResponse().getStatus());
        }
    }

    @Test
    public void patch405() throws Exception {
        try {
            client.getHttpClientFailure().patch405(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(405, ex.getResponse().getStatus());
        }
    }

    @Test
    public void post406() throws Exception {
        try {
            client.getHttpClientFailure().post406(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(406, ex.getResponse().getStatus());
        }
    }

    @Test
    public void delete407() throws Exception {
        try {
            client.getHttpClientFailure().delete407(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Received HTTP_PROXY_AUTH (407) code while not using proxy"));
        }
    }

    @Test
    public void put409() throws Exception {
        try {
            client.getHttpClientFailure().put409(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(409, ex.getResponse().getStatus());
        }
    }

    @Test
    public void head410() throws Exception {
        try {
            client.getHttpClientFailure().head410();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(410, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get411() throws Exception {
        try {
            client.getHttpClientFailure().get411();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(411, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get412() throws Exception {
        try {
            client.getHttpClientFailure().get412();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(412, ex.getResponse().getStatus());
        }
    }

    @Test
    public void put413() throws Exception {
        try {
            client.getHttpClientFailure().put413(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(413, ex.getResponse().getStatus());
        }
    }

    @Test
    public void patch414() throws Exception {
        try {
            client.getHttpClientFailure().patch414(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(414, ex.getResponse().getStatus());
        }
    }

    @Test
    public void post415() throws Exception {
        try {
            client.getHttpClientFailure().post415(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(415, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get416() throws Exception {
        try {
            client.getHttpClientFailure().get416();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(416, ex.getResponse().getStatus());
        }
    }

    @Test
    public void delete417() throws Exception {
        try {
            client.getHttpClientFailure().delete417(true);
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(417, ex.getResponse().getStatus());
        }
    }

    @Test
    public void head429() throws Exception {
        try {
            client.getHttpClientFailure().head429();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(429, ex.getResponse().getStatus());
        }
    }
}
