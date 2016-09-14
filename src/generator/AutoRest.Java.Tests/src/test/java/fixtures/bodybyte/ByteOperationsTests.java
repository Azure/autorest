package fixtures.bodybyte;

import com.fasterxml.jackson.core.JsonParseException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodybyte.implementation.AutoRestSwaggerBATByteServiceImpl;

public class ByteOperationsTests {
    private static AutoRestSwaggerBATByteService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATByteServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.bytes().getNull());
    }

    @Test
    public void getEmpty() throws Exception {
        byte[] result = client.bytes().getEmpty();
        Assert.assertEquals(0, result.length);
    }

    @Test
    public void getNonAscii() throws Exception {
        byte[] result = client.bytes().getNonAscii();
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
        client.bytes().putNonAscii(body);
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.bytes().getInvalid();
            Assert.assertTrue(false);
        } catch (Exception exception) {
            // expected
            Assert.assertEquals(JsonParseException.class, exception.getCause().getClass());
        }
    }
}
