package fixtures.bodyfile;

import org.junit.Assert;
import org.apache.commons.io.IOUtils;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.Ignore;

import java.io.InputStream;

public class FilesTests {
    private static AutoRestSwaggerBATFileService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATFileServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        try (InputStream result = client.getFilesOperations().getFile().getBody();
             InputStream file = classLoader.getResourceAsStream("sample.png")) {
            byte[] actual = IOUtils.toByteArray(result);
            byte[] expected = IOUtils.toByteArray(file);
            Assert.assertArrayEquals(expected, actual);
        }
    }

    @Ignore("This fails -- needs to be fixed")
    public void getLargeFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        try (InputStream result = client.getFilesOperations().getFileLarge().getBody()) {
            long streamSize = 3000 * 1024 * 1024;
            long skipped = result.skip(streamSize);
            Assert.assertEquals(streamSize, skipped);
        }
    }

    @Test
    public void getEmptyFile() throws Exception {
        try (InputStream result = client.getFilesOperations().getEmptyFile().getBody()) {
            byte[] actual = IOUtils.toByteArray(result);
            Assert.assertEquals(0, actual.length);
        }
    }
}
