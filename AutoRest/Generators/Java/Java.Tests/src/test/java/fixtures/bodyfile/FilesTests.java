package fixtures.bodyfile;

import com.microsoft.rest.RestClient;
import com.microsoft.rest.serializer.JacksonMapperAdapter;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import fixtures.bodyfile.implementation.AutoRestSwaggerBATFileServiceImpl;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;

public class FilesTests {
    private static AutoRestSwaggerBATFileService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient.Builder builder = new OkHttpClient.Builder().readTimeout(1, TimeUnit.MINUTES);
        RestClient.Builder restBuilder = new RestClient.Builder("http://localhost:3000", builder, new Retrofit.Builder())
                .withMapperAdapter(new JacksonMapperAdapter());
        client = new AutoRestSwaggerBATFileServiceImpl(restBuilder.build());
    }

    @Test
    public void getFile() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        try (InputStream result = client.files().getFile().getBody();
             InputStream file = classLoader.getResourceAsStream("sample.png")) {
            byte[] actual = IOUtils.toByteArray(result);
            byte[] expected = IOUtils.toByteArray(file);
            Assert.assertArrayEquals(expected, actual);
        }
    }

    @Test
    public void getLargeFile() throws Exception {
        try (InputStream result = client.files().getFileLarge().getBody()) {
            long streamSize = 3000L * 1024L * 1024L;
            long skipped = result.skip(streamSize);
            Assert.assertEquals(streamSize, skipped);
        }
    }

    @Test
    public void getEmptyFile() throws Exception {
        try (InputStream result = client.files().getEmptyFile().getBody()) {
            byte[] actual = IOUtils.toByteArray(result);
            Assert.assertEquals(0, actual.length);
        }
    }
}
