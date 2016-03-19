package fixtures.bodyformdata;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.InputStream;

import okhttp3.logging.HttpLoggingInterceptor;

public class FormdataTests {
    private static AutoRestSwaggerBATFormDataService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATFormDataServiceImpl("http://localhost.:3000");
        client.setLogLevel(HttpLoggingInterceptor.Level.BODY);
    }

    @Test
    public void uploadFile() throws Exception {
        String testString = "Upload file test case";
        InputStream result = client.getFormdataOperations().uploadFile(testString.getBytes("UTF-8"), "UploadFile.txt").getBody();
        Assert.assertEquals(testString, IOUtils.toString(result));
    }

    @Test
    public void uploadFileViaBody() throws Exception {
        String testString = "Upload file test case";
        InputStream result = client.getFormdataOperations().uploadFileViaBody(testString.getBytes("UTF-8")).getBody();
        Assert.assertEquals(testString, IOUtils.toString(result));
    }
}
