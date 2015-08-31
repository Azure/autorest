package fixtures.bodycomplex;

import com.microsoft.rest.ServiceException;
import fixtures.bodycomplex.models.ArrayWrapper;
import fixtures.bodycomplex.models.Basic;
import fixtures.bodycomplex.models.CMYKColors;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ArrayTests {
    static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        ArrayWrapper result = client.getArray().getValid();
        Assert.assertEquals(5, result.getArray().size());
        Assert.assertEquals("&S#$(*Y", result.getArray().get(3));
    }

    @Test
    public void putValid() throws Exception {
        ArrayWrapper body = new ArrayWrapper();
        body.setArray(Arrays.asList("1, 2, 3, 4", "", null, "&S#$(*Y", "The quick brown fox jumps over the lazy dog"));
        client.getArray().putValid(body);
    }

    @Test
    public void getEmpty() throws Exception {
        ArrayWrapper result = client.getArray().getEmpty();
        Assert.assertEquals(0, result.getArray().size());
    }

    @Test
    public void putEmpty() throws Exception {
        ArrayWrapper body = new ArrayWrapper();
        body.setArray(new ArrayList<String>());
        client.getArray().putEmpty(body);
    }

    @Test
    public void getNotProvided() throws Exception {
        ArrayWrapper result = client.getArray().getNotProvided();
        Assert.assertNull(result.getArray());
    }
}
