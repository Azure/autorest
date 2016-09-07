package fixtures.bodyformdata;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;

import fixtures.bodyformdata.implementation.AutoRestSwaggerBATFormDataServiceImpl;
import rx.exceptions.Exceptions;
import rx.functions.Func1;

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
        InputStream result = client.formdatas().uploadFile(bytes, "sample.png");
        try {
            Assert.assertEquals(new String(bytes), IOUtils.toString(result));
        } finally {
            result.close();
        }
    }

    @Test
    public void uploadFileViaBody() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        try (InputStream stream = classLoader.getResourceAsStream("upload.txt")) {
            byte[] bytes = IOUtils.toByteArray(stream);
            stream.close();
            byte[] actual = client.formdatas().uploadFileViaBodyAsync(bytes)
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
            Assert.assertEquals(new String(bytes), IOUtils.toString(actual));
        }

    }
}
