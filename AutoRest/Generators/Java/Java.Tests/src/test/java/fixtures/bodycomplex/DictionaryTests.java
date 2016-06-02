package fixtures.bodycomplex;

import fixtures.bodycomplex.models.DictionaryWrapper;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

public class DictionaryTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        DictionaryWrapper result = client.getDictionaryOperations().getValid().getBody();
        Assert.assertEquals(5, result.getDefaultProgram().size());
        Assert.assertEquals("", result.getDefaultProgram().get("exe"));
        Assert.assertEquals(null, result.getDefaultProgram().get(""));
    }

    @Test
    public void putValid() throws Exception {
        DictionaryWrapper body = new DictionaryWrapper();
        Map<String, String> programs = new HashMap<String, String>();
        programs.put("txt", "notepad");
        programs.put("bmp", "mspaint");
        programs.put("xls", "excel");
        programs.put("exe", "");
        programs.put("", null);
        body.setDefaultProgram(programs);
        client.getDictionaryOperations().putValid(body);
    }

    @Test
    public void getEmpty() throws Exception {
        DictionaryWrapper result = client.getDictionaryOperations().getEmpty().getBody();
        Assert.assertEquals(0, result.getDefaultProgram().size());
    }

    @Test
    public void putEmpty() throws Exception {
        DictionaryWrapper body = new DictionaryWrapper();
        body.setDefaultProgram(new HashMap<String, String>());
        client.getDictionaryOperations().putEmpty(body);
    }

    @Test
    public void getNull() throws Exception {
        DictionaryWrapper result = client.getDictionaryOperations().getNull().getBody();
        Assert.assertNull(result.getDefaultProgram());
    }

    @Test
    public void getNotProvided() throws Exception {
        DictionaryWrapper result = client.getDictionaryOperations().getNotProvided().getBody();
        Assert.assertNull(result.getDefaultProgram());
    }
}
