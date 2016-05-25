package fixtures.headexceptions;

import com.microsoft.rest.ServiceException;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.headexceptions.implementation.AutoRestHeadExceptionTestServiceImpl;

public class HeadExceptionTests {
    private static AutoRestHeadExceptionTestServiceImpl client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestHeadExceptionTestServiceImpl("http://localhost:3000", null);
    }

    @Test
    public void headException200() throws Exception {
        client.headExceptions().head200();
    }

    @Test
    public void headException204() throws Exception {
        client.headExceptions().head204();
    }

    @Test(expected = ServiceException.class)
    public void headException404() throws Exception {
        client.headExceptions().head404();
    }
}
