package fixtures.http;

import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;

import fixtures.http.implementation.AutoRestHttpInfrastructureTestServiceImpl;

public class HttpSuccessTests {
    private static AutoRestHttpInfrastructureTestService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestHttpInfrastructureTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void head200() throws Exception {
        client.httpSuccess().head200();
    }

    @Test
    public void get200() throws Exception {
        client.httpSuccess().get200();
    }

    @Test
    public void put200() throws Exception {
        client.httpSuccess().put200(true);
    }

    @Test
    public void patch200() throws Exception {
        client.httpSuccess().patch200(true);
    }

    @Test
    public void post200() throws Exception {
        client.httpSuccess().post200(true);
    }

    @Test
    public void delete200() throws Exception {
        client.httpSuccess().delete200(true);
    }

    @Test
    public void put201() throws Exception {
        client.httpSuccess().put201(true);
    }

    @Test
    public void post201() throws Exception {
        client.httpSuccess().post201(true);
    }

    @Test
    public void put202() throws Exception {
        client.httpSuccess().put202(true);
    }

    @Test
    public void patch202() throws Exception {
        client.httpSuccess().patch202(true);
    }

    @Test
    public void post202() throws Exception {
        client.httpSuccess().post202(true);
    }

    @Test
    public void delete202() throws Exception {
        client.httpSuccess().delete202(true);
    }

    @Test
    public void head204() throws Exception {
        client.httpSuccess().head204();
    }

    @Test
    public void put204() throws Exception {
        client.httpSuccess().put204(true);
    }

    @Test
    public void patch204() throws Exception {
        client.httpSuccess().patch204(true);
    }

    @Test
    public void post204() throws Exception {
        client.httpSuccess().post204(true);
    }

    @Test
    public void delete204() throws Exception {
        client.httpSuccess().delete204(true);
    }

    @Test
    public void head404() throws Exception {
        client.httpSuccess().head404();
    }
}
