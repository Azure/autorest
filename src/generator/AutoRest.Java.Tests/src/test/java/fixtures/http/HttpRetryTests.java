package fixtures.http;

import com.microsoft.rest.ServiceResponse;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;
import rx.functions.Action1;

public class HttpRetryTests {
    private static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head408() throws Exception {
        client.httpRetrys().head408WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.headResponse().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put500() throws Exception {
        client.httpRetrys().put500WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch500() throws Exception {
        client.httpRetrys().patch500WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get502() throws Exception {
        client.httpRetrys().get502WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(50000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post503() throws Exception {
        client.httpRetrys().post503WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete503() throws Exception {
        client.httpRetrys().delete503WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put504() throws Exception {
        client.httpRetrys().put504WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch504() throws Exception {
        client.httpRetrys().patch504WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponse<Void>>() {
                @Override
                public void call(ServiceResponse<Void> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }
}
