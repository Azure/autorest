package fixtures.bodyduration;

import com.microsoft.rest.ServiceException;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;


public class DurationOperationsTests {
    static AutoRestDurationTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestDurationTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDuration().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getDuration().getInvalid();
            Assert.fail(); //Should not reach here
        }
        catch(ServiceException e) {
            //Swallow exceptions
        }
    }
    
    @Test
    public void getPositiveDuration() throws Exception {
        client.getDuration().getPositiveDuration();
    }

    @Test
    public void putPositiveDuration() throws Exception {
        client.getDuration().putPositiveDuration(new Period(0, 0, 0, 123, 22, 14, 12, 11));
    }
    
}
