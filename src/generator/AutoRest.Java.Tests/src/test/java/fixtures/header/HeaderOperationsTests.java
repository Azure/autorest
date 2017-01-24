package fixtures.header;

import com.microsoft.rest.ServiceResponseWithHeaders;

import org.apache.commons.codec.binary.Base64;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.nio.charset.Charset;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import fixtures.header.implementation.AutoRestSwaggerBATHeaderServiceImpl;
import fixtures.header.models.GreyscaleColors;
import fixtures.header.models.HeaderResponseBoolHeaders;
import fixtures.header.models.HeaderResponseByteHeaders;
import fixtures.header.models.HeaderResponseDateHeaders;
import fixtures.header.models.HeaderResponseDatetimeHeaders;
import fixtures.header.models.HeaderResponseDatetimeRfc1123Headers;
import fixtures.header.models.HeaderResponseDoubleHeaders;
import fixtures.header.models.HeaderResponseDurationHeaders;
import fixtures.header.models.HeaderResponseEnumHeaders;
import fixtures.header.models.HeaderResponseExistingKeyHeaders;
import fixtures.header.models.HeaderResponseFloatHeaders;
import fixtures.header.models.HeaderResponseIntegerHeaders;
import fixtures.header.models.HeaderResponseLongHeaders;
import fixtures.header.models.HeaderResponseProtectedKeyHeaders;
import fixtures.header.models.HeaderResponseStringHeaders;
import okhttp3.Headers;
import rx.functions.Action1;

import static org.junit.Assert.fail;

public class HeaderOperationsTests {
    private static AutoRestSwaggerBATHeaderService client;
    private CountDownLatch lock;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATHeaderServiceImpl("http://localhost:3000");
    }

    @Test
    public void paramExistingKey() throws Exception {
        client.headers().paramExistingKey("overwrite");
    }

    @Test
    public void responseExistingKey() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseExistingKeyWithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseExistingKeyHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseExistingKeyHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("User-Agent") != null) {
                        Assert.assertEquals("overwrite", headers.get("User-Agent"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramProtectedKey() throws Exception {
        try {
            client.headers().paramProtectedKey("text/html");
        } catch (RuntimeException ex) {
            // OkHttp can actually overwrite header "Content-Type"
        }
    }

    @Test
    public void responseProtectedKey() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseProtectedKeyWithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseProtectedKeyHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseProtectedKeyHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("Content-Type") != null) {
                        Assert.assertTrue(headers.get("Content-Type").contains("text/html"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramInteger() throws Exception {
        client.headers().paramInteger("positive", 1);
        client.headers().paramInteger("negative", -2);
    }

    @Test
    public void responseInteger() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseIntegerWithServiceResponseAsync("positive")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseIntegerHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseIntegerHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("1", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseIntegerWithServiceResponseAsync("negative")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseIntegerHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseIntegerHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("-2", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramLong() throws Exception {
        client.headers().paramLong("positive", 105);
        client.headers().paramLong("negative", -2);
    }

    @Test
    public void responseLong() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseLongWithServiceResponseAsync("positive")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseLongHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseLongHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("105", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseLongWithServiceResponseAsync("negative")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseLongHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseLongHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("-2", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramFloat() throws Exception {
        client.headers().paramFloat("positive", 0.07);
        client.headers().paramFloat("negative", -3.0);
    }

    @Test
    public void responseFloat() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseFloatWithServiceResponseAsync("positive")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseFloatHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseFloatHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("0.07", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseFloatWithServiceResponseAsync("negative")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseFloatHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseFloatHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("-3", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDouble() throws Exception {
        client.headers().paramDouble("positive", 7e120);
        client.headers().paramDouble("negative", -3.0);
    }

    @Test
    public void responseDouble() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseDoubleWithServiceResponseAsync("positive")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDoubleHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDoubleHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("7e+120", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseDoubleWithServiceResponseAsync("negative")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDoubleHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDoubleHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("-3", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramBool() throws Exception {
        client.headers().paramBool("true", true);
        client.headers().paramBool("false", false);
    }

    @Test
    public void responseBool() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseBoolWithServiceResponseAsync("true")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseBoolHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseBoolHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("true", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseBoolWithServiceResponseAsync("false")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseBoolHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseBoolHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("false", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramString() throws Exception {
        client.headers().paramString("valid", "The quick brown fox jumps over the lazy dog");
        client.headers().paramString("null", null);
        client.headers().paramString("empty", "");
    }

    @Test
    public void responseString() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseStringWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("The quick brown fox jumps over the lazy dog", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseStringWithServiceResponseAsync("null")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("null", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseStringWithServiceResponseAsync("empty")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseStringHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDate() throws Exception {
        client.headers().paramDate("valid", new LocalDate(2010, 1, 1));
        client.headers().paramDate("min", new LocalDate(1, 1, 1));
    }

    @Test
    public void responseDate() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseDateWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDateHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDateHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("2010-01-01", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseDateWithServiceResponseAsync("min")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDateHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDateHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("0001-01-01", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDuration() throws Exception {
        client.headers().paramDuration("valid", new Period(0, 0, 0, 123, 22, 14, 12, 11));
    }

    @Test
    public void responseDuration() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseDurationWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDurationHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDurationHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("P123DT22H14M12.011S", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDatetimeRfc1123() throws Exception {
        client.headers().paramDatetimeRfc1123("valid", new DateTime(2010, 1, 1, 12, 34, 56, DateTimeZone.UTC));
        client.headers().paramDatetimeRfc1123("min", new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
    }

    @Test
    public void responseDatetimeRfc1123() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseDatetimeRfc1123WithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDatetimeRfc1123Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDatetimeRfc1123Headers> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("Fri, 01 Jan 2010 12:34:56 GMT", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(100000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseDatetimeRfc1123WithServiceResponseAsync("min")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDatetimeRfc1123Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDatetimeRfc1123Headers> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("Mon, 01 Jan 0001 00:00:00 GMT", headers.get("value"));
                        lock.countDown();

                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramDatetime() throws Exception {
        client.headers().paramDatetime("valid", new DateTime(2010, 1, 1, 12, 34, 56, DateTimeZone.UTC));
        client.headers().paramDatetime("min", new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
    }

    @Test
    public void responseDatetime() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseDatetimeWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDatetimeHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDatetimeHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("2010-01-01T12:34:56Z", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseDatetimeWithServiceResponseAsync("min")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseDatetimeHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseDatetimeHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("0001-01-01T00:00:00Z", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramByte() throws Exception {
        client.headers().paramByte("valid", "啊齄丂狛狜隣郎隣兀﨩".getBytes(Charset.forName("UTF-8")));
    }

    @Test
    public void responseByte() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseByteWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseByteHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseByteHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        byte[] value = Base64.decodeBase64(headers.get("value"));
                        String actual = new String(value, Charset.forName("UTF-8"));
                        Assert.assertEquals("啊齄丂狛狜隣郎隣兀﨩", actual);
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void paramEnum() throws Exception {
        client.headers().paramEnum("valid", GreyscaleColors.GREY);
        client.headers().paramEnum("null", null);
    }

    @Test
    public void responseEnum() throws Exception {
        lock = new CountDownLatch(1);
        client.headers().responseEnumWithServiceResponseAsync("valid")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseEnumHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseEnumHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("GREY", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
        lock = new CountDownLatch(1);
        client.headers().responseEnumWithServiceResponseAsync("null")
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HeaderResponseEnumHeaders>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HeaderResponseEnumHeaders> response) {
                    Headers headers = response.response().headers();
                    if (headers.get("value") != null) {
                        Assert.assertEquals("", headers.get("value"));
                        lock.countDown();
                    }
                }
            }, new Action1<Throwable>() {
                @Override
                public void call(Throwable throwable) {
                    fail();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    @Ignore("Custom header not supported yet")
    public void customRequestId() throws Exception {
        client.headers().customRequestId();
    }
}
