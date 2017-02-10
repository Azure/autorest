package fixtures.bodystring;

import com.microsoft.rest.RestException;
import com.microsoft.rest.ServiceCallback;
import fixtures.bodystring.implementation.AutoRestSwaggerBATServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class StringOperationsTests {
    private static AutoRestSwaggerBATService client;
    private CountDownLatch lock = new CountDownLatch(1);

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.strings().getNull());
    }

    @Test
    public void putNull() throws Exception {
        try {
            client.strings().putNull(null);
        } catch (Exception ex) {
            Assert.assertEquals(IllegalArgumentException.class, ex.getClass());
            Assert.assertTrue(ex.getMessage().contains("Body parameter value must not be null"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        String result = client.strings().getEmpty();
        Assert.assertEquals("", result);
    }

    @Test
    public void putEmpty() throws Exception {
        client.strings().putEmptyAsync("", new ServiceCallback<Void>() {
            @Override
            public void failure(Throwable t) {
            }

            @Override
            public void success(Void response) {
                lock.countDown();
            }
        });
        Assert.assertTrue(lock.await(1000, TimeUnit.MILLISECONDS));
    }

    @Test
    public void getMbcs() throws Exception {
        String result = client.strings().getMbcs();
        String expected = "啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑ\uE7C7ɡ〇〾⿻⺁\uE843䜣\uE864€";
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putMbcs() throws Exception {
        String content = "啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑ\uE7C7ɡ〇〾⿻⺁\uE843䜣\uE864€";
        client.strings().putMbcs(content);
    }

    @Test
    public void getWhitespace() throws Exception {
        String result = client.strings().getWhitespace();
        Assert.assertEquals("    Now is the time for all good men to come to the aid of their country    ", result);
    }

    @Test
    public void putWhitespace() throws Exception {
        client.strings().putWhitespace("    Now is the time for all good men to come to the aid of their country    ");
    }

    @Test
    public void getNotProvided() throws Exception {
        try {
            client.strings().getNotProvided();
        } catch (Exception ex) {
            Assert.assertEquals(RestException.class, ex.getClass());
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getBase64Encoded() throws Exception {
        byte[] result = client.strings().getBase64Encoded();
        Assert.assertEquals("a string that gets encoded with base64", new String(result));
    }

    @Test
    public void getBase64UrlEncoded() throws Exception {
        byte[] result = client.strings().getBase64UrlEncoded();
        Assert.assertEquals("a string that gets encoded with base64url", new String(result));
    }

    @Test
    public void getNullBase64UrlEncoded() throws Exception {
        byte[] result = client.strings().getNullBase64UrlEncoded();
        Assert.assertNull(result);
    }

    @Test
    public void putBase64UrlEncoded() throws Exception {
        client.strings().putBase64UrlEncoded("a string that gets encoded with base64url".getBytes());
    }
}
