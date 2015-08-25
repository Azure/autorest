package fixtures.http;

import com.microsoft.rest.ServiceException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.fail;

public class HttpFailureTests {
    static AutoRestHttpInfrastructureTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getEmptyError() throws Exception {
        try {
            client.getHttpFailure().getEmptyError();
            fail();
        } catch (ServiceException ex) {
            Assert.assertEquals(400, ex.getResponse().getStatus());
        }
    }
}
