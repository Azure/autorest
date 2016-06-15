package fixtures.bodyformdata;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.InputStream;

public class FormdataTests {
    private static AutoRestSwaggerBATFormDataService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATFormDataServiceImpl("http://localhost:3000");
    }

    @Test
    public void uploadFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        InputStream stream = classLoader.getResourceAsStream("upload.txt");
        byte[] bytes = IOUtils.toByteArray(stream);
        stream.close();
        InputStream result = client.getFormdataOperations().uploadFile(bytes, "sample.png").getBody();
        try {
            Assert.assertEquals(new String(bytes), IOUtils.toString(result));
        } finally {
            result.close();
        }
    }

    @Test
    public void uploadFileViaBody() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        InputStream stream = classLoader.getResourceAsStream("upload.txt");
        byte[] bytes = IOUtils.toByteArray(stream);
        stream.close();
        InputStream result = client.getFormdataOperations().uploadFileViaBody(bytes).getBody();
        try {
            Assert.assertEquals(new String(bytes), IOUtils.toString(result));
        } finally {
            result.close();
        }
    }
}
