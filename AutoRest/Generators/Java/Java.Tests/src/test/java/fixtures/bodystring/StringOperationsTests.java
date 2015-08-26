package fixtures.bodystring;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import com.microsoft.rest.ServiceResponse;
import fixtures.bodyinteger.AutoRestIntegerTestService;
import fixtures.bodyinteger.AutoRestIntegerTestServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.nio.charset.Charset;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class StringOperationsTests {
    static AutoRestSwaggerBATService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getStringOperations().getNull());
    }

    @Test
    public void putNull() throws Exception {
        try {
            client.getStringOperations().putNull(null);
        } catch (Exception ex) {
            Assert.assertEquals(ServiceException.class, ex.getClass());
            Assert.assertTrue(ex.getCause().getMessage().contains("Body parameter value must not be null"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        String result = client.getStringOperations().getEmpty();
        Assert.assertEquals("", result);
    }

    @Test
    public void putEmpty() throws Exception {
        client.getStringOperations().putEmptyAsync("", new ServiceCallback<Void>() {
            @Override
            public void failure(ServiceException exception) {
            }

            @Override
            public void success(ServiceResponse<Void> response) {
                Assert.assertEquals(200, response.getResponse().getStatus());
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void getMbcs() throws Exception {
        String result = client.getStringOperations().getMbcs();
        String expected = "啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑ\uE7C7ɡ〇〾⿻⺁\uE843䜣\uE864€";
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putMbcs() throws Exception {
        String content = "啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑ\uE7C7ɡ〇〾⿻⺁\uE843䜣\uE864€";
        client.getStringOperations().putMbcs(content);
    }

    @Test
    public void getWhitespace() throws Exception {
        String result = client.getStringOperations().getWhitespace();
        Assert.assertEquals("    Now is the time for all good men to come to the aid of their country    ", result);
    }

    @Test
    public void putWhitespace() throws Exception {
        client.getStringOperations().putWhitespace("    Now is the time for all good men to come to the aid of their country    ");
    }

    @Test
    public void getNotProvided() throws Exception {
        try {
            client.getStringOperations().getNotProvided();
        } catch (Exception ex) {
            Assert.assertEquals(ServiceException.class, ex.getClass());
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }
}
