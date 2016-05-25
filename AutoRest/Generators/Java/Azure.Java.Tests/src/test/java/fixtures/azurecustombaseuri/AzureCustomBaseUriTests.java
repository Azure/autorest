package fixtures.azurecustombaseuri;

import com.microsoft.rest.credentials.TokenCredentials;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.UnknownHostException;
import java.util.UUID;

import fixtures.custombaseuri.AutoRestParameterizedHostTestClient;
import fixtures.custombaseuri.AutoRestParameterizedHostTestClientImpl;

public class AzureCustomBaseUriTests {
    private static AutoRestParameterizedHostTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterizedHostTestClientImpl(new TokenCredentials(null, UUID.randomUUID().toString()));
    }

    // Positive test case
    @Test
    public void getEmptyWithValidCustomUri() throws Exception {
        client.setHost("host:3000");
        Assert.assertTrue(client.getPathsOperations().getEmpty("local").getResponse().isSuccess());
    }

    @Test
    public void getEmptyWithInvalidCustomUriAccountName() throws Exception {
        try {
            client.getPathsOperations().getEmpty("bad");
            Assert.assertTrue(false);
        }
        catch (UnknownHostException e) {
            Assert.assertTrue(true);
        }
    }

    @Test
    public void getEmptyWithInvalidCustomUriHostName() throws Exception {
        try {
            client.setHost("badhost");
            client.getPathsOperations().getEmpty("local");
            Assert.assertTrue(false);
        }
        catch (UnknownHostException e) {
            Assert.assertTrue(true);
        }
        finally {
            client.setHost("host:3000");
        }
    }

    @Test
    public void getEmptyWithEmptyCustomUriAccountName() throws Exception {
        try {
            client.getPathsOperations().getEmpty(null);
            Assert.assertTrue(false);
        }
        catch (IllegalArgumentException e) {
            Assert.assertTrue(true);
        }
    }
}
