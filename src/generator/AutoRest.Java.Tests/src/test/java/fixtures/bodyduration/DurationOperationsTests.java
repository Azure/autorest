package fixtures.bodyduration;

import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodyduration.implementation.AutoRestDurationTestServiceImpl;


public class DurationOperationsTests {
    private static AutoRestDurationTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestDurationTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.durations().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.durations().getInvalid();
            Assert.fail(); //Should not reach here
        }
        catch (IllegalArgumentException e) {
            //Swallow exceptions
        }
    }

    @Test
    public void getPositiveDuration() throws Exception {
        client.durations().getPositiveDuration();
    }

    @Test
    public void putPositiveDuration() throws Exception {
        client.durations().putPositiveDuration(new Period(0, 0, 0, 123, 22, 14, 12, 11));
    }
}
