package fixtures.bodyfile;

import org.junit.Assert;
import org.apache.commons.io.IOUtils;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.InputStream;

public class FilesTests {
    static AutoRestSwaggerBATFileService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATFileServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        try (InputStream result = client.getFiles().getFile();
             InputStream file = classLoader.getResourceAsStream("sample.png")) {
            byte[] actual = IOUtils.toByteArray(result);
            byte[] expected = IOUtils.toByteArray(file);
            Assert.assertArrayEquals(expected, actual);
        }
    }

    @Test
    public void getEmptyFile() throws Exception {
        try (InputStream result = client.getFiles().getEmptyFile()) {
            byte[] actual = IOUtils.toByteArray(result);
            Assert.assertEquals(0, actual.length);
        }
    }
}
