package fixtures.http;

import com.microsoft.rest.RestException;
import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;
import fixtures.http.models.ErrorException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class HttpFailureTests {
    private static AutoRestHttpInfrastructureTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getEmptyError() throws Exception {
        try {
            client.httpFailures().getEmptyError();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.response().code());
        }
    }

    @Test
    public void getNoModelError() throws Exception {
        try {
            client.httpFailures().getNoModelError();
            fail();
        } catch (RestException ex) {
            Assert.assertEquals(400, ex.response().code());
            //Assert.assertTrue(ex.getResponse().raw().toString().contains("NoErrorModel"));
        }
    }
}
