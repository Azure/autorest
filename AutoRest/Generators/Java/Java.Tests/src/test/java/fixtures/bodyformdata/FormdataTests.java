package fixtures.bodyformdata;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class FormdataTests {
    private static AutoRestSwaggerBATFormDataService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATFormDataServiceImpl("http://localhost.:3000");
    }

    @Test
    public void uploadFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        File file = new File(classLoader.getResource("upload.txt").getFile());
        InputStream result = client.getFormdataOperations().uploadFile(file, "sample.png").getBody();
        try {
            Assert.assertEquals(IOUtils.toString(new FileInputStream(file)), IOUtils.toString(result));
        } finally {
            result.close();
        }
    }

    @Test
    public void uploadFileViaBody() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        File file = new File(classLoader.getResource("upload.txt").getFile());
        InputStream result = client.getFormdataOperations().uploadFileViaBody(file).getBody();
        try {
            Assert.assertEquals(IOUtils.toString(new FileInputStream(file)), IOUtils.toString(result));
        } finally {
            result.close();
        }
    }
}
