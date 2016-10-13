package fixtures.custombaseuri;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import fixtures.custombaseuri.implementation.AutoRestParameterizedHostTestClientImpl;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Response;
import retrofit2.Retrofit;

import static org.junit.Assert.fail;

public class CustomBaseUriTests {
    private static AutoRestParameterizedHostTestClient client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestParameterizedHostTestClientImpl();
    }

    // Positive test case
    @Test
    public void getEmptyWithValidCustomUri() throws Exception {
        client.withHost("host:3000");
        client.paths().getEmpty("local");
    }

    @Test
    public void getEmptyWithInvalidCustomUriAccountName() throws Exception {
        try {
            client.paths().getEmpty("bad");
            Assert.assertTrue(false);
        }
        catch (RuntimeException e) {
            Assert.assertTrue(true);
        }
    }

    @Test
    public void getEmptyWithInvalidCustomUriHostName() throws Exception {
        try {
            client.withHost("badhost");
            client.paths().getEmpty("local");
            Assert.assertTrue(false);
        }
        catch (RuntimeException e) {
            Assert.assertTrue(true);
        }
        finally {
            client.withHost("host:3000");
        }
    }

    @Test
    public void getEmptyWithEmptyCustomUriAccountName() throws Exception {
        try {
            client.paths().getEmpty(null);
            Assert.assertTrue(false);
        }
        catch (IllegalArgumentException e) {
            Assert.assertTrue(true);
        }
    }

    @Test
    public void getEmptyMultipleThreads() throws Exception {
        final CountDownLatch latch = new CountDownLatch(2);
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder()
                .addInterceptor(new Interceptor() {
                    @Override
                    public Response intercept(Chain chain) throws IOException {
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            // do nothing
                        }
                        return chain.proceed(chain.request());
                    }
                });
        final AutoRestParameterizedHostTestClient client1 = new AutoRestParameterizedHostTestClientImpl(clientBuilder, new Retrofit.Builder());
        client1.withHost("host:3000");
        Thread t1 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    client1.paths().getEmpty("badlocal");
                    fail();
                } catch (RuntimeException e) {
                    latch.countDown();
                } catch (Exception e) {
                    fail();
                }
            }
        });
        Thread t2 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    client1.paths().getEmpty("local");
                    latch.countDown();
                } catch (Exception ex) {
                    fail();
                }
            }
        });
        t1.start();
        t2.start();
        Assert.assertTrue(latch.await(15, TimeUnit.SECONDS));
    }
}
