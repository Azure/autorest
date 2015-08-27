package fixtures.bodybyte;

import com.microsoft.rest.ServiceException;
import fixtures.bodyboolean.AutoRestBoolTestService;
import fixtures.bodyboolean.AutoRestBoolTestServiceImpl;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ByteOperationsTests {
    static AutoRestSwaggerBATByteService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATByteServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getByteOperations().getNull());
    }

    @Test
    public void getEmpty() throws Exception {
        byte[] result = client.getByteOperations().getEmpty();
        Assert.assertEquals(0, result.length);
    }

    @Test
    public void getNonAscii() throws Exception {
        byte[] result = client.getByteOperations().getNonAscii();
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
            Assert.assertEquals(ServiceException.class, exception.getClass());
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }
}
