package fixtures.http;

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
            client.getHttpFailureOperations().getEmptyError();
            fail();
        } catch (ErrorException ex) {
            Assert.assertEquals(400, ex.getResponse().code());
        }
    }
}
