package fixtures.bodyfile;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import fixtures.bodyfile.implementation.AutoRestSwaggerBATFileServiceImpl;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import rx.exceptions.Exceptions;
import rx.functions.Func1;

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
        try (InputStream file = classLoader.getResourceAsStream("sample.png")) {
            byte[] actual = client.files().getFileAsync()
                .map(new Func1<InputStream, byte[]>() {
                    @Override
                    public byte[] call(InputStream inputStreamServiceResponse) {
                        try {
                            return IOUtils.toByteArray(inputStreamServiceResponse);
                        } catch (IOException e) {
                            throw Exceptions.propagate(e);
                        }
                    }
                }).toBlocking().single();
            byte[] expected = IOUtils.toByteArray(file);
            Assert.assertArrayEquals(expected, actual);
        }
    }

    @Test
    public void getLargeFile() throws Exception {
        final long streamSize = 3000L * 1024L * 1024L;
        long skipped = client.files().getFileLargeAsync()
            .map(new Func1<InputStream, Long>() {
                @Override
                public Long call(InputStream inputStreamServiceResponse) {
                    try {
                        return inputStreamServiceResponse.skip(streamSize);
                    } catch (IOException e) {
                        throw Exceptions.propagate(e);
                    }
                }
            }).toBlocking().single();
        Assert.assertEquals(streamSize, skipped);
    }

    @Test
    public void getEmptyFile() throws Exception {
        try (InputStream result = client.files().getEmptyFile()) {
            byte[] actual = IOUtils.toByteArray(result);
            Assert.assertEquals(0, actual.length);
        }
    }
}
