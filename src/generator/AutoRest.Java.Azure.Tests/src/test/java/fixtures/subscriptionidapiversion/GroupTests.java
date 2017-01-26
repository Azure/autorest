package fixtures.subscriptionidapiversion;

import com.microsoft.rest.credentials.BasicAuthenticationCredentials;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.UUID;

import fixtures.subscriptionidapiversion.implementation.MicrosoftAzureTestUrlImpl;
import fixtures.subscriptionidapiversion.models.SampleResourceGroup;

public class GroupTests {
    private static MicrosoftAzureTestUrlImpl client;

    @BeforeClass
    public static void setup() {
        client = new MicrosoftAzureTestUrlImpl("http://localhost:3000", new BasicAuthenticationCredentials(null, null));
    }

    @Test
    public void getSampleResourceGroup() throws Exception {
        client.withSubscriptionId(UUID.randomUUID().toString());
        SampleResourceGroup group = client.groups().getSampleResourceGroup("testgroup101");
        Assert.assertEquals("testgroup101", group.name());
        Assert.assertEquals("West US", group.location());
    }
}
