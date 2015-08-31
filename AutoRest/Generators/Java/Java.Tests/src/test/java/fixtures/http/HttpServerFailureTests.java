package fixtures.http;

import com.microsoft.rest.ServiceException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class HttpServerFailureTests {
    static AutoRestHttpInfrastructureTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void head501() throws Exception {
        try {
            client.getHttpServerFailure().head501();
        } catch (ServiceException ex) {
            Assert.assertEquals(501, ex.getResponse().getStatus());
        }
    }

    @Test
    public void get501() throws Exception {
        try {
            client.getHttpServerFailure().get501();
        } catch (ServiceException ex) {
            Assert.assertEquals(501, ex.getResponse().getStatus());
        }
    }

    @Test
    public void post505() throws Exception {
        try {
            client.getHttpServerFailure().post505(true);
        } catch (ServiceException ex) {
            Assert.assertEquals(505, ex.getResponse().getStatus());
        }
    }

    @Test
    public void delete505() throws Exception {
        try {
            client.getHttpServerFailure().delete505(true);
        } catch (ServiceException ex) {
            Assert.assertEquals(505, ex.getResponse().getStatus());
        }
    }
}
