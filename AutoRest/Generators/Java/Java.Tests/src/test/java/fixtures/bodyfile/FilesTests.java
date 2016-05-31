package fixtures.bodyfile;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

public class FilesTests {
    private static AutoRestSwaggerBATFileService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient.Builder builder = new OkHttpClient.Builder().readTimeout(1, TimeUnit.MINUTES);
        client = new AutoRestSwaggerBATFileServiceImpl("http://localhost:3000", builder, new Retrofit.Builder());
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

    @Test
    public void getLargeFile() throws Exception {
        try (InputStream result = client.getFilesOperations().getFileLarge().getBody()) {
            long streamSize = 3000L * 1024L * 1024L;
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
