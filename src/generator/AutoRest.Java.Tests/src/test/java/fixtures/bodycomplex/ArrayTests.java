package fixtures.bodycomplex;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.ArrayWrapper;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;

public class ArrayTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        ArrayWrapper result = client.arrays().getValid();
        Assert.assertEquals(5, result.array().size());
        Assert.assertEquals("&S#$(*Y", result.array().get(3));
    }

    @Test
    public void putValid() throws Exception {
        ArrayWrapper body = new ArrayWrapper();
        body.withArray(Arrays.asList("1, 2, 3, 4", "", null, "&S#$(*Y", "The quick brown fox jumps over the lazy dog"));
        client.arrays().putValid(body);
    }

    @Test
    public void getEmpty() throws Exception {
        ArrayWrapper result = client.arrays().getEmpty();
        Assert.assertEquals(0, result.array().size());
    }

    @Test
    public void putEmpty() throws Exception {
        ArrayWrapper body = new ArrayWrapper();
        body.withArray(new ArrayList<String>());
        client.arrays().putEmpty(body);
    }

    @Test
    public void getNotProvided() throws Exception {
        ArrayWrapper result = client.arrays().getNotProvided();
        Assert.assertNull(result.array());
    }
}
