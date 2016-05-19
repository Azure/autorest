package fixtures.subscriptionidapiversion;

import fixtures.subscriptionidapiversion.models.SampleResourceGroup;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

public class GroupTests {
    private static MicrosoftAzureTestUrl client;

    @BeforeClass
    public static void setup() {
        client = new MicrosoftAzureTestUrlImpl("http://localhost:3000", null);
    }

    @Test
    public void getSampleResourceGroup() throws Exception {
        client.setSubscriptionId(UUID.randomUUID().toString());
        SampleResourceGroup group = client.getGroupOperations().getSampleResourceGroup("testgroup101").getBody();
        Assert.assertEquals("testgroup101", group.getName());
        Assert.assertEquals("West US", group.getLocation());
    }
}
