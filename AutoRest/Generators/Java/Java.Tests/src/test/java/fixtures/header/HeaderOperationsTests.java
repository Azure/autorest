package fixtures.header;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import fixtures.header.models.GreyscaleColors;
import org.apache.commons.codec.binary.Base64;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import retrofit.client.Header;

import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.fail;

public class HeaderOperationsTests {
    static AutoRestSwaggerBATHeaderService client;
    private CountDownLatch lock;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATHeaderServiceImpl("http://localhost.:3000");
    }

    @Test
    public void paramExistingKey() throws Exception {
        client.getHeaderOperations().paramExistingKey("overwrite");
    }

    @Test
    public void responseExistingKey() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseExistingKeyAsync(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("User-Agent")) {
                        Assert.assertEquals("overwrite", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramProtectedKey() throws Exception {
        try {
            client.getHeaderOperations().paramProtectedKey("text/html");
        } catch (ServiceException ex) {
            // OkHttp can actually overwrite header "Content-Type"
        }
    }

    @Test
    public void responseProtectedKey() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseProtectedKeyAsync(new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("Content-Type")) {
                        Assert.assertTrue(header.getValue().contains("text/html"));
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramInteger() throws Exception {
        client.getHeaderOperations().paramInteger("positive", 1);
        client.getHeaderOperations().paramInteger("negative", -2);
    }

    @Test
    public void responseInteger() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseIntegerAsync("positive", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("1", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseIntegerAsync("negative", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("-2", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramLong() throws Exception {
        client.getHeaderOperations().paramLong("positive", 105);
        client.getHeaderOperations().paramLong("negative", -2);
    }

    @Test
    public void responseLong() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseLongAsync("positive", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("105", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseLongAsync("negative", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("-2", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramFloat() throws Exception {
        client.getHeaderOperations().paramFloat("positive", 0.07);
        client.getHeaderOperations().paramFloat("negative", -3.0);
    }

    @Test
    public void responseFloat() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseFloatAsync("positive", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("0.07", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseFloatAsync("negative", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("-3", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDouble() throws Exception {
        client.getHeaderOperations().paramDouble("positive", 7e120);
        client.getHeaderOperations().paramDouble("negative", -3.0);
    }

    @Test
    public void responseDouble() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDoubleAsync("positive", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("7e+120", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDoubleAsync("negative", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("-3", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramBool() throws Exception {
        client.getHeaderOperations().paramBool("true", true);
        client.getHeaderOperations().paramBool("false", false);
    }

    @Test
    public void responseBool() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseBoolAsync("true", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("true", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseBoolAsync("false", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("false", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramString() throws Exception {
        client.getHeaderOperations().paramString("valid", "The quick brown fox jumps over the lazy dog");
        client.getHeaderOperations().paramString("null", null);
        client.getHeaderOperations().paramString("empty", "");
    }

    @Test
    public void responseString() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseStringAsync("valid", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("The quick brown fox jumps over the lazy dog", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseStringAsync("null", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("null", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseStringAsync("empty", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDate() throws Exception {
        client.getHeaderOperations().paramDate("valid", new LocalDate(2010, 1, 1));
        client.getHeaderOperations().paramDate("min", new LocalDate(1, 1, 1));
    }

    @Test
    public void responseDate() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDateAsync("valid", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("2010-01-01", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDateAsync("min", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("0001-01-01", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDatetime() throws Exception {
        client.getHeaderOperations().paramDatetime("valid", new DateTime(2010, 1, 1, 12, 34, 56, DateTimeZone.UTC));
        client.getHeaderOperations().paramDatetime("min", new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
    }

    @Test
    public void responseDatetime() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDatetimeAsync("valid", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("2010-01-01T12:34:56Z", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseDatetimeAsync("min", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("0001-01-01T00:00:00Z", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramByte() throws Exception {
        client.getHeaderOperations().paramByte("valid", "啊齄丂狛狜隣郎隣兀﨩".getBytes(Charset.forName("UTF-8")));
    }

    @Test
    public void responseByte() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseByteAsync("valid", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        byte[] value = Base64.decodeBase64(header.getValue());
                        String actual = new String(value, Charset.forName("UTF-8"));
                        Assert.assertEquals("啊齄丂狛狜隣郎隣兀﨩", actual);
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramEnum() throws Exception {
        client.getHeaderOperations().paramEnum("valid", GreyscaleColors.GREY);
        client.getHeaderOperations().paramEnum("null", null);
    }

    @Test
    public void responseEnum() throws Exception {
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseEnumAsync("valid", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("GREY", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.getHeaderOperations().responseEnumAsync("null", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
                fail();
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                List<Header> headers = response.getResponse().getHeaders();
                for (Header header : headers) {
                    if (header.getName().equals("value")) {
                        Assert.assertEquals("null", header.getValue());
                        lock.countDown();
                        break;
                    }
                }
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    @Ignore("Custom header not supported yet")
    public void customRequestId() throws Exception {
        client.getHeaderOperations().customRequestId();
    }
}
