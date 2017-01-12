package fixtures.http;

import com.microsoft.rest.ServiceResponseWithHeaders;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;
import fixtures.http.models.HttpRedirectsDelete307Headers;
import fixtures.http.models.HttpRedirectsGet300Headers;
import fixtures.http.models.HttpRedirectsGet301Headers;
import fixtures.http.models.HttpRedirectsGet302Headers;
import fixtures.http.models.HttpRedirectsGet307Headers;
import fixtures.http.models.HttpRedirectsHead300Headers;
import fixtures.http.models.HttpRedirectsHead301Headers;
import fixtures.http.models.HttpRedirectsHead302Headers;
import fixtures.http.models.HttpRedirectsHead307Headers;
import fixtures.http.models.HttpRedirectsPatch302Headers;
import fixtures.http.models.HttpRedirectsPatch307Headers;
import fixtures.http.models.HttpRedirectsPost303Headers;
import fixtures.http.models.HttpRedirectsPost307Headers;
import fixtures.http.models.HttpRedirectsPut301Headers;
import fixtures.http.models.HttpRedirectsPut307Headers;
import rx.functions.Action1;

public class HttpRedirectsTests {
    private static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head300() throws Exception {
        client.httpRedirects().head300WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsHead300Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsHead300Headers> response) {
                    Assert.assertEquals(200, response.headResponse().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(100000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get300() throws Exception {
        client.httpRedirects().get300WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<List<String>, HttpRedirectsGet300Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<List<String>, HttpRedirectsGet300Headers> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void head301() throws Exception {
        client.httpRedirects().head301WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsHead301Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsHead301Headers> response) {
                    Assert.assertEquals(200, response.headResponse().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get301() throws Exception {
        client.httpRedirects().get301WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsGet301Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsGet301Headers> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    @Ignore("Not supported yet")
    public void put301() throws Exception {
        client.httpRedirects().put301WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPut301Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPut301Headers> response) {
                    Assert.assertEquals(301, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void head302() throws Exception {
        client.httpRedirects().head302WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsHead302Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsHead302Headers> response) {
                    Assert.assertEquals(200, response.headResponse().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get302() throws Exception {
        client.httpRedirects().get302WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsGet302Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsGet302Headers> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    @Ignore("Not supported yet")
    public void patch302() throws Exception {
        client.httpRedirects().patch302WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPatch302Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPatch302Headers> response) {
                    Assert.assertEquals(302, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post303() throws Exception {
        client.httpRedirects().post303WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPost303Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPost303Headers> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void head307() throws Exception {
        client.httpRedirects().head307WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsHead307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsHead307Headers> response) {
                    Assert.assertEquals(200, response.headResponse().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void get307() throws Exception {
        client.httpRedirects().get307WithServiceResponseAsync()
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsGet307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsGet307Headers> response) {
                    Assert.assertEquals(200, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void put307() throws Exception {
        client.httpRedirects().put307WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPut307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPut307Headers> response) {
                    Assert.assertEquals(307, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void patch307() throws Exception {
        client.httpRedirects().patch307WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPatch307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPatch307Headers> response) {
                    Assert.assertEquals(307, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void post307() throws Exception {
        client.httpRedirects().post307WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsPost307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsPost307Headers> response) {
                    Assert.assertEquals(307, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void delete307() throws Exception {
        client.httpRedirects().delete307WithServiceResponseAsync(true)
            .subscribe(new Action1<ServiceResponseWithHeaders<Void, HttpRedirectsDelete307Headers>>() {
                @Override
                public void call(ServiceResponseWithHeaders<Void, HttpRedirectsDelete307Headers> response) {
                    Assert.assertEquals(307, response.response().code());
                    lock.countDown();
                }
            });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }
}
