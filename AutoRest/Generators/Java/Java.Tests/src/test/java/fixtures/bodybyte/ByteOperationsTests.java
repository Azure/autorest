package fixtures.bodybyte;

import com.fasterxml.jackson.core.JsonParseException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ByteOperationsTests {
    private static AutoRestSwaggerBATByteService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATByteServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getByteOperations().getNull().getBody());
    }

    @Test
    public void getEmpty() throws Exception {
        byte[] result = client.getByteOperations().getEmpty().getBody();
        Assert.assertEquals(0, result.length);
    }

    @Test
    public void getNonAscii() throws Exception {
        byte[] result = client.getByteOperations().getNonAscii().getBody();
        byte[] expected = new byte[] {
                (byte) 0xff, (byte) 0xfe, (byte) 0xfd, (byte) 0xfc, (byte) 0xfb,
                (byte) 0xfa, (byte) 0xf9, (byte) 0xf8, (byte) 0xf7, (byte) 0xf6
        };
        Assert.assertArrayEquals(expected, result);
    }

    @Test
    public void putNonAscii() throws Exception {
        byte[] body = new byte[] {
                (byte) 0xff, (byte) 0xfe, (byte) 0xfd, (byte) 0xfc, (byte) 0xfb,
                (byte) 0xfa, (byte) 0xf9, (byte) 0xf8, (byte) 0xf7, (byte) 0xf6
        };
        client.getByteOperations().putNonAscii(body);
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getByteOperations().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getClass());
        }
    }
}
